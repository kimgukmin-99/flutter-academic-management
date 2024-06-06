import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:academic_management/screens/post_detail_screen.dart';
import 'package:academic_management/screens/create_post.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:academic_management/providers/person.dart';

class Post {
  final String id; // 고유 ID 추가
  final String title;
  final String content;
  final String studentId;
  final String userName;
  final DateTime createdAt;
  int likes;
  int comments;
  final String? imagePath;
  List<Map<String, dynamic>> commentsList;

  Post({
    required this.title,
    required this.content,
    required this.userName,
    required this.studentId,
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
    this.imagePath,
    List<Map<String, dynamic>>? commentsList,
  })  : id = Uuid().v4(), // 고유 ID 생성
        commentsList = commentsList ?? [];
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
      userName: '사용자1',
      studentId: '20180595',
      createdAt: DateTime.now().subtract(Duration(minutes: 2)),
      imagePath: null,
    ),
    Post(
      title: '형 가수했을때',
      content: '어느새 ~ 부터 ~ ',
      userName: '사용자2',
      studentId: '20180600',
      createdAt: DateTime.now().subtract(Duration(minutes: 25)),
      imagePath: 'assets/event1.png',
    ),
    Post(
      title: '형 전성기 ㅋ',
      content: '야 타',
      userName: '사용자3',
      studentId: '20180601',
      createdAt: DateTime.now().subtract(Duration(hours: 1)),
      imagePath: 'assets/event3.png',
    ),
  ];

  List<Post> getRecentPosts() {
    return posts.take(3).toList();
  }

  void _addPost(String title, String content, File? image, String author) {
    setState(() {
      posts.insert(
          0,
          Post(
            title: title,
            content: content,
            userName: author,
            studentId: userProfile.studentId,
            createdAt: DateTime.now(),
            imagePath: image?.path,
          ));
    });
  }

  void _updatePost(Post updatedPost) {
    setState(() {
      int index =
          posts.indexWhere((post) => post.id == updatedPost.id); // ID로 비교
      if (index != -1) {
        posts[index] = updatedPost;
      }
    });
  }

  void _deletePost(String postId) {
    setState(() {
      posts.removeWhere((post) => post.id == postId);
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            scrolledUnderElevation: 0,
            pinned: false,
            floating: true,
            snap: true,
            expandedHeight: 50.0,
            flexibleSpace: FlexibleSpaceBar(

              titlePadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),

              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '컴퓨터공학과 게시판',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CreatePostScreen(addPostCallback: _addPost),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index >= posts.length) return null;
                  final post = posts[index];
                  return _buildPost(context, post);
                },
                childCount: posts.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPost(BuildContext context, Post post) {
    return GestureDetector(
      onTap: () async {
        final updatedPost = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(
              post: post,
              onUpdate: (updatedPost) {
                setState(() {
                  _updatePost(updatedPost);
                });
              },
            ),
          ),
        );

        if (updatedPost != null) {
          _updatePost(updatedPost);
        }
      },
      child: Card(
        elevation: 3,
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 16.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/avatar.png'),
                  ),
                  SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@${post.studentId} • ${_timeAgo(post.createdAt)}',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  PopupMenuButton<String>(
                    onSelected: (String result) {
                      if (result == 'delete') {
                        _confirmDelete(context, post.id);
                      } else if (result == 'report') {
                        _reportPost();
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('삭제'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'report',
                        child: Text('신고'),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.content),
                  if (post.imagePath != null) ...[
                    SizedBox(height: 8.0),
                    Image.asset(post.imagePath!),
                  ],
                ],
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
                          post.likes % 2 == 0
                              ? Icons.favorite_border
                              : Icons.favorite,
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
                          builder: (context) => PostDetailScreen(
                            post: post,
                            onUpdate: (updatedPost) {
                              setState(() {
                                _updatePost(updatedPost);
                              });
                            },
                          ),
                        ),
                      );
                    },
                    splashColor: Colors.transparent,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/post_comment.svg',
                          color: Color(0xFFA2A2FF),
                          width: 20,
                          height: 20,
                        ),
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
                        SvgPicture.asset(
                          'assets/icons/post_save.svg',
                          color: Color(0xFFA2A2FF),
                          width: 20,
                          height: 20,
                        ),
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
                        SvgPicture.asset(
                          'assets/icons/post_share.svg',
                          color: Color(0xFFA2A2FF),
                          width: 20,
                          height: 20,
                        ),
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
      ),
    );
  }

  void _confirmDelete(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('게시글 삭제'),
          content: Text('정말로 이 게시글을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black), // 텍스트 색상 설정
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black), // 텍스트 색상 설정
              ),
              onPressed: () {
                _deletePost(postId);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('삭제되었습니다.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text('삭제'),
            ),
          ],
        );
      },
    );
  }

  void _reportPost() {
    // 신고 기능 구현
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('신고'),
        content: Text('이 게시글을 신고하시겠습니까?'),
        actions: [
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black), // 텍스트 색상 설정
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text('취소'),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black), // 텍스트 색상 설정
            ),
            onPressed: () {
              Navigator.of(context).pop();
              _showReportSuccessDialog();
            },
            child: Text('신고'),
          ),
        ],
      ),
    );
  }

  void _showReportSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '신고 접수 되었습니다.',
          style: TextStyle(
            fontSize: 16.0, // 글씨 크기를 원하는 크기로 조절하세요
          ),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black), // 텍스트 색상 설정
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text('확인'),
          ),
        ],
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
