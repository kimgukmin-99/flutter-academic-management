import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreatePostScreen extends StatefulWidget {
  final Function(String, String, File?, String) addPostCallback;

  CreatePostScreen({required this.addPostCallback});

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
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
    if (_titleController.text.isNotEmpty &&
        _contentController.text.isNotEmpty &&
        _authorController.text.isNotEmpty) {
      widget.addPostCallback(
        _titleController.text,
        _contentController.text,
        _selectedImage,
        _authorController.text,
      );
      Navigator.of(context).pop();
    } else {
      // 모든 필드가 채워지지 않으면 경고 메시지를 표시할 수 있습니다.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('모든 필드를 채워주세요'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('확인'),
            ),
          ],
        ),
      );
    }
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
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(labelText: 'Author'),
            ),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Content'),
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
