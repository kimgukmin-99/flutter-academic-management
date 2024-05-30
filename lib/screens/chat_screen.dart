import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class ChatMessage {
  String text;
  bool isMe; // 메시지가 사용자 본인의 것인지 여부
  String? username; // 사용자 이름
  String? avatarUrl; // 프로필 사진 URL
  DateTime timestamp; // 메시지의 타임스탬프

  ChatMessage({
    required this.text,
    required this.isMe,
    this.username,
    this.avatarUrl,
    required this.timestamp,
  });
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> _messages = []; // ChatMessage 객체의 리스트로 선언
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messages.add(
      ChatMessage(
        text: '안녕, 나는 컴퓨터공학과 4학년 국민이야. 한남대학교에 궁금한게 있으면 뭐든지 물어봐!',
        isMe: false,
        username: 'Gookmin',
        avatarUrl: 'assets/avatar.png',
        timestamp: DateTime.now(),
      ),
    );
  }

  void _handleSubmitted(String text) {
    if (text.isEmpty) return;

    setState(() {
      bool isMe = _messages.length % 2 == 1;
      _messages.add(
        ChatMessage(
          text: text,
          isMe: isMe,
          username: isMe ? "Me" : "Gookmin",
          avatarUrl: isMe ? null : "assets/avatar.png",
          timestamp: DateTime.now(),
        ),
      );
      _controller.clear();
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 60,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _buildMessageItem(ChatMessage message) {
    final alignment =
        message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final messageAlignment =
        message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start;
    final color = message.isMe ? Colors.blue[200] : Colors.grey[300];
    final timeFormat = DateFormat('HH:mm');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Row(
            mainAxisAlignment: messageAlignment,
            children: [
              if (!message.isMe) ...[
                CircleAvatar(
                  backgroundImage: message.avatarUrl != null
                      ? AssetImage(message.avatarUrl!)
                      : AssetImage('assets/avatar.png'),
                ),
                SizedBox(width: 10),
              ],
              Flexible(
                child: Column(
                  crossAxisAlignment: alignment,
                  children: [
                    if (!message.isMe)
                      Text(
                        message.username ?? "Anonymous",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    Container(
                      margin: const EdgeInsets.all(4.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        message.text,
                        softWrap: true, // 자동 줄바꿈 활성화
                        style: TextStyle(fontSize: 16), // 텍스트 크기 설정
                      ),
                    ),
                  ],
                ),
              ),
              if (message.isMe) SizedBox(width: 10),
            ],
          ),
          Row(
            mainAxisAlignment: messageAlignment,
            children: [
              if (!message.isMe) SizedBox(width: 50), // 아바타 공간 확보
              Text(
                timeFormat.format(message.timestamp),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              if (message.isMe) SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(blurRadius: 3, color: Colors.black12, offset: Offset(0, -2))
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration.collapsed(
                hintText: "Send a message...",
                hintStyle: TextStyle(color: Colors.grey[600]),
              ),
              style: TextStyle(color: Colors.black),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.deepPurple),
            onPressed: () => _handleSubmitted(_controller.text),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Chat GookPT4o',
            style: TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.transparent, // AppBar 배경색 없앰
        elevation: 0, // 그림자 없앰
        iconTheme: IconThemeData(color: Colors.deepPurple), // 아이콘 색상 설정
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (_, int index) =>
                  _buildMessageItem(_messages[index]),
              itemCount: _messages.length,
            ),
          ),
          Divider(height: 1.0),
          _buildTextComposer(),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
