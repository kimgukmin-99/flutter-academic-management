import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'bulletin.dart';
import 'package:academic_management/providers/person.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  final Function(Post) onUpdate; // 업데이트 콜백 추가

  PostDetailScreen({required this.post, required this.onUpdate});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late Post post;
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  int? _replyToIndex; // 대댓글을 달 댓글의 인덱스

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
    widget.onUpdate(post); // 업데이트 콜백 호출
  }

  void _addComment(String author, String content) {
    setState(() {
      post.comments++;
      post.commentsList.add({
        'author': userProfile.userName, // 수정: 사용자 이름
        'studentId': userProfile.studentId, // 수정: 사용자 학번
        'content': content,
        'createdAt': DateTime.now(),
        'likes': 0,
        'replies': [],
      });
    });
    widget.onUpdate(post); // 업데이트 콜백 호출
  }

  void _addReply(int commentIndex, String author, String content) {
    setState(() {
      post.commentsList[commentIndex]['replies'].add({
        'author': userProfile.userName, // 수정: 사용자 이름
        'studentId': userProfile.studentId, // 수정: 사용자 학번
        'content': content,
        'createdAt': DateTime.now(),
        'likes': 0,
      });
      post.comments = post.comments + 1; // 댓글 수 증가
    });
    widget.onUpdate(post); // 업데이트 콜백 호출
  }

  void _toggleCommentLike(int commentIndex) {
    setState(() {
      final comment = post.commentsList[commentIndex];
      if (comment['likes'] % 2 == 0) {
        comment['likes']++;
      } else {
        comment['likes']--;
      }
    });
    widget.onUpdate(post); // 업데이트 콜백 호출
  }

  void _toggleReplyLike(int commentIndex, int replyIndex) {
    setState(() {
      final reply = post.commentsList[commentIndex]['replies'][replyIndex];
      if (reply['likes'] % 2 == 0) {
        reply['likes']++;
      } else {
        reply['likes']--;
      }
    });
    widget.onUpdate(post); // 업데이트 콜백 호출
  }

  void _deleteComment(int index) {
    setState(() {
      int replyCount = post.commentsList[index]['replies'].length;
      post.comments = post.comments - 1 - replyCount; // 댓글과 대댓글 수 모두 차감
      post.commentsList.removeAt(index);
    });
    widget.onUpdate(post); // 업데이트 콜백 호출
  }

  void _deleteReply(int commentIndex, int replyIndex) {
    setState(() {
      post.commentsList[commentIndex]['replies'].removeAt(replyIndex);
      post.comments = post.comments - 1; // 댓글 수 감소
    });
    widget.onUpdate(post); // 업데이트 콜백 호출
  }

  void _reportComment() {
    // 신고 기능 구현
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('신고'),
        content: Text('이 댓글을 신고하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () {
              // 신고 처리 로직
              Navigator.of(context).pop();
              _showReportSuccessDialog();
            },
            child: Text('신고'),
          ),
        ],
      ),
    );
  }

  void _reportReply() {
    // 신고 기능 구현
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('신고'),
        content: Text('이 대댓글을 신고하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () {
              // 신고 처리 로직
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
    // 신고 성공 메시지
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('신고되었습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 화면의 다른 곳을 누르면 키보드를 숨깁니다.
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                              post.userName, // 수정: 작성자 이름
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '@${post.studentId}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                  ),
                                ),
                                SizedBox(width: 4.0),
                                Text(
                                  '• ${_timeAgo(post.createdAt)}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
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
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/post_comment.svg',
                              color: Color(0xFFA2A2FF),
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 4.0),
                            Text('${post.comments}'),
                          ],
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
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      children: post.commentsList.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> comment = entry.value;
        return Column(
          children: [
            Padding(
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
                          comment['author'] as String, // 수정: 작성자 이름
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14.0),
                        ),
                        Row(
                          children: [
                            Text(
                              '@${comment['studentId']}', // 수정: 작성자 학번
                              style: TextStyle(color: Colors.grey, fontSize: 12.0),
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              '• ${_timeAgo(comment['createdAt'] as DateTime)}',
                              style: TextStyle(color: Colors.grey, fontSize: 12.0),
                            ),
                          ],
                        ),
                        Text(
                          comment['content'] as String,
                          style: TextStyle(fontSize: 14.0), // 폰트 크기 조정
                        ),
                        SizedBox(height: 4.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () => _toggleCommentLike(index),
                                  child: Row(
                                    children: [
                                      Icon(
                                        comment['likes'] % 2 == 0
                                            ? Icons.favorite_border
                                            : Icons.favorite,
                                        color: comment['likes'] % 2 == 0
                                            ? Colors.grey
                                            : Colors.red,
                                      ),
                                      SizedBox(width: 4.0),
                                      Text('${comment['likes']}'),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _replyToIndex = index;
                                    });
                                    FocusScope.of(context)
                                        .requestFocus(_commentFocusNode);
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/post_comment.svg',
                                        color: Colors.grey,
                                        width: 24,
                                        height: 24,
                                      ),
                                      SizedBox(width: 4.0),
                                      Text('${comment['replies'].length}'), // 대댓글 수 표시
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        _deleteComment(index);
                      } else if (value == 'report') {
                        // 신고 기능 추가
                        _reportComment();
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('삭제'),
                        ),
                        PopupMenuItem(
                          value: 'report',
                          child: Text('신고'),
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ),
            _buildReplies(comment['replies'], index),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildReplies(List<dynamic> replies, int commentIndex) {
    return Column(
      children: replies.asMap().entries.map((entry) {
        int replyIndex = entry.key;
        Map<String, dynamic> reply = entry.value;
        return Padding(
          padding: const EdgeInsets.only(left: 40.0, top: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/user_icon.png'),
                radius: 12.0,
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reply['author'] as String, // 수정: 작성자 이름
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12.0),
                    ),
                    Row(
                      children: [
                        Text(
                          '@${reply['studentId']}', // 수정: 작성자 학번
                          style:
                          TextStyle(color: Colors.grey, fontSize: 12.0),
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '• ${_timeAgo(reply['createdAt'] as DateTime)}',
                          style:
                          TextStyle(color: Colors.grey, fontSize: 12.0),
                        ),
                      ],
                    ),
                    Text(
                      reply['content'] as String,
                      style: TextStyle(fontSize: 14.0), // 폰트 크기 조정
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () =>
                                  _toggleReplyLike(commentIndex, replyIndex),
                              child: Row(
                                children: [
                                  Icon(
                                    reply['likes'] % 2 == 0
                                        ? Icons.favorite_border
                                        : Icons.favorite,
                                    color: reply['likes'] % 2 == 0
                                        ? Colors.grey
                                        : Colors.red,
                                  ),
                                  SizedBox(width: 4.0),
                                  Text('${reply['likes']}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') {
                    _deleteReply(commentIndex, replyIndex);
                  } else if (value == 'report') {
                    // 신고 기능 추가
                    _reportReply();
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('삭제'),
                    ),
                    PopupMenuItem(
                      value: 'report',
                      child: Text('신고'),
                    ),
                  ];
                },
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
              focusNode: _commentFocusNode,
              decoration: InputDecoration(
                labelText: _replyToIndex == null ? '댓글을 입력하세요.' : '대댓글을 입력하세요.',
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
                if (_replyToIndex == null) {
                  _addComment(userProfile.userName, _commentController.text); // 사용자 이름으로 변경
                } else {
                  _addReply(_replyToIndex!, userProfile.userName,
                      _commentController.text); // 사용자 이름으로 변경
                  setState(() {
                    _replyToIndex = null;
                  });
                }
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
