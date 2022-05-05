import 'package:flutter/material.dart';

class TextFormWidget extends StatelessWidget {
  final String title;
  final TextEditingController controller;

  final Icon? prefixIcon;
  final IconButton? suffixiconButton;
  final bool withlabel, textAreaField;
  const TextFormWidget(
      {Key? key,
      required this.title,
      required this.controller,
      this.prefixIcon,
      this.withlabel = false,
      this.suffixiconButton,
      this.textAreaField = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return withlabel
        ? textField(context)
        : textAreaField
            ? textArea(context)
            : Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    prefixIcon: prefixIcon,
                    suffixIcon: suffixiconButton,
                    border: const OutlineInputBorder(),
                    labelText: title,
                  ),
                ));
  }

  Widget textField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              suffixIcon: suffixiconButton,
              border: UnderlineInputBorder(
                borderSide: BorderSide(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Padding(
            padding: const EdgeInsets.only(top: 7.0),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              controller: controller,
              minLines: 4,
              maxLines: null,
              decoration: InputDecoration(
                suffixIcon: suffixiconButton,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}