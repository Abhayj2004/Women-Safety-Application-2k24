
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3_mainproject/db/db_service.dart';
import 'package:flutter_application_3_mainproject/model/contactsm.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:googleapis/drive/v2.dart';
// import 'package:googleapis/drive/v3.dart';
import 'package:googleapis/drive/v3.dart' as drive;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:background_sms/background_sms.dart';
import 'package:camera/camera.dart';
import 'dart:io';
// import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;
  Position? _currentPosition;
  String? _currentAddress;

  // List<CameraDescription> cameras = [];
  // CameraController? controller;
  // bool isCapturing = false;
  // String savePath = '';
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
    initSpeech();
    _getPermissions();
    _getCurrentLocation();
     _googleSignIn = GoogleSignIn(
      scopes: [drive.DriveApi.driveFileScope],
    );
     checkSignInStatus();
    initializeCamera();
  }

   Future<void> _getPermissions() async {
    await [
      Permission.sms,
      Permission.camera,
      Permission.locationWhenInUse,
      Permission.locationAlways,
    ].request();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
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
        _createUserFolder();
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
      ..parents = [userFolderId!];// Your Google Drive folder ID

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

  // Initialize camera
  // Future<void> initializeCamera() async {
  //   cameras = await availableCameras();
  //   if (cameras.isNotEmpty) {
  //     await switchCamera(0); // Default to front camera
  //   }
  //   await _initSavePath();
  // }

  // Switch between front and back cameras
  // Future<void> switchCamera(int cameraIndex) async {
  //   if (controller != null) {
  //     final oldController = controller;
  //     setState(() => controller = null);
  //     await oldController!.dispose();
  //   }

    // controller = CameraController(
    //   cameras[cameraIndex],
    //   ResolutionPreset.medium,
    // );

  //   try {
  //     await controller!.initialize();
  //     setState(() {});
  //   } catch (e) {
  //     print('Error initializing camera: $e');
  //   }
  // }

  // Initialize save path for images
  // Future<void> _initSavePath() async {
  //   final directory = await getExternalStorageDirectory();
  //   savePath = path.join(directory!.path, 'safety_app_images');
  //   await Directory(savePath).create(recursive: true);
  // }

  // Capture images from both front and back cameras
  // Future<void> captureImages() async {
  //   if (isCapturing) return;
  //   setState(() => isCapturing = true);

  //   try {
  //     for (int i = 0; i < 2; i++) { // Switch between front and back cameras
  //       await switchCamera(i);

  //       for (int j = 0; j < 4; j++) { // Capture 4 images per camera
  //         await Future.delayed(const Duration(milliseconds: 500));

  //         final image = await controller!.takePicture();
  //         final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
  //         final savedImage = File(path.join(savePath, fileName));
  //         await savedImage.writeAsBytes(await image.readAsBytes());

  //         print('Image saved at: ${savedImage.path}');
  //       }
  //     }
  //   } catch (e) {
  //     print('Error during capture: $e');
  //   } finally {
  //     await switchCamera(0); // Switch back to front camera
  //     setState(() => isCapturing = false);
  //   }
  // }

  // Handle speech result
  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = result.recognizedWords;
      _confidenceLevel = result.confidence;

      if (_wordsSpoken.toLowerCase().contains("help")) {
        _sendloc();
       captureImages();
        // captureImages(); // Capture images on "help"
      } else {
        print("Recognized: $_wordsSpoken");
      }
    });
  }

  // Start listening for voice input
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _confidenceLevel = 0;
    });
  }

  // Stop listening
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  // Request necessary permissions
 

  
  // Permissions and Location Methods
  // _getPermission() async => await [Permission.sms].request();

  _isPermissionGranted() async => await Permission.sms.status.isGranted;

  _getCurrentLocation() async {
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

  _getAddressFromLatLon() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = "${place.locality}, ${place.postalCode}, ${place.street}";
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  _sendSms(String phoneNumber, String message, {int? simSlot}) async {
    await BackgroundSms.sendMessage(
      phoneNumber: phoneNumber,
      message: message,
      simSlot: simSlot,
    ).then((SmsStatus status) {
      if (status.toString() == "SmsStatus.sent") {
        Fluttertoast.showToast(msg: "Sent");
      } else {
        Fluttertoast.showToast(msg: "Failed");
      }
    });
  }


  
  _sendloc() async {
  if (_currentPosition == null || _currentAddress == null) {
    Fluttertoast.showToast(msg: "Location is not available yet. Please wait.");
    return;
  }

  List<TContact> contactList = await DatabaseHelper().getContactList();
  String recipients = "";
  int i = 1;
  for (TContact contact in contactList) {
    recipients += contact.number;
    if (i != contactList.length) {
      recipients += ";";
      i++;
    }
  }

  // Ensure the location data is available before using it
  String messageBody =
      "https://www.google.com/maps/place/${_currentPosition!.latitude},${_currentPosition!.longitude} $_currentAddress";

  if (await _isPermissionGranted()) {
    for (TContact contact in contactList) {
      _sendSms("${contact.number}", "I am in trouble. $messageBody", simSlot: 1);
    }
  } else {
    Fluttertoast.showToast(msg: "SMS permission denied");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Safety App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _speechEnabled ? _startListening : null, 
              // isSignedIn ? (isCapturing ? null : captureImages) : _signInAndInitializeDriveApi,
              child: const Text("Start Listening"),
            ),
            ElevatedButton(
              onPressed: _speechEnabled ? _stopListening : null,
              child: const Text("Stop Listening"),
            ),
            const SizedBox(height: 20),
            Text(
              'Words spoken: $_wordsSpoken',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Confidence: ${(_confidenceLevel * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}





//******************************************************************************************************************************* */
// import 'package:flutter/material.dart';
// import 'package:flutter_application_3_mainproject/utils/constants.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_application_3_mainproject/db/db_service.dart';
// import 'package:flutter_application_3_mainproject/model/contactsm.dart';
// import 'package:background_sms/background_sms.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final SpeechToText _speechToText = SpeechToText();
//   bool _speechEnabled = false;
//   String _wordsSpoken = "";
//   double _confidenceLevel = 0;
//   Position? _currentPosition;
//   String? _currentAddress;

//   @override
//   void initState() {
//     super.initState();
//     initSpeech();
//     _getPermission();
//     _getCurrentLocation();
//   }

//   void initSpeech() async {
//     _speechEnabled = await _speechToText.initialize();
//     setState(() {});
//   }

//   void _startListening() async {
//     await _speechToText.listen(onResult: _onSpeechResult);
//     setState(() {
//       _confidenceLevel = 0;
//     });
//   }

//   void _stopListening() async {
//     await _speechToText.stop();
//     setState(() {});
//   }
  

//   void _onSpeechResult(result) {
//     setState(() {
//       _wordsSpoken = "${result.recognizedWords}";
//       _confidenceLevel = result.confidence;

//       if (_wordsSpoken.toLowerCase() == "help") {
//         _sendloc(); // Call _sendloc() when "help" is detected
//       captureImages();
//         print("Location sent");
//       } else {
//         print(_wordsSpoken);
//       }
//     });
//   }

//   // Permissions and Location Methods
//   _getPermission() async => await [Permission.sms].request();

//   _isPermissionGranted() async => await Permission.sms.status.isGranted;

//   _getCurrentLocation() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       Fluttertoast.showToast(msg: "Location permissions are denied");
//     }
//     if (permission == LocationPermission.deniedForever) {
//       Fluttertoast.showToast(
//           msg: "Location permissions are permanently denied");
//     }

//     Geolocator.getCurrentPosition(
//             desiredAccuracy: LocationAccuracy.high,
//             forceAndroidLocationManager: true)
//         .then((Position position) {
//       setState(() {
//         _currentPosition = position;
//         _getAddressFromLatLon();
//       });
//     }).catchError((e) {
//       Fluttertoast.showToast(msg: e.toString());
//     });
//   }

//   _getAddressFromLatLon() async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//           _currentPosition!.latitude, _currentPosition!.longitude);

//       Placemark place = placemarks[0];
//       setState(() {
//         _currentAddress = "${place.locality}, ${place.postalCode}, ${place.street}";
//       });
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }

//   _sendSms(String phoneNumber, String message, {int? simSlot}) async {
//     await BackgroundSms.sendMessage(
//       phoneNumber: phoneNumber,
//       message: message,
//       simSlot: simSlot,
//     ).then((SmsStatus status) {
//       if (status.toString() == "SmsStatus.sent") {
//         Fluttertoast.showToast(msg: "Sent");
//       } else {
//         Fluttertoast.showToast(msg: "Failed");
//       }
//     });
//   }


  // 
//   _sendloc() async {
//   if (_currentPosition == null || _currentAddress == null) {
//     Fluttertoast.showToast(msg: "Location is not available yet. Please wait.");
//     return;
//   }

//   List<TContact> contactList = await DatabaseHelper().getContactList();
//   String recipients = "";
//   int i = 1;
//   for (TContact contact in contactList) {
//     recipients += contact.number;
//     if (i != contactList.length) {
//       recipients += ";";
//       i++;
//     }
//   }

//   // Ensure the location data is available before using it
//   String messageBody =
//       "https://www.google.com/maps/place/${_currentPosition!.latitude},${_currentPosition!.longitude} $_currentAddress";

//   if (await _isPermissionGranted()) {
//     for (TContact contact in contactList) {
//       _sendSms("${contact.number}", "I am in trouble. $messageBody", simSlot: 1);
//     }
//   } else {
//     Fluttertoast.showToast(msg: "SMS permission denied");
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
        
//         backgroundColor: Colors.pink,
//         title: Center(
//           child: Text(
//             'Voice Command',
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.all(16),
//               child: Text(
//                 _speechToText.isListening
//                     ? "Listening..."
//                     : _speechEnabled
//                         ? "Tap the microphone to start listening..."
//                         : "Speech not available",
//                 style: TextStyle(fontSize: 20.0),
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 padding: EdgeInsets.all(16),
//                 child: Text(
//                   _wordsSpoken,
//                   style: const TextStyle(
//                     fontSize: 25,
//                     fontWeight: FontWeight.w300,
//                   ),
//                 ),
//               ),
//             ),
//             if (_speechToText.isNotListening && _confidenceLevel > 0)
//               Padding(
//                 padding: const EdgeInsets.only(
//                   bottom: 100,
//                 ),
//                 child: Text(
//                   "Confidence: ${(_confidenceLevel * 100).toStringAsFixed(1)}%",
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.w200,
//                   ),
//                 ),
//               )
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _speechToText.isListening ? _stopListening : _startListening,
//         tooltip: 'Listen',
//         child: Center(
//           child: Icon(
//             _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
//             color: Colors.white,
//             size: 50,
//           ),
//         ),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
// }

