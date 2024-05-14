import 'package:flutter/material.dart';

class MyPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/profile_placeholder.png'), // 프로필 이미지 경로
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                '사용자 이름',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('이름 변경'),
              onTap: () {
                // 이름 변경 기능
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('비밀번호 변경'),
              onTap: () {
                // 비밀번호 변경 기능
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('로그아웃'),
              onTap: () {
                // 로그아웃 기능
              },
            ),
          ],
        ),
      ),
    );
  }
}
