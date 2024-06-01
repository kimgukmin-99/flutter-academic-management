import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // flutter_svg 패키지 추가
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
  int _currentPage = 0; // 현재 선택된 탭의 인덱스를 추적합니다.
  ScrollController _scrollController = ScrollController();

  // 각 탭에 해당하는 위젯을 리스트로 관리합니다.
  final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    GraduationScreen(),
    BulletinBoardScreen(),
    MyPageScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentPage = index; // 사용자가 탭을 선택하면 인덱스를 업데이트합니다.
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
                SvgPicture.asset('assets/icons/logo.svg',
                    width: 20, height: 20, color: Color(0xFF8A50CE)),
                SizedBox(width: 3),
              ],
            ),
            GestureDetector(
              onTap: () {
                print('Notification icon tapped!');
              },
              child: SvgPicture.asset(
                'assets/icons/alarm.svg',
                width: 24,
                height: 24,
              ),
            )
          ],
        ),
      ),
      body: Center(
        // 선택된 탭에 해당하는 위젯을 표시합니다.
        child: _widgetOptions.elementAt(_currentPage),
      ),
      bottomNavigationBar: DotCurvedBottomNav(
        scrollController: _scrollController,
        hideOnScroll: true,
        indicatorColor: Colors.black,
        backgroundColor: Colors.white,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.ease,
        selectedIndex: _currentPage,
        indicatorSize: 5,
        borderRadius: 25,
        height: 70,
        onTap: _onItemTapped,
        items: [
          SvgPicture.asset(
            'assets/icons/nav_home.svg',
            color: _currentPage == 0 ? Color(0xFF8A50CE) : Colors.grey,
            width: 24,
            height: 24,
          ),
          SvgPicture.asset(
            'assets/icons/nav_suggest.svg',
            color: _currentPage == 1 ? Color(0xFF8A50CE) : Colors.grey,
            width: 24,
            height: 24,
          ),
          SvgPicture.asset(
            'assets/icons/nav_post.svg',
            color: _currentPage == 2 ? Color(0xFF8A50CE) : Colors.grey,
            width: 24,
            height: 24,
          ),
          SvgPicture.asset(
            'assets/icons/nav_privacy.svg',
            color: _currentPage == 3 ? Color(0xFF8A50CE) : Colors.grey,
            width: 24,
            height: 24,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Chat button pressed!');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        },
        child: SvgPicture.asset(
          'assets/icons/chat_button.svg',
          color: Colors.white, // 아이콘 색상을 white로 설정
          width: 24.0,
          height: 24.0,
        ),
        backgroundColor: Color(0xFFA2A2FF),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
