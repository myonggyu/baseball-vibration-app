import 'package:flutter/material.dart';
import 'game_selection_screen.dart'; // 메인 화면 파일 import

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 3초 후에 메인 화면으로 전환
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GameSelectionScreen()), // 메인 화면으로 전환
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.remove_red_eye, size: 100), // 로고 아이콘
            SizedBox(height: 20),
            Text('ONPLAY', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
