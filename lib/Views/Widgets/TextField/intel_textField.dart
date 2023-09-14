import 'package:flutter/material.dart';

class IntelTextField extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final bool? obsecureText;
  final int? maxLines;
  final double? height;

  const IntelTextField(
      {super.key,
      required this.controller,
      required this.title,
      this.height,
      this.obsecureText,
      this.maxLines});

  @override
  State<IntelTextField> createState() => _IntelTextFieldState();
}

class _IntelTextFieldState extends State<IntelTextField> {
  bool validator = true;

  // void checkValidation() {
  //   if (widget.type == "empty") {
  //     if (widget.controller.text.isEmpty) {
  //       setState(() {
  //         validator = false;
  //       });
  //     }
  //   }
  //   if (widget.type == "email") {
  //     if (!EmailValidator.validate(widget.controller.text)) {
  //       setState(() {
  //         validator = false;
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          widget.title,
          style: const TextStyle(
              fontSize: 14,
              color: Color(0xff65676b),
              fontWeight: FontWeight.w100),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          height: widget.height != null ? widget.maxLines == null ? widget.height : 40 : null,
          child: TextField(
            controller: widget.controller,
            obscureText: widget.obsecureText ?? false,
            maxLines: widget.maxLines ?? 1,
            decoration: InputDecoration(
              contentPadding: widget.maxLines != null ? null : EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.grey.shade400),
              ),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        // Poppins(
        //   text: widget.error,
        //   color: Color(0xffA94442),
        // )
      ],
    );
  }
}
