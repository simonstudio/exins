import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthTextFields extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String labelText;
  final bool? obscureText;
  final IconData icon;
  final double? labelSize;
  final double fontSize;
  final double iconSize;
  final double borderRadius;

  AuthTextFields(
      {Key? key,
      required this.controller,
      required this.keyboardType,
      this.labelSize,
      required this.icon,
      required this.fontSize,
      required this.iconSize,
      this.obscureText,
      required this.labelText, required this.borderRadius})
      : super(key: key);


  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: controller,
      textAlign: TextAlign.left,
      textInputAction: TextInputAction.none,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
      ),
      obscureText: obscureText ?? false,
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      textAlignVertical: TextAlignVertical.center,
      
      decoration: InputDecoration(

        contentPadding: EdgeInsets.only(bottom: 25),
        fillColor: const Color(0xffF0F2F5),
        filled: true,
        prefixIcon: Icon(
          icon,
          size: iconSize,
        ),
        prefixIconColor: Colors.black,
        labelText: labelText,
        labelStyle: GoogleFonts.poppins(
          fontSize: fontSize,
          color: Color(0xff767676),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
