import 'package:flutter/material.dart';

class TextFormWidget extends StatelessWidget {
  final String title;
  final TextEditingController controller;

  final Icon? prefixIcon;
  final IconButton? suffixiconButton;
  const TextFormWidget(
      {Key? key,
      required this.title,
      required this.controller,
      this.prefixIcon,
      this.suffixiconButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,          suffixIcon: suffixiconButton,
          border: const OutlineInputBorder(),
          labelText: title,
        ),
      ),
    );
  }
}
