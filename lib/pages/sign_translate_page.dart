import 'package:flutter/material.dart';
import 'package:gesture_vox_app/pages/background.dart';

class SignTranslatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Translator"),
      ),
      body: Center(
        child: Text(
          "Sign Translator Page",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
