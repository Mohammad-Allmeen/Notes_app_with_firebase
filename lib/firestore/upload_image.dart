//image picker dependency - to pick image from gallery or access of the camera

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            width: 200,

          )
        ],
      ),
    );
  }
}
