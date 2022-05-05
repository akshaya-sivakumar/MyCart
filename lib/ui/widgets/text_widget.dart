import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String? text;
  final FontWeight? fontWeight;
  const TextWidget({
    Key? key,
    this.text,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text ?? "", style: TextStyle(fontWeight: fontWeight));
  }
}
