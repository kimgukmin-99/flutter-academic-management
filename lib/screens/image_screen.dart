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
        title: Text(eventName,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, // 백버튼 색상 설정
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: _getImageProvider(imagePath),
      ),
    );
  }

  Widget _getImageProvider(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return Image.asset(imagePath);
    } else {
      return Image.file(File(imagePath));
    }
  }
}
