import 'package:flutter/material.dart';
import 'package:academic_management/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Academic Management Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme(
          primary: Colors.blue[800]!, // 짙은 파란색을 주 색상으로 설정
          secondary: Colors.blue[400]!, // 밝은 파란색을 보조 색상으로 설정
          surface: Colors.grey[50]!, // 매우 연한 회색을 표면 색상으로 설정
          background: Colors.white, // 배경을 흰색으로 설정
          error: Colors.red, // 오류 색상은 레드로 유지
          onPrimary: Colors.white, // 주 색상 위의 텍스트 색상은 흰색
          onSecondary: Colors.white, // 보조 색상 위의 텍스트 색상도 흰색
          onSurface: Colors.black, // 표면 위의 텍스트 색상은 검은색
          onBackground: Colors.black, // 배경 위의 텍스트 색상은 검은색
          onError: Colors.white, // 오류 색상 위의 텍스트 색상은 흰색
          brightness: Brightness.light, // 전반적인 밝기는 밝게 설정
        ),
      ),
      home: LoginPage(),
    );
  }
}
