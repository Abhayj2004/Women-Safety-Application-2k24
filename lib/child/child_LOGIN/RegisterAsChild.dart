
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3_mainproject/child/child_LOGIN/child_login_Screen.dart';


import 'package:flutter_application_3_mainproject/components/customtextfield.dart';
import 'package:flutter_application_3_mainproject/components/primarybutton.dart';
import 'package:flutter_application_3_mainproject/components/secondarybutton.dart';
import 'package:flutter_application_3_mainproject/model/user_model.dart';
import 'package:flutter_application_3_mainproject/utils/constants.dart';


class RegisterChild extends StatefulWidget {
  @override
  State<RegisterChild> createState() => _RegisterchildScreenState();
}

class _RegisterchildScreenState extends State<RegisterChild> {
  bool isPasswordShown = false;
  bool isrPasswordShown = false;
  final _formkey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool isLoading = false;
  _onSubmit() async {
      _formkey.currentState!.save();
 if (_formData['password'] != _formData['rpassword']) {
      dialogueBox(context, "Password is not matching");
    } 
    else {
      progressIndicator(context);
             try{
              setState(() {
        isLoading = true;
      });
               UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _formData['cemail'].toString(),
                password: _formData['password'].toString());
                if(userCredential.user != null)
{
  final v = userCredential.user!.uid ;
DocumentReference<Map<String,dynamic>> db = 
   FirebaseFirestore.instance.collection('users').doc(v);
   final user = UserModel(
           name: _formData['name'].toString(),
           phone: _formData['phone'].toString(),
          childEmail: _formData['cemail'].toString(),
          guardianEmail: _formData['gemail'].toString(),
          id:v,
          type: 'child',
          );
  final jsonData = user.toJson();
  await db.set(jsonData).whenComplete(() {
goToBox(context, LoginScreen());
setState(() {
        isLoading = false;
      });
  });}
} on FirebaseAuthException catch (e) {
  setState(() {
        isLoading = false;
      });
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          dialogueBox(context, 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          dialogueBox(context, 'The account already exists for that email.');
        } 
}catch(e){
  print(e);
  setState(() {
        isLoading = false;
      });
  dialogueBox(context, e.toString());
}

  }
   print(_formData['email']);
      print(_formData['password']);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
               isLoading
                  ?progressIndicator(context)
                  :SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'REGISTER AS CHILD',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 45,
                              color: Colors.pink,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                         Image.asset('assets/main_logo.png',
                         height: 130,
                         width: 130,
                         )
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Form(
                        key: _formkey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                             Customtextfield(
                                     
                                      hintText: 'Name',
                                       textInputAction: TextInputAction.next,
                                      keyboardType:TextInputType.name,
                                      prefix: Icon(
                                        Icons.person,
                                        color: Colors.pink,
                                      ),
                                        onsave: (name) {
                                        _formData['name'] = name ?? "";
                                      },
                                       validate: (name) {
                                        if (name!.isEmpty ||
                                            name.length < 3 
                                            ) {
                                          return 'Enter correct name';
                                        }
                                        return null;
                                      },
                                    
                                     
                                    ),
                            
                           Customtextfield(
                                 
                                  hintText: 'Phone Number',
                                   textInputAction: TextInputAction.next,
                                  keyboardType:TextInputType.phone,
                                  prefix: Icon(
                                    Icons.person,
                                    color: Colors.pink,
                                  ),
                                    onsave: (phone) {
                                    _formData['phone'] = phone ?? "";
                                  },
                                   validate: (phone) {
                                    if (phone!.isEmpty ||
                                        phone.length < 10
                                        ) {
                                      return 'phone number should be 10 digit';
                                    }
                                    return null;
                                   },
                                ),
                           
                                
                           
                                 Customtextfield(
                                 
                                  hintText: 'Email',
                                   textInputAction: TextInputAction.next,
                                  keyboardType:TextInputType.emailAddress,
                                  prefix: Icon(
                                    Icons.person,
                                    color: Colors.pink,
                                  ),
                                    onsave: (email) {
                                    _formData['cemail'] = email ?? "";
                                  },
                                   validate: (email) {
                                    if (email!.isEmpty ||
                                        email.length < 3 ||
                                        !email.contains("@")) {
                                      return 'Enter correct email';
                                    }
                                    return null;
                                  },
                                
                                ),
                                  
                           
                                 Customtextfield(
                                 
                                  hintText: 'Guardians Email',
                                   textInputAction: TextInputAction.next,
                                  keyboardType:TextInputType.emailAddress,
                                  prefix: Icon(
                                    Icons.person,
                                    color: Colors.pink,
                                  ),
                                    onsave: (email) {
                                    _formData['gemail'] = email ?? "";
                                  },
                                   validate: (email) {
                                    if (email!.isEmpty ||
                                        email.length < 3 ||
                                        !email.contains("@")) {
                                      return 'Enter correct email';
                                    }
                                    return null;
                                  },
                                
                                ),
                           
                           
                                 Customtextfield( 
                                  hintText: 'Password',
                                  isPassword: isPasswordShown, // Hide the 
                                  // obscureText: !isPasswordShown,
                                  prefix: Icon(Icons.key, color: Colors.pink),
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
                                   validate: (password) {
                                    if (password!.isEmpty || password.length < 7) {
                                      return 'Enter correct password';
                                    }
                                    return null;
                                  },
                                  onsave: (password) {
                                    _formData['password'] = password ?? "";
                                  },
                                 
                                ),
                           
                                 Customtextfield( 
                                  hintText: 'Confirm Password',
                                  isPassword: isrPasswordShown, // Hide the 
                                  // obscureText: !isPasswordShown,
                                  prefix: Icon(Icons.key, color: Colors.pink),
                                  suffix: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isrPasswordShown = !isrPasswordShown;
                                      });
                                    },
                                    icon: isrPasswordShown
                                        ? Icon(Icons.visibility_off)
                                        : Icon(Icons.visibility),
                                  ),
                                   validate: (cpassword) {
                                    if (cpassword!.isEmpty || cpassword.length < 7) {
                                      return 'Enter correct password';
                                    }
                                    return null;
                                  },
                                  onsave: (cpassword) {
                                    _formData['rpassword'] = cpassword ?? "";
                                  },
                                 
                                ),
                                 PrimaryButton(
                              title: 'REGISTER',
                              onPressed: () {
                                _onSubmit();
                              },
                            ),
              
                             Secondarybutton(
                              title: 'login with your account',
                              onPressed: () {
                               
                               goToBox(context , LoginScreen());
                              },
                            ),
                            
                          ],
                        ),
                      ),
                    ),
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


