import 'package:flutter/material.dart';
import 'game_detail_screen.dart';
import 'vibration_strength_screen.dart';
import 'package:flutter_tts/flutter_tts.dart';

class GameSelectionScreen extends StatelessWidget {
  final FlutterTts flutterTts = FlutterTts();

  // 경기 데이터 예시
  final List<Map<String, dynamic>> games = [
    {
      'date': '10.26',
      'matches': [
        {'time': '17:00', 'homeTeam': 'Lions', 'awayTeam': 'Tigers'},
        {'time': '18:00', 'homeTeam': 'Twins', 'awayTeam': 'Giants'},
        {'time': '20:00', 'homeTeam': 'KT Wiz', 'awayTeam': 'Eagles'},
        {'time': '21:00', 'homeTeam': 'Samsung', 'awayTeam': 'Heroes'},
        {'time': '22:00', 'homeTeam': 'LG', 'awayTeam': 'SK'},
        {'time': '23:00', 'homeTeam': 'Kia', 'awayTeam': 'Lotte'},
      ],
    },
    {
      'date': '10.27',
      'matches': [
        {'time': '17:00', 'homeTeam': 'Dinos', 'awayTeam': 'Bears'},
        {'time': '18:00', 'homeTeam': 'Twins', 'awayTeam': 'Heroes'},
        {'time': '19:00', 'homeTeam': 'LG', 'awayTeam': 'Giants'},
      ],
    },
  ];

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  // 날짜 형식을 변환하는 함수
  String _formatDate(String date) {
    final parts = date.split('.');
    final month = parts[0];
    final day = parts[1];
    return '$month월 $day일';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('경기 선택 화면'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          final gameDate = games[index];
          final matches = gameDate['matches'].take(5).toList();  // 다섯 경기만 표시
          final formattedDate = _formatDate(gameDate['date']);  // 날짜 형식 변환

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 날짜 섹션
              Container(
                color: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      gameDate['date'],
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    IconButton(
                      icon: Icon(Icons.volume_up, color: Colors.white),
                      onPressed: () {
                        _speak('$formattedDate 날짜의 경기 목록입니다.');
                      },
                    ),
                  ],
                ),
              ),
              // 경기 목록 (최대 5경기 표시)
              Column(
                children: matches.map<Widget>((match) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    color: Colors.grey[200],
                    child: ListTile(
                      leading: Text(
                        match['time'],
                        style: TextStyle(fontSize: 18),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(match['homeTeam'], style: TextStyle(fontSize: 18)),
                          Text('VS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(match['awayTeam'], style: TextStyle(fontSize: 18)),
                        ],
                      ),
                      trailing: Icon(Icons.star_border),
                      onTap: () {
                        _speak('${match['homeTeam']} 대 ${match['awayTeam']} 경기를 선택하셨습니다.');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameDetailScreen(
                              game: '${match['homeTeam']} vs ${match['awayTeam']}',
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: TextButton(
            onPressed: () {
              _speak('진동 설정 화면으로 이동합니다.');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VibrationStrengthScreen()),
              );
            },
            child: Text(
              '진동 설정',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
