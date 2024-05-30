import 'package:flutter/material.dart';
import 'package:academic_management/screens/post_detail_screen.dart';
import 'package:academic_management/screens/create_post.dart';
import 'dart:io';

class Post {
  final String title;
  final String content;
  final String author;
  final DateTime createdAt;
  int likes;
  int comments;
  final String? imagePath;
  List<Map<String, dynamic>> commentsList;

  Post({
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
    this.imagePath,
    List<Map<String, dynamic>>? commentsList,
  }) : commentsList = commentsList ?? [];
}

class BulletinBoardScreen extends StatefulWidget {
  @override
  _BulletinBoardScreenState createState() => _BulletinBoardScreenState();
}

class _BulletinBoardScreenState extends State<BulletinBoardScreen> {
  List<Post> posts = [
    Post(
      title: '제목이란거다',
      content: '게시물 이란거다',
      author: 'ㅎㅇ',
      createdAt: DateTime.now().subtract(Duration(minutes: 2)),
      imagePath: null,
    ),
    Post(
      title: '형 가수했을때',
      content: '어느새 ~ 부터 ~ ',
      author: '어 형이야',
      createdAt: DateTime.now().subtract(Duration(minutes: 25)),
      imagePath: 'assets/event1.png',
    ),
    Post(
      title: '형 전성기 ㅋ',
      content: '야 타',
      author: '나 학생회장임 ㅋ',
      createdAt: DateTime.now().subtract(Duration(hours: 1)),
      imagePath: 'assets/event3.png',
    ),
  ];

  void _addPost(String title, String content, File? image, String author) {
    setState(() {
      posts.insert(0, Post(
        title: title,
        content: content,
        author: author,
        createdAt: DateTime.now(),
        imagePath: image?.path,
      ));
    });
  }

  void _toggleLike(Post post) {
    setState(() {
      if (post.likes % 2 == 0) {
        post.likes++;
      } else {
        post.likes--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '컴퓨터공학과 게시판',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreatePostScreen(addPostCallback: _addPost),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0).copyWith(top: 0.0), // 상단 패딩 제거
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return _buildPost(context, post);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPost(BuildContext context, Post post) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/user_icon.png'),
                ),
                SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '@${post.author} • ${_timeAgo(post.createdAt)}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    // Add your onPressed code here!
                  },
                ),
              ],
            ),
            SizedBox(height: 8.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailScreen(post: post),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.content),
                  if (post.imagePath != null) ...[
                    SizedBox(height: 8.0),
                    Image.asset(post.imagePath!),
                  ],
                ],
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => _toggleLike(post),
                  splashColor: Colors.transparent,
                  child: Row(
                    children: [
                      Icon(
                        post.likes % 2 == 0 ? Icons.favorite_border : Icons.favorite,
                        color: post.likes % 2 == 0 ? Colors.grey : Colors.red,
                      ),
                      SizedBox(width: 4.0),
                      Text('${post.likes}'),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailScreen(post: post),
                      ),
                    );
                  },
                  splashColor: Colors.transparent,
                  child: Row(
                    children: [
                      Icon(Icons.comment, color: Colors.purple),
                      SizedBox(width: 4.0),
                      Text('${post.comments}'),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Add your onPressed code here for the bookmark action!
                  },
                  splashColor: Colors.transparent,
                  child: Row(
                    children: [
                      Icon(Icons.bookmark, color: Colors.purple),
                      SizedBox(width: 4.0),
                      Text('저장'),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Add your onPressed code here for the share action!
                  },
                  splashColor: Colors.transparent,
                  child: Row(
                    children: [
                      Icon(Icons.share, color: Colors.purple),
                      SizedBox(width: 4.0),
                      Text('공유하기'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dateTime) {
    final Duration difference = DateTime.now().difference(dateTime);
    if (difference.inMinutes < 1) {
      return '${difference.inSeconds}s';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}
