

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';  // Permission handling

class CameraFeaturee extends StatefulWidget {
  const CameraFeaturee({Key? key}) : super(key: key);

  @override
  State<CameraFeaturee> createState() => _CameraFeatureState();
}

class _CameraFeatureState extends State<CameraFeaturee> {
  List<CameraDescription> cameras = [];
  CameraController? controller;
  List<String> frontImages = [];
  List<String> backImages = [];
  int currentCameraIndex = 0;
  bool isCapturing = false;
  String? userID ;

  late GoogleSignIn _googleSignIn;
  drive.DriveApi? _driveApi;
  bool isSignedIn = false;
  String signInStatus = 'Not signed in';
  String? userFolderId="";

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn(scopes: [drive.DriveApi.driveFileScope]);
    requestPermissions();  // Step 1: Request permissions
    initializeCamera();
    checkSignInStatus();
  }

  /// Step 1: Request permissions
  Future<void> requestPermissions() async {
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      setState(() {
        signInStatus = 'Camera permission not granted';
      });
      return;
    }
    print('Camera permission granted.');
  }

  /// Check if user is signed in and initialize if necessary
  Future<void> checkSignInStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool? signedIn = prefs.getBool('isSignedIn');
      if (signedIn == true) {
        await _silentSignIn();
      }
      setState(() {
        isSignedIn = signedIn ?? false;
      });
    } catch (e) {
      print('Error checking sign-in status: $e');
      setState(() {
        signInStatus = 'Error checking sign-in status: $e';
      });
    }
  }

  Future<void> _silentSignIn() async {
    try {
      final account = await _googleSignIn.signInSilently();
      if (account != null) {
        await _initializeDriveApi();
        setState(() {
          isSignedIn = true;
          signInStatus = 'Signed in silently as ${account.email}';
        });
      } else {
        setState(() {
          signInStatus = 'Silent sign-in failed';
        });
      }
    } catch (e) {
      print('Error during silent sign-in: $e');
      setState(() {
        signInStatus = 'Error during silent sign-in: $e';
      });
    }
  }

  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        await switchCamera(0);
      } else {
        setState(() {
          signInStatus = 'No cameras available';
        });
      }
    } catch (e) {
      print('Error initializing camera: $e');
      setState(() {
        signInStatus = 'Error initializing camera: $e';
      });
    }
  }

  Future<void> switchCamera(int cameraIndex) async {
    if (controller != null) {
      await controller!.dispose();
    }

    if (cameras.isEmpty) return;

    controller = CameraController(cameras[cameraIndex], ResolutionPreset.medium);
    try {
      await controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      print('Error switching camera: $e');
      setState(() {
        signInStatus = 'Error switching camera: $e';
      });
    }
  }

  Future<void> _signInAndInitializeDriveApi() async {
    try {
      setState(() {
        signInStatus = 'Signing in...';
      });

      await _googleSignIn.signOut(); // Clear cached credentials
      final account = await _googleSignIn.signIn();
      if (account == null) {
        setState(() {
          signInStatus = 'Sign in cancelled';
        });
        return;
      }

      setState(() {
        signInStatus = 'Signed in as ${account.email}. Initializing Drive API...';
      });

      await _initializeDriveApi();

      // Save sign-in status
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isSignedIn', true);

      setState(() {
        isSignedIn = true;
        signInStatus = 'Signed in and Drive API initialized';
      });

      await _createUserFolder();
    } catch (e) {
      print('Detailed sign-in error: $e');
      setState(() {
        signInStatus = 'Error signing in: $e';
      });
    }
  }

  
  Future<void> _initializeDriveApi() async {
    try {
      final httpClient = await _googleSignIn.authenticatedClient();

      if (httpClient == null) {
        setState(() {
          signInStatus = 'Failed to get authenticated client';
        });
        return;
      }
         
      _driveApi = drive.DriveApi(httpClient);
      setState(() {
        signInStatus = 'Drive API initialized';
        
        
       
      });
    } catch (e) {
      print('Error initializing Drive API: $e');
      setState(() {
        signInStatus = 'Error initializing Drive API: $e';
      });
    }

    
  }

  Future<void> _createUserFolder() async {
    try {
      if (_driveApi == null) {
        print('Drive API is not initialized');
        setState(() {
          signInStatus = 'Drive API not initialized';
        });
        return;
      }

      final folderMetadata = drive.File()
        ..name = 'User_Folder_${DateTime.now().millisecondsSinceEpoch}'
        ..mimeType = 'application/vnd.google-apps.folder';

      final folder = await _driveApi!.files.create(folderMetadata);
      print('Folder created with ID: ${folder.id}');

      setState(() {
        userFolderId = folder.id;
        signInStatus = 'Folder created: ${folder.name}';
      });
    } catch (e) {
      print('Error creating folder: $e');
      setState(() {
        signInStatus = 'Error creating folder: $e';
      });
    }
  }

   Future<void> _uploadImageToDrive(File imageFile) async {
    if (_driveApi == null) {
      setState(() {
        signInStatus = 'Drive API not initialized';
      });
      return;
    }

    final fileName = path.basename(imageFile.path);
    final driveFile = drive.File()
      ..name = fileName
      ..parents = [userFolderId!]; // Your Google Drive folder ID

    try {
      final result = await _driveApi!.files.create(
        driveFile,
        uploadMedia: drive.Media(imageFile.openRead(), imageFile.lengthSync()),
      );
      setState(() {
        signInStatus = 'File uploaded: ${result.name}';
      });
    } catch (e) {
      print('Error uploading file: $e');
      setState(() {
        signInStatus = 'Error uploading file: $e';
      });
    }   
  }

  Future<void> captureImages() async {
    await _createUserFolder();
    if (isCapturing) return;
    if (!isSignedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please sign in to Google Drive first')),
      );
      return;
    }

    setState(() {
      isCapturing = true;
      frontImages.clear();
      backImages.clear();
    });

    try {
      for (int i = 0; i < 2; i++) {
        await switchCamera(i);
        for (int j = 0; j < 4; j++) {
          if (controller == null || !controller!.value.isInitialized) continue;

          await Future.delayed(Duration(milliseconds: 500));

          final image = await controller!.takePicture();
          final imageFile = File(image.path);

          await _uploadImageToDrive(imageFile);

          setState(() {
            if (i == 0) {
              frontImages.add(image.path);
            } else {
              backImages.add(image.path);
            }
          });
        }
      }
    } catch (e) {
      print('Error during capture: $e');
      setState(() {
        signInStatus = 'Error during capture: $e';
      });
    } finally {
      await switchCamera(0); 
      setState(() => isCapturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: controller != null && controller!.value.isInitialized
              ? CameraPreview(controller!)
              : const Center(child: CircularProgressIndicator()),
        ),
        ElevatedButton(
          onPressed: isSignedIn ? (isCapturing ? null : captureImages) : _signInAndInitializeDriveApi,
          child: Text(isSignedIn
              ? (isCapturing ? 'Capturing...' : 'Capture All')
              : 'Sign in to Google Drive'),
        ),
        Text('Front Images: ${frontImages.length}/4',style: 
        TextStyle(fontSize:12,color: Colors.white,decoration:TextDecoration.none),),

        Text('Back Images: ${backImages.length}/4',style: TextStyle(fontSize: 12,color: Colors.white,decoration:TextDecoration.none),),
        Text(signInStatus,style: TextStyle(fontSize: 16,color: Colors.white,decoration:TextDecoration.none),textAlign: TextAlign.center,),
      ],
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
