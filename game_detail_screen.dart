import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class GameDetailScreen extends StatelessWidget {
  final String game;
  final FlutterTts flutterTts = FlutterTts();

  GameDetailScreen({required this.game});

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$game 경기 정보'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _speak('뒤로 가기');
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text(
          '$game 경기의 상세 정보가 여기에 표시됩니다.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
