import 'package:flutter/material.dart';

class ChatScreens extends StatefulWidget {
  @override
  _ChatScreensState createState() => _ChatScreensState();
}

class _ChatScreensState extends State<ChatScreens> {
  final List<String> _messages = []; // 채팅 메시지를 저장하는 리스트
  final TextEditingController _textController =
      TextEditingController(); // 텍스트 입력을 관리하는 컨트롤러

  // 메시지를 보내는 함수
  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _messages.insert(0, text); // 새 메시지를 리스트의 시작 부분에 추가
    });
  }

  // 입력 필드와 전송 버튼을 만드는 위젯
  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true, // 메시지를 화면 하단부터 쌓아 올림
              itemBuilder: (_, int index) => ListTile(
                title: Text(_messages[index]),
              ),
              itemCount: _messages.length,
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}
