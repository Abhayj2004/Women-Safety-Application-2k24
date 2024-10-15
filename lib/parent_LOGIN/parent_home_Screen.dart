import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_3_mainproject/chat_module/chat_screen.dart';



import 'package:flutter_application_3_mainproject/child/child_LOGIN/child_login_Screen.dart';


class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Container(),
            ), // DrawerHeader

            ListTile(
              title: TextButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  } on FirebaseAuthException catch (e) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                },
                child: Text(
                    "SIGN OUT"
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.pink, // Use Colors class for colors
        title: Text("SELECT CHILD"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('type', isEqualTo: 'child')
            .where('guardiantEmail', isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator()); // Use CircularProgressIndicator
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final doc = snapshot.data!.docs[index]; // Use doc instead of d
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.pinkAccent, // Use Colors class for colors
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            currentUserId: FirebaseAuth.instance.currentUser!.uid,
                            friendId: doc.id,
                            friendName: doc['name'],
                          ),
                        ),
                      );
                    },
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(doc['name']),
                    ),
                  ),
                ), // Container
              ); // Padding
            },
          );
        },
      ),
    ); // Scaffold
  }
}
// import 'package:flutter/material.dart';

// class ParentHomeScreen extends StatelessWidget {
//   const ParentHomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text('parent screen'),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_3_mainproject/chat_module/chat_screen.dart';
// import 'package:flutter_application_3_mainproject/child/child_LOGIN/child_login_Screen.dart';
// import 'package:flutter_application_3_mainproject/utils/constants.dart';


// class ParentHomeScreen extends StatelessWidget {
//   const ParentHomeScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: Drawer(
//         child: Column(
//           children: [
//             DrawerHeader(
//               child: Container(),
//             ),
//             ListTile(
//               title: TextButton(
//                 onPressed: () async {
//                   try {
//                     await FirebaseAuth.instance.signOut();
//                     goToBox(context, LoginScreen());
//                   } on FirebaseAuthException catch (e) {
//                     dialogueBox(context, e.toString());
//                   }
//                 },
//                 child: const Text("SIGN OUT"),
//               ),
//             ),
//           ],
//         ),
//       ),
//       appBar: AppBar(
//         backgroundColor: Colors.pink,
//         title: const Text("SELECT CHILD"),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .where('type', isEqualTo: 'child')
//             .where('guardianEmail',
//                 isEqualTo: FirebaseAuth.instance.currentUser!.email)
//             .snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: progressIndicator(context));
//           }

//           // Display the list of children associated with the logged-in parent.
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (BuildContext context, int index) {
//               final d = snapshot.data!.docs[index];
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   color: const Color.fromARGB(255, 250, 163, 192),
//                   child: ListTile(
//                     onTap: () {
//                       // Navigate to the chat screen with the selected child.
//                       goToBox(
//                         context,
//                         ChatScreen(
//                           currentUserId: FirebaseAuth.instance.currentUser!.uid,
//                           friendId: d.id,
//                           friendName: d['name'],
//                         ),
//                       );
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
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Open a dialog to add a child's email.
//           showAddChildDialog(context);
//         },
//         backgroundColor: Colors.pink,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   void showAddChildDialog(BuildContext context) {
//     final TextEditingController emailController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Add Child"),
//           content: TextField(
//             controller: emailController,
//             decoration: const InputDecoration(
//               labelText: "Child's Email",
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () async {
//                 // Add child email to the parent in Firebase.
//                 String parentId = FirebaseAuth.instance.currentUser!.uid;
//                 String childEmail = emailController.text.trim();

//                 await addChildToParent(parentId, childEmail);
//                 Navigator.of(context).pop();
//                 dialogueBox(context, "Child added successfully.");
//               },
//               child: const Text("Add"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> addChildToParent(String parentId, String childEmail) async {
//     final firestore = FirebaseFirestore.instance;

//     try {
//       // Fetch parent data.
//       final parentSnapshot = await firestore.collection('users').doc(parentId).get();
//       if (parentSnapshot.exists) {
//         var parentData = parentSnapshot.data()!;
//         List<String> childEmails = List<String>.from(parentData['childEmails'] ?? []);
        
//         // Add the new child's email.
//         if (!childEmails.contains(childEmail)) {
//           childEmails.add(childEmail);
//         }

//         // Update parent document with the new list of child emails.
//         await firestore.collection('users').doc(parentId).update({
//           'childEmails': childEmails,
//         });
//       }
//     } catch (error) {
//       print("Error adding child: $error");
//     }
//   }
// }