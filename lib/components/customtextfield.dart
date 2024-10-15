

import 'package:flutter/material.dart';

class Customtextfield extends StatelessWidget {
  final String? hintText;
  final Widget? prefix;
  final Widget? suffix;
  final Function(String?)? onsave;
  final String? Function(String?)? validate;
  final bool? isPassword; // For password fields
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final TextEditingController? controller;
  final bool? readOnly ;

  Customtextfield({
    this.controller,
    this.maxLines,
    this.hintText,
    this.prefix,
    this.suffix,
    this.onsave,
    this.validate,
    this.isPassword = false, // Default to false if not specified
    this.textInputAction,
    this.keyboardType,
    this.readOnly ,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ?? false, // Hide input for passwords
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines ?? 1, // Default to 1 line if not specified
      // decoration: InputDecoration(
      //   labelText: hintText ?? "Enter string",
      //   prefixIcon: prefix,
      //   suffixIcon: suffix,
      //   enabledBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(30),
      //     borderSide: BorderSide(
      //       style: BorderStyle.solid,
      //       color: Color.fromARGB(255, 135, 147, 156),
      //     ),
      //   ),
      //   focusedBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(30),
      //     borderSide: BorderSide(
      //       style: BorderStyle.solid,
      //       color: Color.fromARGB(255, 40, 179, 249),
      //     ),
      //   ),
      //   errorBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(30),
      //     borderSide: BorderSide(
      //       style: BorderStyle.solid,
      //       color: Color.fromARGB(255, 67, 0, 252),
      //     ),
      //   ),
      // ),
      decoration: InputDecoration(
                        labelText: hintText ?? "Enter string",
                          prefixIcon: prefix,
                              suffixIcon: suffix,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 230, 36, 104),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 128, 124, 125),
                        ),
                      ),
                      // prefixIcon: Icon(
                      //   Icons.person,
                      //   color: Colors.pink,
                      // ),
                    ),
      validator: validate,
      onSaved: onsave,
    );
  }
}

