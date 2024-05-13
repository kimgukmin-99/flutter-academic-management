import 'package:flutter/material.dart';
import 'package:academic_management/screens/chat_screen.dart';

class MainScreens extends StatefulWidget {
  @override
  _MainScreensState createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  int _selectedIndex = 0; // 현재 선택된 탭의 인덱스를 추적합니다.

  // 각 탭에 해당하는 위젯을 리스트로 관리합니다.
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    Text('Graduation',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    Text('Bulletin Board',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    Text('My Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // 사용자가 탭을 선택하면 인덱스를 업데이트합니다.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Academic Management'),
      ),
      body: Center(
        // 선택된 탭에 해당하는 위젯을 표시합니다.
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // 네 개 이상의 탭을 고정해서 표시
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Graduation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Board',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Page',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 여기에 채팅 기능을 시작하는 코드를 추가
          print('Chat button pressed!');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        },
        child: Icon(Icons.chat),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // 버튼 위치
    );
  }
}
