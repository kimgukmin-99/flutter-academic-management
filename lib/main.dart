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
        fontFamily: "Pretendard",
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xff1565c0),
          onPrimary: Color(0xffffffff),
          primaryContainer: Color(0xff90caf9),
          onPrimaryContainer: Color(0xff0c1114),
          secondary: Color(0xff0277bd),
          onSecondary: Color(0xffffffff),
          secondaryContainer: Color(0xffbedcff),
          onSecondaryContainer: Color(0xff101214),
          tertiary: Color(0xff039be5),
          onTertiary: Color(0xffffffff),
          tertiaryContainer: Color(0xffcbe6ff),
          onTertiaryContainer: Color(0xff111314),
          error: Color(0xffb00020),
          onError: Color(0xffffffff),
          errorContainer: Color(0xfffcd8df),
          onErrorContainer: Color(0xff141213),
          background: Color(0xfff6f9fc),
          onBackground: Color(0xff090909),
          surface: Color(0xfff6f9fc),
          onSurface: Color(0xff090909),
          surfaceVariant: Color(0xffeef4fa),
          onSurfaceVariant: Color(0xff121313),
          outline: Color(0xff565656),
          shadow: Color(0xff000000),
          inverseSurface: Color(0xff111317),
          onInverseSurface: Color(0xfff5f5f5),
          inversePrimary: Color(0xffaedfff),
          surfaceTint: Color(0xff1565c0),
        ),
      ),
      home: LoginPage(),
    );
  }
}
