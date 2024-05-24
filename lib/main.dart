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
          primary: Color.fromRGBO(96, 125, 139, 1), // BlueGrey primary color
          onPrimary: Color(0xffffffff), // Text on primary color
          primaryContainer: Color(0xffCFD8DC), // Light variant of BlueGrey
          onPrimaryContainer: Color(0xff0c1114), // Text on primary container
          secondary: Color(0xff009688), // Teal secondary color
          onSecondary: Color(0xffffffff), // Text on secondary color
          secondaryContainer: Color(0xffB2DFDB), // Light variant of Teal
          onSecondaryContainer:
              Color(0xff101214), // Text on secondary container
          tertiary: Color(0xff4CAF50), // Green tertiary color
          onTertiary: Color(0xffffffff), // Text on tertiary color
          tertiaryContainer: Color(0xffC8E6C9), // Light variant of Green
          onTertiaryContainer: Color(0xff111314), // Text on tertiary container
          error: Color(0xffb00020), // Error color
          onError: Color(0xffffffff), // Text on error color
          errorContainer: Color(0xfffcd8df), // Light variant of error color
          onErrorContainer: Color(0xff141213), // Text on error container
          background: Color(0xffF5F5F5), // Light grey background color
          onBackground: Color(0xff090909), // Text on background color
          surface: Color(0xffffffff), // White surface color
          onSurface: Color(0xff090909), // Text on surface color
          surfaceVariant:
              Color(0xffECEFF1), // Light variant of BlueGrey for surface
          onSurfaceVariant: Color(0xff121313), // Text on surface variant
          outline: Color(0xffB0BEC5), // Light BlueGrey for outlines
          shadow: Color(0xff000000), // Shadow color
          inverseSurface:
              Color(0xff263238), // Dark variant of BlueGrey for inverse surface
          onInverseSurface: Color(0xffECEFF1), // Text on inverse surface
          inversePrimary: Color(0xffCFD8DC), // Inverse primary color
          surfaceTint: Color(0xff607D8B), // Tint color for surface
        ),
      ),
      home: LoginPage(),
    );
  }
}
