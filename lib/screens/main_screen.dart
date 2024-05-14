import 'package:flutter/material.dart';
import 'package:academic_management/screens/chat_screen.dart';
import 'package:academic_management/screens/bulletin.dart';
import 'package:academic_management/screens/graduation.dart';
import 'package:academic_management/screens/mypage.dart';
import 'package:academic_management/screens/home.dart';

class MainScreens extends StatefulWidget {
  @override
  _MainScreensState createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  int _selectedIndex = 0; // 현재 선택된 탭의 인덱스를 추적합니다.

  // 각 탭에 해당하는 위젯을 리스트로 관리합니다.
  final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    GraduationScreen(),
    BulletinBoardScreen(),
    MyPageScreen(),
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 요소들을 양 끝으로 분배
          children: <Widget>[
            Image.asset(
              'assets/logo.png', // 로고 이미지 파일 경로
              fit: BoxFit.cover,
              height: 40, // 로고의 높이 조정
            ),
            Text('한남대학교'), // 중간에 텍스트 제목이 있으면 이를 추가
            IconButton(
              icon: Icon(Icons.notifications), // 알람 아이콘
              onPressed: () {
                // 알람 아이콘 클릭 이벤트 처리
                print('Notification icon tapped!');
              },
            ),
          ],
        ),
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
