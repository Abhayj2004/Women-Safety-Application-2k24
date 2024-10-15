import 'package:flutter/material.dart';

class Secondarybutton extends StatelessWidget {
  final String title ;
  final Function onPressed ;
 

  Secondarybutton({required this.title, required this.onPressed ,});
  @override
  Widget build(BuildContext context) {
    return Container(
      
      child: TextButton(onPressed: (){
        onPressed();
      },
      child: Text(title),),
    );
  }
}