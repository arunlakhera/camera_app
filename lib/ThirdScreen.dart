import 'dart:typed_data';

import 'package:flutter/material.dart';

class ThirdScreen extends StatelessWidget {
  final Uint8List imageData;

  ThirdScreen({Key key, this.imageData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Save Post'),
      ),
      body: SafeArea(
        child: Center(
          child: Image.memory(imageData, fit: BoxFit.fill),
        ),
      ),
    );
  }
}
