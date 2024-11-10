// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';
// import 'package:record/record.dart';

// class rec extends StatefulWidget {
//   const rec ({super.key});

//   @override
//   State<rec> createState() => _HomePageState();
// }

// class _HomePageState extends State<rec> {
//   final AudioRecorder audioRecorder = AudioRecorder();
//   final AudioPlayer audioPlayer = AudioPlayer();

//   String? recordingPath;
//   bool isRecording = false, isPlaying = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: _recordingButton(),
//       body: _buildUI(),
//     );
//   }

//   Widget _buildUI() {
//     return SizedBox(
//       width: MediaQuery.sizeOf(context).width,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           if (recordingPath != null)
//             MaterialButton(
//               onPressed: () async {
//                 if (audioPlayer.playing) {
//                   audioPlayer.stop();
//                   setState(() {
//                     isPlaying = false;
//                   });
//                 } else {
//                   await audioPlayer.setFilePath(recordingPath!);
//                   audioPlayer.play();
//                   setState(() {
//                     isPlaying = true;
//                   });
//                 }
//               },
//               color: Theme.of(context).colorScheme.primary,
//               child: Text(
//                 isPlaying
//                     ? "Stop Playing Recording"
//                     : "Start Playing Recording",
//                 style: const TextStyle(
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           if (recordingPath == null)
//             const Text(
//               "No Recording Found. :(",
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _recordingButton() {
//     return FloatingActionButton(
//       onPressed: () async {
//         if (isRecording) {
//           String? filePath = await audioRecorder.stop();
//           if (filePath != null) {
//             setState(() {
//               isRecording = false;
//               recordingPath = filePath;
//             });
//           }
//         } else {
//           if (await audioRecorder.hasPermission()) {
//             final Directory appDocumentsDir =
//                 await getApplicationDocumentsDirectory();
//             final String filePath =
//                 p.join(appDocumentsDir.path, "recording.wav");
//             await audioRecorder.start(
//               const RecordConfig(),
//               path: filePath,
//             );
//             setState(() {
//               isRecording = true;
//               recordingPath = null;
//             });
//           }
//         }
//       },
//       child: Icon(
//         isRecording ? Icons.stop : Icons.mic,
//       ),
//     );
//   }
// }
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';
// import 'package:record/record.dart';

// class rec extends StatefulWidget {
//   const rec ({super.key});

//   @override
//   State<rec> createState() => _HomePageState();
// }

// class _HomePageState extends State<rec> {
//   final AudioRecorder audioRecorder = AudioRecorder();
//   final AudioPlayer audioPlayer = AudioPlayer();

//   String? recordingPath;
//   bool isRecording = false, isPlaying = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: _recordingButton(),
//       body: _buildUI(),
//     );
//   }

//   Widget _buildUI() {
//     return SizedBox(
//       width: MediaQuery.sizeOf(context).width,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           if (recordingPath != null)
//             MaterialButton(
//               onPressed: () async {
//                 if (audioPlayer.playing) {
//                   audioPlayer.stop();
//                   setState(() {
//                     isPlaying = false;
//                   });
//                 } else {
//                   await audioPlayer.setFilePath(recordingPath!);
//                   audioPlayer.play();
//                   setState(() {
//                     isPlaying = true;
//                   });
//                 }
//               },
//               color: Theme.of(context).colorScheme.primary,
//               child: Text(
//                 isPlaying
//                     ? "Stop Playing Recording"
//                     : "Start Playing Recording",
//                 style: const TextStyle(
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           if (recordingPath == null)
//             const Text(
//               "No Recording Found. :(",
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _recordingButton() {
//     return FloatingActionButton(
//       onPressed: () async {
//         if (isRecording) {
//           String? filePath = await audioRecorder.stop();
//           if (filePath != null) {
//             setState(() {
//               isRecording = false;
//               recordingPath = filePath;
//             });
//           }
//         } else {
//           if (await audioRecorder.hasPermission()) {
//             final Directory appDocumentsDir =
//                 await getApplicationDocumentsDirectory();
//             final String filePath =
//                 p.join(appDocumentsDir.path, "recording.wav");
//             await audioRecorder.start(
//               const RecordConfig(),
//               path: filePath,
//             );
//             setState(() {
//               isRecording = true;
//               recordingPath = null;
//             });
//           }
//         }
//       },
//       child: Icon(
//         isRecording ? Icons.stop : Icons.mic,
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

class rec extends StatefulWidget {
  const rec({super.key});

  @override
  State<rec> createState() => _RecState();
}

class _RecState extends State<rec> {
  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();

  String? recordingPath;
  bool isRecording = false, isPlaying = false;

  late GoogleSignIn _googleSignIn;
  drive.DriveApi? _driveApi;
  bool isSignedIn = false;
  String signInStatus = 'Not signed in';
  String? userFolderId = "";

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn(scopes: [drive.DriveApi.driveFileScope]);
    _signInAndInitializeDriveApi();
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

      await _createUserFolder();
    } catch (e) {
      print('Sign-in error: $e');
      setState(() {
        signInStatus = 'Error signing in: $e';
      });
    }
  }

  Future<void> _createUserFolder() async {
    if (_driveApi == null) return;

    try {
      final folderMetadata = drive.File()
        ..name = 'Recordings_${DateTime.now().millisecondsSinceEpoch}'
        ..mimeType = 'application/vnd.google-apps.folder';

      final folder = await _driveApi!.files.create(folderMetadata);
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

  Future<void> _uploadRecordingToDrive(File recordingFile) async {
    if (_driveApi == null) {
      setState(() {
        signInStatus = 'Drive API not initialized';
      });
      return;
    }

    final fileName = p.basename(recordingFile.path);
    final driveFile = drive.File()
      ..name = fileName
      ..parents = [userFolderId!];

    try {
      final result = await _driveApi!.files.create(
        driveFile,
        uploadMedia: drive.Media(recordingFile.openRead(), recordingFile.lengthSync()),
      );
      setState(() {
        signInStatus = 'Recording uploaded: ${result.name}';
      });
    } catch (e) {
      print('Error uploading recording: $e');
      setState(() {
        signInStatus = 'Error uploading recording: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _recordingButton(),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (recordingPath != null)
            MaterialButton(
              onPressed: () async {
                if (audioPlayer.playing) {
                  await audioPlayer.stop();
                  setState(() {
                    isPlaying = false;
                  });
                } else {
                  await audioPlayer.setFilePath(recordingPath!);
                  await audioPlayer.play();
                  setState(() {
                    isPlaying = true;
                  });
                }
              },
              color: Theme.of(context).colorScheme.primary,
              child: Text(
                isPlaying ? "Stop Playing Recording" : "Start Playing Recording",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          if (recordingPath == null)
            const Text("No Recording Found. :("),
          Text(signInStatus),
        ],
      ),
    );
  }

  Widget _recordingButton() {
    return FloatingActionButton(
      onPressed: () async {
        if (isRecording) {
          String? filePath = await audioRecorder.stop();
          if (filePath != null) {
            setState(() {
              isRecording = false;
              recordingPath = filePath;
            });

            // Upload the recorded file to Google Drive after recording
            await _uploadRecordingToDrive(File(filePath));
          }
        } else {
          if (await audioRecorder.hasPermission()) {
            final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
            final String filePath = p.join(appDocumentsDir.path, "recording.wav");
            await audioRecorder.start(
              const RecordConfig(),
              path: filePath,
            );
            setState(() {
              isRecording = true;
              recordingPath = null;
            });
          }
        }
      },
      child: Icon(isRecording ? Icons.stop : Icons.mic),
    );
  }
}