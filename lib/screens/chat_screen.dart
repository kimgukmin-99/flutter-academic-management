import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class ResponseMessage {
  String responseMessage;

  ResponseMessage({required this.responseMessage});

  factory ResponseMessage.fromJson(Map<String, dynamic> json) {
    return ResponseMessage(
      responseMessage: json['response_message'],
    );
  }
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

  void _handleSubmitted(String text) async {
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
      // 새 메시지가 추가되면 스크롤을 맨 아래로 이동
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    try {
      final response = await http.post(
        Uri.parse('http://3.25.85.108:8000/echo'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'message': text}),
      );

      if (response.statusCode == 200) {
        final responseBody =
            json.decode(utf8.decode(response.bodyBytes)); // UTF-8로 디코딩
        print(responseBody);
        text = responseBody['response_message'];
        setState(() {
          _messages.add(
            ChatMessage(
              text: text,
              isMe: false,
              username: 'Gookmin',
              avatarUrl: 'assets/avatar.png',
              timestamp: DateTime.now(),
            ),
          );
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      } else {
        // 서버 오류 처리
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      // 네트워크 오류 처리
      print('Network error: $e');
    }
  }

  Widget _buildMessageItem(ChatMessage message) {
    final alignment =
        message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final messageAlignment =
        message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start;
    final color = message.isMe ? Colors.blue[100] : Colors.grey[200];
    final timeFormat = DateFormat('HH:mm');

    return Row(
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
          // Flexible을 사용하여 텍스트가 차지할 수 있는 최대 공간을 유동적으로 조절
          child: Column(
            crossAxisAlignment: alignment,
            children: [
              if (!message.isMe)
                Text(message.username ?? "Anonymous",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                margin: const EdgeInsets.all(4.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
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
              Text(
                timeFormat.format(message.timestamp),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        if (message.isMe) SizedBox(width: 10),
      ],
    );
  }

  Widget _buildTextComposer() {
    return Container(
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
            icon: Icon(Icons.send, color: Colors.blueGrey),
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
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
