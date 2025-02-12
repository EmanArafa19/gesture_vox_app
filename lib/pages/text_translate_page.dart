import 'package:flutter/material.dart';
import 'package:gesture_vox_app/pages/background.dart';

class TextTranslatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text Translator"),
      ),
      body: Center(
        child: Text(
          "Text Translator Page",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
