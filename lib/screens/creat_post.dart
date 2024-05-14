import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreatePostScreen extends StatefulWidget {
  final Function(String, String, File?) addPostCallback;

  CreatePostScreen({required this.addPostCallback});

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final ImagePicker _picker = ImagePicker();
  String _title = '';
  String _content = '';
  File? _selectedImage;

  void _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _submitPost() {
    widget.addPostCallback(_title, _content, _selectedImage);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              onChanged: (value) {
                _title = value;
              },
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: 'Content'),
                onChanged: (value) {
                  _content = value;
                },
                maxLines: null,
                expands: true,
              ),
            ),
            SizedBox(height: 10),
            _selectedImage == null
                ? TextButton(
                    onPressed: _pickImage,
                    child: Text('Select Image'),
                  )
                : Image.file(
                    _selectedImage!,
                    height: 100,
                    width: 100,
                  ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitPost,
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
