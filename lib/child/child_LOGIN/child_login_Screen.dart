// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter_application_3_mainproject/child/bottom_page.dart';
// import 'package:flutter_application_3_mainproject/child/child_LOGIN/RegisterAsChild.dart';
// import 'package:flutter_application_3_mainproject/components/customtextfield.dart';
// import 'package:flutter_application_3_mainproject/components/primarybutton.dart';
// import 'package:flutter_application_3_mainproject/components/secondarybutton.dart';
// import 'package:flutter_application_3_mainproject/db/shared_preferance.dart';
// import 'package:flutter_application_3_mainproject/parent_LOGIN/RegisterAsParent';
// import 'package:flutter_application_3_mainproject/parent_LOGIN/parent_home_Screen.dart';
// import 'package:flutter_application_3_mainproject/utils/constants.dart';


// class LoginScreen extends StatefulWidget {
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   bool isPasswordShown = true;
//   final _formKey = GlobalKey<FormState>();
//   final _formData = Map<String, Object>();
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//   }

//   _onSubmit() async {
//     _formKey.currentState!.save();

//     try {
//       if (mounted) {
//         setState(() {
//           isLoading = true;
//         });
//       }

//       UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _formData['email'].toString(),
//         password: _formData['password'].toString(),
//       );

//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }

//       if (userCredential.user != null) {
//         FirebaseFirestore.instance
//             .collection('users')
//             .doc(userCredential.user!.uid)
//             .get()
//             .then((value) {
//           if (mounted) {
//             print("====> ${value['type']}");
//             if (value['type'] == 'parent') {
//               MySharedPrefference.saveUserType('parent');
//               goToBox(context, ParentHomeScreen());
//             } else {
//               MySharedPrefference.saveUserType('child');
//               goToBox(context, BottomPage());
//             }
//           }
//         });
//       }
//     } on FirebaseAuthException catch (e) {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }

//       if (e.code == 'user-not-found') {
//         dialogueBox(context, 'No user found for that email.');
//         print('No user found for that email.');
//       } else if (e.code == 'wrong-password') {
//         dialogueBox(context, 'Wrong password provided for that user.');
//         print('Wrong password provided for that user.');
//       }
//     }

//     print(_formData['email']);
//     print(_formData['password']);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//           child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Stack(
//           children: [
//             isLoading
//                 ? progressIndicator(context)
//                 : SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         Container(
//                           height: MediaQuery.of(context).size.height * 0.3,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Text(
//                                 "USER LOGIN",
//                                 style: TextStyle(
//                                     fontSize: 40,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.pink),
//                               ),
//                               Image.asset(
//                                 'assets/login_logo.png',
//                                 height: 200,
//                                 width: 200,
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           height: MediaQuery.of(context).size.height * 0.4,
//                           child: Form(
//                             key: _formKey,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Customtextfield(
//                                   hintText: 'enter email',
//                                   textInputAction: TextInputAction.next,
//                                   keyboardType: TextInputType.emailAddress,
//                                   prefix: Icon(Icons.person),
//                                   onsave: (email) {
//                                     _formData['email'] = email ?? "";
//                                   },
//                                   validate: (email) {
//                                     if (email!.isEmpty ||
//                                         email.length < 3 ||
//                                         !email.contains("@")) {
//                                       return 'enter correct email';
//                                     }
//                                     return null ;
//                                   },
//                                 ),
//                                 Customtextfield(
//                                   hintText: 'enter password',
//                                   isPassword: isPasswordShown,
//                                   prefix: Icon(Icons.vpn_key_rounded),
//                                   validate: (password) {
//                                     if (password!.isEmpty ||
//                                         password.length < 7) {
//                                       return 'enter correct password';
//                                     }
//                                     return null;
//                                   },
//                                   onsave: (password) {
//                                     _formData['password'] = password ?? "";
//                                   },
//                                   suffix: IconButton(
//                                       onPressed: () {
//                                         setState(() {
//                                           isPasswordShown = !isPasswordShown;
//                                         });
//                                       },
//                                       icon: isPasswordShown
//                                           ? Icon(Icons.visibility_off)
//                                           : Icon(Icons.visibility)),
//                                 ),
//                                 PrimaryButton(
//                                     title: 'LOGIN',
//                                     onPressed: () {
//                                       // progressIndicator(context);
//                                       if (_formKey.currentState!.validate()) {
//                                         _onSubmit();
//                                       }
//                                     }),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Container(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "Frogot Password?",
//                                 style: TextStyle(fontSize: 18),
//                               ),
//                               Secondarybutton(
//                                   title: 'click here', onPressed: () {}),
//                             ],
//                           ),
//                         ),
//                         Secondarybutton(
//                             title: 'Register as child',
//                             onPressed: () {
//                               goToBox(context, RegisterChild());
//                             }),
//                         Secondarybutton(
//                             title: 'Register as Parent',
//                             onPressed: () {
//                               goToBox(context, RegisterParent());
//                             }),
//                         Secondarybutton(
//                             title: 'Enter in app',
//                             onPressed: () {
//                               goToBox(context, BottomPage());
//                             }),
//                       ],
//                     ),
//                   ),
//           ],
//         ),
//       )),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_3_mainproject/child/bottom_page.dart';
import 'package:flutter_application_3_mainproject/child/child_LOGIN/RegisterAsChild.dart';
import 'package:flutter_application_3_mainproject/components/customtextfield.dart';
import 'package:flutter_application_3_mainproject/components/primarybutton.dart';
import 'package:flutter_application_3_mainproject/components/secondarybutton.dart';
import 'package:flutter_application_3_mainproject/db/shared_preferance.dart';
import 'package:flutter_application_3_mainproject/parent_LOGIN/RegisterAsParent';
import 'package:flutter_application_3_mainproject/parent_LOGIN/parent_home_Screen.dart';
import 'package:flutter_application_3_mainproject/utils/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordShown = true;
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, String>();
  bool isLoading = false;


  _onSubmit() async {
    _formKey.currentState!.save();

    try {
      // progressIndicator(context);
      // if (mounted) {
        setState(() {
          isLoading = true;
        });
      // }

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _formData['email'].toString(),
        password: _formData['password'].toString(),
      );

      // if (mounted) {
      //   setState(() {
      //     isLoading = false;
      //   });
      // }

      if (userCredential.user != null) {
          setState(() {
          isLoading = false;
        });
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get()
            .then((value) {
              if(value['type'] == 'parent')
              {
                print(value['type']);
                MySharedPrefference.saveUserType('parent');
                goToBox(context, ParentHomeScreen());
              } else{
                MySharedPrefference.saveUserType('child');

         goToBox(context, BottomPage());
                
              }
            });
            //{
        //   if (mounted) {
        //     print("====> ${value['type']}");
        //     if (value['type'] == 'parent') {
        //       MySharedPrefference.saveUserType('parent');
        //       goToBox(context, ParentHomeScreen());
        //     } else {
        //       MySharedPrefference.saveUserType('child');
        //       goToBox(context, HomeScreen());
        //     }
        //   }
        // });
      }
    } on FirebaseAuthException catch (e) {
      // if (mounted) {
        setState(() {
          isLoading = false;
        });
      // }

      if (e.code == 'invalid-credential') {
        dialogueBox(context, 'No user found for that email.');
        print('No user found for that email.');
      } else if (e.code == 'invalid-email') {
        dialogueBox(context, 'Wrong password provided for that user.');
        print('Wrong password provided for that user.');
      }
     }

    print(_formData['email']);
    print(_formData['password']);
  }
  // _onSubmit() async {
    
  //   // if (!_formKey.currentState!.validate()) {
  //   //   return;
  //   // }
  //   _formKey.currentState!.save();

  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });

  //     // Attempt to sign in with Firebase Authentication
  //     UserCredential userCredential = await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(
  //       // email: _formData['email']!,
  //       // password: _formData['password']!,
  //         email: _formData['email'].toString(),
  //       password: _formData['password'].toString(),
  //     );

  //     // Check if the user exists and retrieve user data
  //     if (userCredential.user != null) {
  //        setState(() {
  //         isLoading = false;
  //       });
  //       goToBox(context, HomeScreen());
  //       // final userDoc = await
  //       FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(userCredential.user!.uid)
  //           .get();
            
            

  //       // if (userDoc.exists) {
  //       //   final userType = userDoc['type'];
  //       //   if (userType == 'parent') {
  //       //     MySharedPrefference.saveUserType('parent');
  //       //     goToBox(context, ParentHomeScreen());
  //       //   } else if (userType == 'child') {
  //       //     MySharedPrefference.saveUserType('child');
  //       //     goToBox(context, BottomPage());
  //       //   }
  //       // } else {
  //       //   throw FirebaseAuthException(
  //       //       code: 'user-not-found', message: 'No such user found');
  //       // }
  //     }
  //   } on FirebaseAuthException catch (e) {
  //      setState(() {
  //         isLoading = false;
  //       });
  //       if (e.code == 'user-not-found') {
  //     dialogueBox(context, 'No user found for that email.');
  //     print('No user found for that email.');
  //   } else if (e.code == 'wrong-password') {
  //     dialogueBox(context, 'Wrong password provided.');
  //     print('Wrong password provided');
  //   // } else {
  //   //   dialogueBox(context, 'Authentication error: ${e.message}');
  //    }
  //     // Handle Firebase authentication errors
  //     // _handleAuthError(e);

  //    }
     
  //    print(_formData['email']);
  //    print(_formData['password']);
  //    // catch (e) {
  //   //   // Catch any other unexpected errors
  //   //   dialogueBox(context, 'Something went wrong. Please try again.');
  //   // } finally {
  //   //   if (mounted) {
  //   //     setState(() {
  //   //       isLoading = false;
  //   //     });
  //   //   }
  //   // }
  // }

  // void _handleAuthError(FirebaseAuthException e) {
  //   if (e.code == 'user-not-found') {
  //     dialogueBox(context, 'No user found for that email.');
  //   } else if (e.code == 'wrong-password') {
  //     dialogueBox(context, 'Wrong password provided.');
  //   } else {
  //     dialogueBox(context, 'Authentication error: ${e.message}');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              isLoading
                  ?progressIndicator(context)
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          // Top container with logo and title
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "USER LOGIN",
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink),
                                ),
                                Image.asset(
                                  'assets/login_logo.png',
                                  height: 200,
                                  width: 200,
                                ),
                              ],
                            ),
                          ),
                          // Form for email and password input
                          Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Customtextfield(
                                    hintText: 'Enter email',
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.emailAddress,
                                    prefix: Icon(Icons.person),
                                    onsave: (email) {
                                      _formData['email'] = email ?? "";
                                    },
                                    validate: (email) {
                                      if (email == null ||
                                          email.isEmpty ||
                                          !email.contains('@')) {
                                        return 'Enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  Customtextfield(
                                    hintText: 'Enter password',
                                    isPassword: isPasswordShown,
                                    prefix: Icon(Icons.vpn_key_rounded),
                                    validate: (password) {
                                      if (password == null ||
                                          password.isEmpty ||
                                          password.length < 7) {
                                        return 'Enter a valid password';
                                      }
                                      return null;
                                    },
                                    onsave: (password) {
                                      _formData['password'] = password ?? "";
                                    },
                                    suffix: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isPasswordShown = !isPasswordShown;
                                        });
                                      },
                                      icon: isPasswordShown
                                          ? Icon(Icons.visibility_off)
                                          : Icon(Icons.visibility),
                                    ),
                                  ),
                                  PrimaryButton(
                                    title: 'LOGIN',
                                    // onPressed: 
                                    onPressed: (){
                                     if ( _formKey.currentState!.validate()){
                                      _onSubmit();
                                     }
                                      
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Extra options (Forgot password, Register)
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Forgot Password?",
                                  style: TextStyle(fontSize: 18),
                                ),
                                Secondarybutton(
                                    title: 'Click here', onPressed: () {}),
                              ],
                            ),
                          ),
                          Secondarybutton(
                            title: 'Register as child',
                            onPressed: () {
                              goToBox(context, RegisterChild());
                            },
                          ),
                          Secondarybutton(
                            title: 'Register as Parent',
                            onPressed: () {
                              goToBox(context, RegisterParent());
                            },
                          ),
                          // Secondarybutton(
                          //   title: 'Enter in app',
                          //   onPressed: () {
                          //     goToBox(context, BottomPage());
                          //   },
                          // ),
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
