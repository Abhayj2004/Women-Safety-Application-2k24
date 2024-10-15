
// import 'package:flutter/material.dart';
// import 'package:flutter_application_3_mainproject/RegisterAsParent';

// import 'package:flutter_application_3_mainproject/child/bottom_page.dart';
// import 'package:flutter_application_3_mainproject/child/child_LOGIN/RegisterAsChild.dart';
// import 'package:flutter_application_3_mainproject/components/customtextfield.dart';

// import 'package:flutter_application_3_mainproject/components/primarybutton.dart';
// import 'package:flutter_application_3_mainproject/components/secondarybutton.dart';

// import 'package:flutter_application_3_mainproject/utils/constants.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   bool isPasswordShown = false;
//   final _formkey = GlobalKey<FormState>();
//   final _formData = Map<String, Object>();
//   _onSubmit() {
//     if (_formkey.currentState!.validate()) {
//       _formkey.currentState!.save();
//       print(_formData['email']);
//       print(_formData['password']);
//     } else {
//       print('Form is invalid');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.3,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Text(
//                         'USER LOGIN',
//                         style: TextStyle(
//                           fontSize: 40,
//                           color: Colors.pink,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Container(
//                         height: 150,
//                         width: 150,
//                         child: CircleAvatar(
//                           backgroundImage: AssetImage("assets/main_logo.png"),
//                           backgroundColor: Colors.transparent,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.7,
//                   child: Form(
//                     key: _formkey,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Customtextfield(
                         
//                           hintText: 'Email',
//                            textInputAction: TextInputAction.next,
//                           keyboardType:TextInputType.emailAddress,
//                           prefix: Icon(
//                             Icons.person,
//                             color: Colors.pink,
//                           ),
//                             onsave: (email) {
//                             _formData['email'] = email ?? "";
//                           },
//                            validate: (email) {
//                             if (email!.isEmpty ||
//                                 email.length < 3 ||
//                                 !email.contains("@")) {
//                               return 'Enter correct email';
//                             }
//                             return null;
//                           },
                        
                         
//                         ),
//                         Customtextfield( 
//                           hintText: 'Password',
//                           isPassword: isPasswordShown, // Hide the 
//                           // obscureText: !isPasswordShown,
//                           prefix: Icon(Icons.key, color: Colors.pink),
//                           suffix: IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 isPasswordShown = !isPasswordShown;
//                               });
//                             },
//                             icon: isPasswordShown
//                                 ? Icon(Icons.visibility_off)
//                                 : Icon(Icons.visibility),
//                           ),
//                            validate: (password) {
//                             if (password!.isEmpty || password.length < 7) {
//                               return 'Enter correct password';
//                             }
//                             return null;
//                           },
//                           onsave: (password) {
//                             _formData['password'] = password ?? "";
//                           },
                         
//                         ),
//                         PrimaryButton(
//                           title: 'LOGIN',
//                           onPressed: () {
//                             _onSubmit();
//                           },
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Forgot password ?',
//                               style: TextStyle(fontSize: 18),
//                             ),
//                             Secondarybutton(
//                               title: 'Click here ',
//                               onPressed: () {},
//                             ),
//                           ],
//                         ),
//                         Secondarybutton(
//                           title: 'Register As Child',
//                           onPressed: () {
//                             goToBox(context , RegisterChild());
                            
//                           },
//                         ),
//                         Secondarybutton(
//                           title: 'Register As Parent',
//                           onPressed: () {
//                             goToBox(context , RegisterParent());
                           
//                           },
//                         ),
//                         Secondarybutton(
//                           title:"ENTER IN APP" 
//                         , onPressed: (){
//                           goToBox(context, BottomPage());
//                         })
//                         // Hbutton(
//                         //   title: 'Enter In APP',
//                         //   onPressed: () {},
//                         // ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

