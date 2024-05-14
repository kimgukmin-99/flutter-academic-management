import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Post {
  final String title;
  final String content;
  final File? image;

  Post({required this.title, required this.content, this.image});
}

class BulletinBoardScreen extends StatefulWidget {
  @override
  _BulletinBoardScreenState createState() => _BulletinBoardScreenState();
}

class _BulletinBoardScreenState extends State<BulletinBoardScreen> {
  final List<Post> _posts = [];
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  void _addPost(String title, String content, File? image) {
    setState(() {
      _posts.add(Post(title: title, content: content, image: image));
      _selectedImage = null;
    });
  }

  void _showAddPostDialog() {
    String title = '';
    String content = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Content'),
                onChanged: (value) {
                  content = value;
                },
              ),
              SizedBox(height: 10),
              _selectedImage == null
                  ? TextButton(
                      onPressed: () async {
                        final pickedFile = await _picker.pickImage(
                            source: ImageSource.gallery);
                        if (pickedFile != null) {
                          setState(() {
                            _selectedImage = File(pickedFile.path);
                          });
                        }
                      },
                      child: Text('Select Image'),
                    )
                  : Image.file(
                      _selectedImage!,
                      height: 100,
                      width: 100,
                    ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedImage = null;
                });
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addPost(title, content, _selectedImage);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddPostDialog,
          ),
        ],
      ),
      body: _posts.isEmpty
          ? Center(
              child: Text(
                'No posts yet',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: post.image != null ? Image.file(post.image!) : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailScreen(post: post),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class PostDetailScreen extends StatelessWidget {
  final Post post;

  PostDetailScreen({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.content,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10),
            post.image != null ? Image.file(post.image!) : Container(),
          ],
        ),
      ),
    );
  }
}
