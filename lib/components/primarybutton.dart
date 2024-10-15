import 'package:flutter/material.dart';

 class PrimaryButton extends StatelessWidget {
  // const PrimaryButton({super.key});
  final String title ;
  final Function onPressed ;
  bool loading ;

  PrimaryButton({required this.title, required this.onPressed , this.loading=false});

  @override
  Widget build(BuildContext context) {
    return Container(
    height: 60,
    width: double.infinity,
    child:  ElevatedButton(onPressed: (){
      onPressed();
    }, child:Text(title,style: TextStyle(color: Colors.white),),
    style:ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 231, 10, 128),textStyle: TextStyle(color: Colors.white),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)) )
    ,),
    );
  }
}