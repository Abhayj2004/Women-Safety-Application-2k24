// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_application_3_mainproject/child/bottom_page.dart';
// import 'package:flutter_application_3_mainproject/child/child_LOGIN/child_login_Screen.dart';
// import 'package:flutter_application_3_mainproject/components/customtextfield.dart';
// import 'package:flutter_application_3_mainproject/components/primarybutton.dart';
// import 'package:flutter_application_3_mainproject/utils/constants.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:uuid/uuid.dart';




// class CheckUserStatusBeforeChatOnProfile extends StatelessWidget {
//   const CheckUserStatusBeforeChatOnProfile({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         } else {
//           if (snapshot.hasData) {
//             return ProfilePage();
//           } else {
//             Fluttertoast.showToast(msg: 'please login first');
//             return LoginScreen();
//           }
//         }
//       },
//     );
//   }
// }

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   TextEditingController nameC = TextEditingController();
//   TextEditingController guardianEmailC = TextEditingController();
//   TextEditingController childEmailC = TextEditingController();
//   TextEditingController phoneC = TextEditingController();

//   final key = GlobalKey<FormState>();
//   String? id;
//   String? profilePic;
//   String? downloadUrl;
//   bool isSaving = false;
//   getDate() async {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//         .get()
//         .then((value) {
//       setState(() { 
//         nameC.text = value.docs.first['name'];
//         childEmailC.text = value.docs.first['childEmail'];
//         guardianEmailC.text = value.docs.first['guardiantEmail'];
//         phoneC.text = value.docs.first['phone'];
//         id = value.docs.first.id;
//         profilePic = value.docs.first['profilePic'];
//       });
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     getDate();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: isSaving == true
//           ? Center(
//           child: CircularProgressIndicator(
//             backgroundColor: Colors.pink,
//           ))
//           : SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(18.0),
         
//           child: Form(
//               key: key,
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Text(
//                       "PROFILE",
//                       style: TextStyle(fontSize: 40),
//                     ),
//                     SizedBox(height: 15),
//                     GestureDetector(
//                       onTap: () async {
//                         final XFile? pickImage = await ImagePicker()
//                             .pickImage(
//                             source: ImageSource.gallery,
//                             imageQuality: 50);
//                         if (pickImage != null) {
//                           setState(() {
//                             profilePic = pickImage.path;
//                           });
//                         }
//                       },
//                       child: Container(
//                         child: profilePic == null
//                             ? CircleAvatar(
//                           backgroundColor: Colors.deepPurple,
//                           radius: 60,
//                           child: Center(
//                               child: Image.asset(
//                                 'assets/women_logo_login.png',
//                                 height: 100,
//                                 width: 100,
//                               )),
//                         )
//                             : profilePic!.contains('http')
//                             ? CircleAvatar(
//                           backgroundColor: Colors.deepPurple,
//                           radius: 80,
//                           backgroundImage:
//                           NetworkImage(profilePic!),
//                         )
//                             : CircleAvatar(
//                             backgroundColor: Colors.deepPurple,
//                             radius: 80,
//                             backgroundImage:
//                             FileImage(File(profilePic!))),
//                       ),
//                     ),
//                     SizedBox(height: 30),
//                     Customtextfield(
//                       controller: nameC,
//                       // hintText: nameC.text,
//                 hintText: "name",
//                       validate: (v) {
//                         if (v!.isEmpty) {
//                           return 'please enter your updated name';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 10),
//                     Customtextfield(
//                       controller: childEmailC,
//                       hintText: "child email",
//                       readOnly: true,
//                       validate: (v) {
//                         if (v!.isEmpty) {
//                           return 'please enter your updated name';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 10),
//                     Customtextfield(
//                       controller: guardianEmailC,
//                       hintText: "parent email",
//                       readOnly: true,
//                       validate: (v) {
//                         if (v!.isEmpty) {
//                           return 'please enter your updated name';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 10),
//                     Customtextfield(
//                       controller: phoneC,
//                       hintText: "Phone number",
//                       readOnly: true,
//                       validate: (v) {
//                         if (v!.isEmpty) {
//                           return 'please enter your updated name';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 25),
//                     PrimaryButton(
//                         title: "UPDATE",
//                         onPressed: () async {
//                           if (key.currentState!.validate()) {
//                             SystemChannels.textInput
//                                 .invokeMethod('TextInput.hide');
//                             profilePic == null
//                                 ? Fluttertoast.showToast(
//                                 msg: 'please select profile picture')
//                                 : update();
//                           }
//                         }),
// SizedBox(height: 25,),
//                         PrimaryButton(title: "Sign out ", onPressed:()async {
//                           try {
//                             await FirebaseAuth.instance.signOut();
//                             goToBox(context, LoginScreen());
//                           } on FirebaseAuthException catch(e){
//                             dialogueBox(context, e.toString());
//                           }
//                           })
//                   ],
//                 ),
//               )),
//         ),
//       ),
//     );
//   }

//   Future<String?> uploadImage(String filePath) async {
//     try {
//       final filenName = Uuid().v4();
//       final Reference fbStorage =
//       FirebaseStorage.instance.ref('profile').child(filenName);
//       final UploadTask uploadTask = fbStorage.putFile(File(filePath));
//       await uploadTask.then((p0) async {
//         downloadUrl = await fbStorage.getDownloadURL();
//       });
//       return downloadUrl;
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//     return null;
//   }

//   update() async {
//     setState(() {
//       isSaving = true;
//     });
//     uploadImage(profilePic!).then((value) {
//       Map<String, dynamic> data = {
//         'name': nameC.text,
//         'profilePic': downloadUrl,
//       };
//       FirebaseFirestore.instance
//           .collection('users')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .update(data);
//       setState(() {
//         isSaving = false;
//         goToBox(context, BottomPage());
//       });
//     });
//   }
// }

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_3_mainproject/child/bottom_page.dart';
import 'package:flutter_application_3_mainproject/child/child_LOGIN/child_login_Screen.dart';
import 'package:flutter_application_3_mainproject/components/customtextfield.dart';
import 'package:flutter_application_3_mainproject/components/primarybutton.dart';
import 'package:flutter_application_3_mainproject/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

// Replace with your custom widgets if any

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameC = TextEditingController();
  final TextEditingController guardianEmailC = TextEditingController();
  final TextEditingController childEmailC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();

  final GlobalKey<FormState> key = GlobalKey<FormState>();
  String? id;
  String? profilePic;
  String? downloadUrl;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    getDate(); // Fetch user data on widget creation.
  }

  @override
  void dispose() {
    nameC.dispose();
    guardianEmailC.dispose();
    childEmailC.dispose();
    phoneC.dispose();
    super.dispose();
  }

  // Fetch user data from Firestore.
  Future<void> getDate() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (snapshot.docs.isNotEmpty && mounted) {
        final userData = snapshot.docs.first;
        setState(() {
          nameC.text = userData['name'];
          childEmailC.text = userData['childEmail'];
          guardianEmailC.text = userData['guardiantEmail'];
          phoneC.text = userData['phone'];
          id = userData.id;
          profilePic = userData['profilePic'];
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error fetching data: $e');
    }
  }

  // Upload image to Firebase Storage.
  Future<String?> uploadImage(String filePath) async {
    try {
      final fileName = Uuid().v4();
      final Reference storageRef =
          FirebaseStorage.instance.ref('profile').child(fileName);
      final UploadTask uploadTask = storageRef.putFile(File(filePath));
      await uploadTask;
      return await storageRef.getDownloadURL();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return null;
    }
  }

  // Update user profile data in Firestore.
  Future<void> update() async {
    setState(() {
      isSaving = true;
    });

    try {
      final url = await uploadImage(profilePic!);
      if (url != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'name': nameC.text,
          'profilePic': url,
        });
      }

      if (mounted) {
        setState(() {
          isSaving = false;
        });
        goToBox(context, BottomPage());
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Update failed: $e');
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: isSaving
          ? const Center(
              child: CircularProgressIndicator(backgroundColor: Colors.pink),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: key,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "PROFILE",
                          style: TextStyle(fontSize: 40),
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () async {
                            final XFile? pickImage = await ImagePicker()
                                .pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 50);
                            if (pickImage != null && mounted) {
                              setState(() {
                                profilePic = pickImage.path;
                              });
                            }
                          },
                          child: Container(
                            child: profilePic == null
                                ? const CircleAvatar(
                                    backgroundColor: Colors.deepPurple,
                                    radius: 60,
                                    child: Center(
                                      child: Image(
                                        image: AssetImage(
                                            'assets/women_logo_login.png'),
                                        height: 100,
                                        width: 100,
                                      ),
                                    ),
                                  )
                                : profilePic!.contains('http')
                                    ? CircleAvatar(
                                        radius: 80,
                                        backgroundImage:
                                            NetworkImage(profilePic!),
                                      )
                                    : CircleAvatar(
                                        radius: 80,
                                        backgroundImage:
                                            FileImage(File(profilePic!)),
                                      ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Customtextfield(
                          controller: nameC,
                          hintText: "Name",
                          validate: (value) => value!.isEmpty
                              ? 'Please enter your name'
                              : null,
                        ),
                        const SizedBox(height: 10),
                        Customtextfield(
                          controller: childEmailC,
                          hintText: "Child Email",
                          readOnly: true,
                        ),
                        const SizedBox(height: 10),
                        Customtextfield(
                          controller: guardianEmailC,
                          hintText: "Guardian Email",
                          readOnly: true,
                        ),
                        const SizedBox(height: 10),
                        Customtextfield(
                          controller: phoneC,
                          hintText: "Phone Number",
                          readOnly: true,
                        ),
                        const SizedBox(height: 25),
                        PrimaryButton(
                          title: "Update",
                          onPressed: () async {
                            if (key.currentState!.validate()) {
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                              if (profilePic == null) {
                                Fluttertoast.showToast(
                                    msg: 'Please select a profile picture');
                              } else {
                                await update();
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 25),
                        PrimaryButton(
                          title: "Sign Out",
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance.signOut();
                              goToBox(context, LoginScreen());
                            } catch (e) {
                              dialogueBox(context, e.toString());
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  // Helper function to navigate to a new page.
  void goToBox(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
