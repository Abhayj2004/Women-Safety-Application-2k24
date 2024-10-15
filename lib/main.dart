import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_3_mainproject/child/bottom_page.dart';
import 'package:flutter_application_3_mainproject/child/child_LOGIN/child_login_Screen.dart';
import 'package:flutter_application_3_mainproject/db/shared_preferance.dart';
import 'package:flutter_application_3_mainproject/parent_LOGIN/parent_home_Screen.dart';
import 'package:flutter_application_3_mainproject/utils/background_services.dart';
import 'package:flutter_application_3_mainproject/utils/constants.dart';






  void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 Platform.isAndroid ? await Firebase.initializeApp(
  options: const FirebaseOptions(
  apiKey: 'AIzaSyD-oBgQskg5W_tuxXbpptMd7oX3gur_u6c',
   appId: '1:91060988815:android:2eda8c806543b1fd74f9fa',
   messagingSenderId: '91060988815', 
   projectId: 'w-safe-fa12c',
   )
 )
:await Firebase.initializeApp();
await initializeService();
await MySharedPrefference.init();


await initializeService() ;


  runApp(const MyApp());
}
  


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      
      // home:BottomPage(),
       home:FutureBuilder(
        future: MySharedPrefference.getUserType() ,
        builder: (BuildContext context , AsyncSnapshot snapshot){
            if(snapshot.data==""){
             return LoginScreen();
          }
          if(snapshot.data=="child"){
             return BottomPage();
          }
          if(snapshot.data=="parent")
          {
            return ParentHomeScreen();
          }
          return progressIndicator(context);
        }
       
    
      )
   );
  }
}
//