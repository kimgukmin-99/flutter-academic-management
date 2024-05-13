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

  @override
  void initState() {
    super.initState();
    // 앱 시작 시 초기 메시지 추가
    _messages.insert(
      0,
      ChatMessage(
        text: '안녕, 나는 컴퓨터공학과 4학년 국민이야. 한남대학교에 궁금한게 있으면 뭐든지 물어봐!',
        isMe: false,
        username: 'Gookmin',
        avatarUrl: 'https://via.placeholder.com/150',
      ),
    );
  }

  void _handleSubmitted(String text) {
    setState(() {
      bool isMe = _messages.length % 2 == 0;
      _messages.insert(
          0,
          ChatMessage(
            text: text,
            isMe: isMe,
            username: isMe ? "Me" : "Gookmin",
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
            backgroundImage: NetworkImage(
                message.avatarUrl ?? 'https://via.placeholder.com/150'),
          ),
          SizedBox(width: 10),
          Flexible(
            // Flexible을 사용하여 텍스트가 차지할 수 있는 최대 공간을 유동적으로 조절
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message.username ?? "Anonymous",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  margin: const EdgeInsets.all(4.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 8.0),
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
        ] else ...[
          Flexible(
            // 마찬가지로 Flexible 사용
            child: Container(
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
                style: TextStyle(fontSize: 16),
              ),
            ),
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
