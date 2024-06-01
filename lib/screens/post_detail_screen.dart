import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'bulletin.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;

  PostDetailScreen({required this.post});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late Post post;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    post = widget.post;
  }

  void _toggleLike() {
    setState(() {
      if (post.likes % 2 == 0) {
        post.likes++;
      } else {
        post.likes--;
      }
    });
  }

  void _addComment(String author, String content) {
    setState(() {
      post.comments++;
      post.commentsList.add({
        'author': author,
        'content': content,
        'createdAt': DateTime.now(),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            '@${post.author} • ${_timeAgo(post.createdAt)}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  if (post.imagePath != null)
                    Center(
                      child: Image.asset(post.imagePath!),
                    ),
                  SizedBox(height: 16.0),
                  Text(
                    post.content,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: _toggleLike,
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
                          // 좋아요 옆에 댓글 아이콘 배치
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/post_comment.svg',
                              color: Colors.purple,
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 4.0),
                            Text('${post.comments}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Divider(),
                  SizedBox(height: 8.0),
                  Text(
                    '댓글',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  _buildCommentsSection(),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    final List<Map<String, dynamic>> allComments = [
      ...post.commentsList,
      {'author': '김국민', 'content': '나 국민인데 쌌다.', 'createdAt': DateTime.now().subtract(Duration(minutes: 5))},
      {'author': '이윤석', 'content': '나 윤석인데 얘는 이길거같다 ㅋㅋ', 'createdAt': DateTime.now().subtract(Duration(minutes: 10))},
    ];

    return Column(
      children: allComments.map((comment) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/user_icon.png'),
                radius: 16.0,
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment['author'] as String,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                    ),
                    SizedBox(height: 4.0),
                    Text(comment['content'] as String),
                    SizedBox(height: 4.0),
                    Text(
                      _timeAgo(comment['createdAt'] as DateTime),
                      style: TextStyle(color: Colors.grey, fontSize: 12.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCommentInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: '댓글 달기',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: () {
              if (_commentController.text.isNotEmpty) {
                _addComment('사용자', _commentController.text);
                _commentController.clear();
              }
            },
            child: Icon(Icons.send),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple, // 버튼 배경색 딥퍼플
              foregroundColor: Colors.white, // 버튼 글씨 색상 흰색
              shape: CircleBorder(), // 원형 버튼
              padding: EdgeInsets.all(16.0),
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime dateTime) {
    final Duration difference = DateTime.now().difference(dateTime);
    if (difference.inMinutes < 1) {
      return '${difference.inSeconds}s 전';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m 전';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h 전';
    } else {
      return '${difference.inDays}d 전';
    }
  }
}
