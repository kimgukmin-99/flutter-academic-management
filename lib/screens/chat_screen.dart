import 'dart:async';
import 'dart:convert';
import 'package:academic_management/providers/person.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  bool isMe;
  String? username;
  String? avatarUrl;
  DateTime timestamp;
  bool isTypingIndicator;

  ChatMessage({
    required this.text,
    required this.isMe,
    this.username,
    this.avatarUrl,
    required this.timestamp,
    this.isTypingIndicator = false,
  });
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startTypingIndicator() {
    setState(() {
      _messages.add(
        ChatMessage(
          text: '',
          isMe: false,
          username: 'Seongmin',
          avatarUrl: 'assets/avatar3.png',
          timestamp: DateTime.now(),
          isTypingIndicator: true,
        ),
      );
    });
  }

  void _stopTypingIndicator() {
    setState(() {
      if (_messages.isNotEmpty && _messages.last.isTypingIndicator) {
        _messages.removeLast();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _messages.add(
      ChatMessage(
        text: '안녕, 나는 컴퓨터공학과 4학년 성민이야. 한남대학교에 궁금한게 있으면 뭐든지 물어봐!',
        isMe: false,
        username: 'Seongmin',
        avatarUrl: 'assets/avatar3.png',
        timestamp: DateTime.now(),
      ),
    );
  }

  void _handleSubmitted(String text) async {
    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isMe: true,
          username: "Me",
          avatarUrl: null,
          timestamp: DateTime.now(),
        ),
      );
      _controller.clear();
      isLoading = true;
      _startTypingIndicator();
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    try {
      final response = await http.post(
        Uri.parse(server + '/echo'), // 서버 URL을 올바르게 설정하세요
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'message': text}),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        print(responseBody);

        setState(() {
          _stopTypingIndicator();
          _messages.add(
            ChatMessage(
              text: responseBody,
              isMe: false,
              username: 'Seongmin',
              avatarUrl: 'assets/avatar3.png',
              timestamp: DateTime.now(),
            ),
          );
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
          isLoading = false;
        });
      } else {
        setState(() {
          _stopTypingIndicator();
          _messages.add(
            ChatMessage(
              text: '서버 오류가 발생했습니다. 다시 시도해주세요.',
              isMe: false,
              username: 'Seongmin',
              avatarUrl: 'assets/avatar3.png',
              timestamp: DateTime.now(),
            ),
          );
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _stopTypingIndicator();
        _messages.add(
          ChatMessage(
            text: '네트워크 오류가 발생했습니다. 인터넷 연결을 확인해주세요.',
            isMe: false,
            username: 'Seongmin',
            avatarUrl: 'assets/avatar3.png',
            timestamp: DateTime.now(),
          ),
        );
        isLoading = false;
      });
    }
  }

  Widget _buildMessageItem(ChatMessage message) {
    if (message.isTypingIndicator) {
      return _buildTypingIndicator();
    }

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
                : AssetImage('assets/avatar3.png'),
          ),
          SizedBox(width: 10),
        ],
        Flexible(
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
                child: MarkdownBody(
                  data: message.text,
                  onTapLink: (text, href, title) {
                    if (href != null) {
                      launch(href);
                    }
                  },
                  styleSheet: MarkdownStyleSheet(
                    a: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
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

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/avatar3.png'),
          ),
          SizedBox(width: 10),
          SpinKitThreeBounce(
            color: Colors.grey,
            size: 20.0,
          ),
        ],
      ),
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
              onSubmitted: isLoading ? null : _handleSubmitted,
              decoration: InputDecoration.collapsed(
                hintText:
                    isLoading ? "   답변을 기다리는 중입니다." : "   Send a message...",
                hintStyle: TextStyle(color: Colors.grey[600]),
              ),
              style: TextStyle(color: Colors.black),
              enabled: !isLoading,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blueGrey),
            onPressed:
                isLoading ? null : () => _handleSubmitted(_controller.text),
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
              color: Color(0xFF8A50CE),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF8A50CE)),
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
