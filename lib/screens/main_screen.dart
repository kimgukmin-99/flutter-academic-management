import 'package:flutter/material.dart';
import 'package:academic_management/screens/chat_screen.dart';
import 'package:academic_management/screens/bulletin.dart';
import 'package:academic_management/screens/graduation.dart';
import 'package:academic_management/screens/mypage.dart';
import 'package:academic_management/screens/home.dart';
import 'package:academic_management/utilities/dot_curved_bottom_nav.dart';

class MainScreens extends StatefulWidget {
  @override
  _MainScreensState createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  int _currentPage = 0;
  ScrollController _scrollController = ScrollController();
  List<Post> posts = [];

  final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    GraduationScreen(),
    BulletinBoardScreen(),
    MyPageScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.local_library,
                  color: Colors.deepPurple,
                ),
                SizedBox(width: 3),
                Text(
                  'COMMAN',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.black),
              onPressed: () {
                // 알림 아이콘 클릭 이벤트 처리
                print('Notification icon tapped!');
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          _widgetOptions.elementAt(_currentPage),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavigationBar(
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
                  icon: Icon(Icons.article),
                  label: 'Community',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'My Page',
                ),
              ],
              currentIndex: _currentPage,
              selectedItemColor: Colors.deepPurple,
              unselectedItemColor: Colors.purple[400],
              onTap: _onItemTapped,
            ),
          ),
          Positioned(
            bottom: 70, // 하단 네비게이션 바와의 간격을 조정
            right: 20, // 오른쪽 여백을 조정
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(),
                  ),
                );
              },
              backgroundColor: Colors.deepPurple,
              child: Icon(
                Icons.chat,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
