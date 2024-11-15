import 'package:flutter/material.dart';
import 'splash_screen.dart'; // 로고 화면 파일 import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // 로고 화면을 시작 화면으로 설정
    );
  }
}
