import 'package:flutter/material.dart';

class TextFieldCustomized extends StatefulWidget {
  final String text;
  final TextStyle style;
  final int maxLines;
  final TextEditingController controller;

  TextFieldCustomized({
    String text,
    TextStyle style,
    int maxLines,
    TextEditingController controller,
  })  : this.text = text,
        this.style = style,
        this.maxLines = maxLines,
        this.controller = controller;

  @override
  _TextFieldCustomizedState createState() =>
      new _TextFieldCustomizedState(text, style, maxLines, controller);
}

class _TextFieldCustomizedState extends State<TextFieldCustomized> {
  _TextFieldCustomizedState(
      this.text, this.style, this.maxLines, this.controller);
  final String text;
  final TextStyle style;
  final int maxLines;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: style,
      decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff40B491)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff40B491)),
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff40B491)),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          hintText: text),
      controller: controller,
      maxLines: maxLines,
    );
  }
}
