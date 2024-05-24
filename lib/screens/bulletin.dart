import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:academic_management/screens/post_detail_screen.dart';
import 'dart:io';
import 'create_post.dart';

class Post {
  final String title;
  final String content;
  final String? imagePath;
  final String author;

  Post({
    required this.title,
    required this.content,
    this.imagePath,
    required this.author,
  });
}

class BulletinBoardScreen extends StatefulWidget {
  @override
  _BulletinBoardScreenState createState() => _BulletinBoardScreenState();
}

class _BulletinBoardScreenState extends State<BulletinBoardScreen> {
  final List<Post> _posts = [
    Post(
      title: '첫 번째 게시물',
      content: '이것은 첫 번째 게시물의 내용입니다.',
      imagePath: 'assets/event1.png',
      author: '홍길동',
    ),
    Post(
      title: '두 번째 게시물',
      content: '두 번째 게시물의 내용은 더 많은 정보를 담고 있습니다.',
      imagePath: 'assets/event2.png',
      author: '이순신',
    ),
    Post(
      title: '세 번째 게시물',
      content: '세 번째 게시물의 내용입니다. 사진은 없습니다.',
      author: '김유신',
    ),
  ];

  void _addPost(String title, String content, File? image, String author) {
    String? imagePath = image?.path;
    setState(() {
      _posts.insert(
          0,
          Post(
              title: title,
              content: content,
              imagePath: imagePath,
              author: author));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '컴퓨터공학과 게시판',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CreatePostScreen(addPostCallback: _addPost),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _posts.isEmpty
                ? const Center(
                    child: Text(
                      'No posts yet',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      final post = _posts[index];
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          leading: post.imagePath != null
                              ? Image.asset(
                                  post.imagePath!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : null,
                          title: Text(
                            post.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.content,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${post.author}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PostDetailScreen(post: post),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
