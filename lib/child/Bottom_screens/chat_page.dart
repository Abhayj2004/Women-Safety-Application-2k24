// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_3_mainproject/chat_module/chat_screen.dart';
// import 'package:flutter_application_3_mainproject/child/child_LOGIN/child_login_Screen.dart';


// import 'package:flutter_application_3_mainproject/parent_LOGIN/parent_home_Screen.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:flutter_application_3_mainproject/chat_module/chat_screen.dart';



// import '../../utils/constants.dart';

// class CheckUserStatusBeforeChat extends StatelessWidget {
//   const CheckUserStatusBeforeChat({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         } else {
//           if (snapshot.hasData) {
//             print("===>${snapshot.data}");
//             return StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection("users")
//                   .where("id",
//                   isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//                   .snapshots(),
//               builder: (context, snap) {
//                 if (snap.connectionState == ConnectionState.waiting) {
//                   return CircularProgressIndicator();
//                 } else if (snap.hasData) {
//                   if (snap.data!.docs.first.data()['type'] == "parent") {
//                     return ParentHomeScreen();
//                   } else {
//                     return ChatPage();
//                   }
//                 }
//                 return SizedBox();
//               },
//             );
//             //return ChatPage();
//           } else {
//             Fluttertoast.showToast(msg: 'please login first');
//             return LoginScreen();
//           }
//         }
//       },
//     );
//    }
// }

// class ChatPage extends StatefulWidget {
//   const ChatPage({super.key});

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       setState(() {
//         if (FirebaseAuth.instance.currentUser == null ||
//             FirebaseAuth.instance.currentUser!.uid.isEmpty) {
//           if (mounted) {
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (_) => LoginScreen()));
//           }
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // WidgetsBinding.instance.addObserver();
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.pink,
//         // backgroundColor: Color.fromARGB(255, 250, 163, 192),
//         title: Text("SELECT GUARDIAN"),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .where('type', isEqualTo: 'parent')
//             .where('childEmail',
//             isEqualTo: FirebaseAuth.instance.currentUser!.email)
//             .snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: progressIndicator(context));
//           }
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (BuildContext context, int index) {
//               final d = snapshot.data!.docs[index];
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   color: Color.fromARGB(255, 250, 163, 192),
//                   child: ListTile(
//                     onTap: () {
//                       goToBox(
//                           context,
//                           ChatScreen(
//                               currentUserId:
//                               FirebaseAuth.instance.currentUser!.uid,
//                               friendId: d.id,
//                               friendName: d['name']));
//                       // Navigator.push(context, MaterialPa)
//                     },
//                     title: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(d['name']),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';

// // class ChatPage extends StatelessWidget {
// //   const ChatPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold();
// //   }
// // }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3_mainproject/chat_module/chat_screen.dart';
import 'package:flutter_application_3_mainproject/child/child_LOGIN/child_login_Screen.dart';
import 'package:flutter_application_3_mainproject/parent_LOGIN/parent_home_Screen.dart';
import 'package:flutter_application_3_mainproject/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';


class CheckUserStatusBeforeChat extends StatelessWidget {
  const CheckUserStatusBeforeChat({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // Firebase user is logged in, continue with the inner stream
          final userId = FirebaseAuth.instance.currentUser?.uid;
          if (userId == null) {
            Fluttertoast.showToast(msg: 'User not found. Please log in again.');
            return LoginScreen();
          }

          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where("id", isEqualTo: userId)
                .snapshots(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snap.hasData && snap.data!.docs.isNotEmpty) {
                final userData = snap.data!.docs.first.data();
                if (userData['type'] == "parent") {
                  return const ParentHomeScreen();
                } else {
                  return const ChatPage();
                }
              } else {
                Fluttertoast.showToast(msg: 'No user data found.');
                return const SizedBox();
              }
            },
          );
        } else {
          // User is not logged in
          Fluttertoast.showToast(msg: 'Please log in first.');
          return  LoginScreen();
        }
      },
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null || currentUser.uid.isEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) =>  LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail == null) {
      return const Center(child: Text("User not logged in"));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text("SELECT GUARDIAN"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('type', isEqualTo: 'parent')
            .where('childEmail', isEqualTo: userEmail)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: progressIndicator(context));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No guardians found."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final doc = snapshot.data!.docs[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: const Color.fromARGB(255, 250, 163, 192),
                  child: ListTile(
                    onTap: () {
                      goToBox(
                        context,
                        ChatScreen(
                          currentUserId: FirebaseAuth.instance.currentUser!.uid,
                          friendId: doc.id,
                          friendName: doc['name'],
                        ),
                      );
                    },
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(doc['name']),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

