import 'package:flutter/material.dart';
import 'package:flutter_application_3_mainproject/child/Bottom_screens/home_screen.dart';


class Hbutton extends StatelessWidget {
  final Function onPressed ;
  final String title;
  Hbutton({required this.title,required this.onPressed });

  @override
  Widget build(BuildContext context) {
    return Container(
  
      child: TextButton(onPressed: (){
        onPressed(
          Navigator.push(
            context,
             MaterialPageRoute(
            builder: (context) => HomeScreen(),
            ),
            )
        
        );
      },
      child: Text(title),),
    );
  }
}
 
  // ElevatedButton(
  //             onPressed: () {
  //         Navigator.push(
  //           context,
  //            MaterialPageRoute(
  //           builder: (context) => HomeScreen(),
  //           ),
  //           );
  //       }
  //            )