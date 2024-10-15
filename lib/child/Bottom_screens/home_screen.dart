

import 'dart:io';

import 'package:background_sms/background_sms.dart';
import 'package:camera/camera.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3_mainproject/db/db_service.dart';
import 'package:flutter_application_3_mainproject/extra_activity/extraActivity.dart';
import 'package:flutter_application_3_mainproject/live_safe.dart';
import 'package:flutter_application_3_mainproject/model/contactsm.dart';
import 'package:flutter_application_3_mainproject/widgets/home_widgets/emergency.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:permission_handler/permission_handler.dart';
import 'package:shake/shake.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

import '../../SafeHome/SafeHome.dart';





class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? _currentPosition;
  String? _currentAddress;
  String savePath = '';
  List<CameraDescription> cameras = [];
  CameraController? controller;
  List<String> frontImages = [];
  List<String> backImages = [];
  int currentCameraIndex = 0;
  bool isCapturing = false;
  late GoogleSignIn _googleSignIn;
  drive.DriveApi? _driveApi;
  bool isSignedIn = false;
  String signInStatus = 'Not signed in';
String? userFolderId="";
  @override
  void initState() {
    super.initState();
    _getPermissions();
    _getCurrentLocation();
     initializeCamera();
        _googleSignIn = GoogleSignIn(
      scopes: [drive.DriveApi.driveFileScope],
    );
     checkSignInStatus();
    

    ShakeDetector detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        _sendloc();
        _createUserFolder();
        captureImages();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Shake!')),
        );
      },
      minimumShakeCount: 2,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
  }

   Future<void> _getPermissions() async {
    await [
      Permission.sms,
      Permission.camera,
      Permission.locationWhenInUse,
      Permission.locationAlways,
    ].request();
  }


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

      await _googleSignIn.signOut(); // Sign out first to clear any cached credentials
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
        // _createUserFolder();
        
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
          if (controller == null || !controller!.value.isInitialized) {
            print('Camera not initialized, skipping capture');
            continue;
          }

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
      await switchCamera(0);  // Switch back to front camera
      setState(() => isCapturing = false);
    }
  }



  Future<bool> _isPermissionGranted() async =>
      await Permission.sms.status.isGranted;

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      Fluttertoast.showToast(msg: "Location permissions are denied");
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: "Location permissions are permanently denied");
    }

    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLon();
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  Future<void> _getAddressFromLatLon() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.street}";
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> _sendSms(String phoneNumber, String message,
      {int? simSlot}) async {
    await BackgroundSms.sendMessage(
      phoneNumber: phoneNumber,
      message: message,
      simSlot: simSlot,
    ).then((SmsStatus status) {
      if (status == SmsStatus.sent) {
        Fluttertoast.showToast(msg: "Sent");
      } else {
        Fluttertoast.showToast(msg: "Failed");
      }
    });
  }

  Future<void> _sendloc() async {
    if (_currentPosition == null || _currentAddress == null) {
      Fluttertoast.showToast(
          msg: "Location is not available yet. Please wait.");
      return;
    }

    List<TContact> contactList = await DatabaseHelper().getContactList();
    String messageBody =
        "https://www.google.com/maps/place/${_currentPosition!.latitude},"
        "${_currentPosition!.longitude} $_currentAddress";

    if (await _isPermissionGranted()) {
      for (TContact contact in contactList) {
        _sendSms(contact.number, "I am in trouble. $messageBody", simSlot: 1);
      }
    } else {
      Fluttertoast.showToast(msg: "SMS permission denied");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'STAY SAFE',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 226, 8, 128),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Row(
                          children: [
                            Text(
                              "Emergency",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Emergency(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Row(
                          children: [
                            Text(
                              "Explore Livesafe",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    LiveSafe(),
                    SafeHome(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Row(
                          children: [
                            Text(
                              "Extra Activity",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Extraactivity(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
