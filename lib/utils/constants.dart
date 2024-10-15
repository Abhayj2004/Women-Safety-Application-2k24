import 'package:flutter/material.dart';

Color primaryColor = Color(0xfffc3b77);

void goToBox(BuildContext context, Widget nextScreen) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => nextScreen,
    ),
  );
}

dialogueBox(BuildContext context, String text) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(text),
    ),
  );
}
Widget progressIndicator(BuildContext context) {
  return Center(
    child: CircularProgressIndicator(
      backgroundColor:Colors.pink,
      color: Colors.red,
      strokeWidth: 7,
    ),
  );
}

// progressIndicator(BuildContext context){
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//    builder: (context) =>Center(child: CircularProgressIndicator())
//    );
// }

