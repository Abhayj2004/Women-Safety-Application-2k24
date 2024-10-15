// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'camera_feature.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Camera App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Camera Feature'),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       body: const Center(
//         child: CameraFeature(),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_application_3_mainproject/camera/camera_feature.dart';




class CapturePhoto extends StatelessWidget {
  const CapturePhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CameraFeaturee()
              ),
            ),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.pink,
                      const Color.fromARGB(255, 221, 112, 148),
                      const Color.fromARGB(255, 228, 207, 214)
                    ],
                  ),
                ),
                height: 170,
                width: 170,
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        child: Icon(
                          Icons.photo_camera,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "Capture Photos",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}