import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class ChatMessage {
  String text;
  bool isMe; // 메시지가 사용자 본인의 것인지 여부
  String? username; // 사용자 이름
  String? avatarUrl; // 프로필 사진 URL

  ChatMessage({
    required this.text,
    required this.isMe,
    this.username,
    this.avatarUrl,
  });
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> _messages = []; // ChatMessage 객체의 리스트로 선언
  final TextEditingController _controller = TextEditingController();

  void _handleSubmitted(String text) {
    setState(() {
      bool isMe = _messages.length % 2 == 0;
      _messages.insert(
          0,
          ChatMessage(
            text: text,
            isMe: isMe,
            username: isMe ? "Me" : "Hannam",
            avatarUrl:
                isMe ? null : "https://via.placeholder.com/150", // 예시 URL
          ));
      _controller.clear();
    });
  }

  Widget _buildMessageItem(ChatMessage message) {
    final alignment =
        message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final messageAlignment =
        message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start;
    final color = message.isMe ? Colors.blue[100] : Colors.grey[200];

    return Row(
      mainAxisAlignment: messageAlignment,
      children: [
        if (!message.isMe) ...[
          CircleAvatar(
            backgroundImage: NetworkImage(message.avatarUrl ??
                'https://via.placeholder.com/150'), // 기본 이미지 처리
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                child: Text(message.text),
              ),
            ],
          ),
        ] else ...[
          Container(
            margin: const EdgeInsets.all(4.0),
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(message.text),
          ),
        ],
      ],
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration.collapsed(
                hintText: "Send a message...",
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => _handleSubmitted(_controller.text),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) =>
                  _buildMessageItem(_messages[index]),
              itemCount: _messages.length,
            ),
          ),
          Divider(height: 1.0),
          _buildTextComposer(),
          Container(height: 50),
        ],
      ),
    );
  }
}
