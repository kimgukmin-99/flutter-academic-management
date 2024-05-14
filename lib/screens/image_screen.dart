import 'package:flutter/material.dart';
import 'dart:io';

class ImageDetailScreen extends StatelessWidget {
  final String imagePath;
  final String eventName;

  ImageDetailScreen({required this.imagePath, required this.eventName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(eventName),
      ),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}
