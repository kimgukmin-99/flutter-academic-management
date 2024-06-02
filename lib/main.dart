import 'package:flutter/material.dart';
import 'package:academic_management/screens/login_screen.dart';
import 'package:academic_management/providers/person.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Academic Management Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF8A50CE),
          background: Colors.white, // 배경색 설정
        ),
        fontFamily: "Pretendard",
      ),
      home: LoginPage(),
    );
  }
}
