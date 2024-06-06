import 'package:flutter/material.dart';
import 'package:academic_management/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Academic Management Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.white, // 여기에 배경색을 지정합니다.
          background: Color(0xFFF7F7F7), // 배경색을 지정합니다.
        ),
        scaffoldBackgroundColor: Color(0xFFF7F7F7),
        primaryColor: Color(0xFFF7F7F7)
      ),
      home: LoginPage(),
    );
  }
}
