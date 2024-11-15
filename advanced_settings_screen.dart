import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AdvancedSettingsScreen extends StatefulWidget {
  @override
  _AdvancedSettingsScreenState createState() => _AdvancedSettingsScreenState();
}

class _AdvancedSettingsScreenState extends State<AdvancedSettingsScreen> {
  double vibrationPattern = 5;
  double vibrationDuration = 3;
  String selectedMenu = '안타';
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    await flutterTts.setLanguage("ko-KR");  // 한국어 설정
    await flutterTts.setSpeechRate(0.6);     // 말하기 속도 설정
  }

  Future<void> _speak(String text) async {
    await flutterTts.stop(); // 중복 호출 방지
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('고급 설정'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAdvancedSlider('진동 패턴', '진동 강도의 변화 속도를 조절합니다.', '저', '고', vibrationPattern, (value) {
              setState(() {
                vibrationPattern = value;
              });
              _speak('진동 패턴 $value로 설정되었습니다.');
            }),
            SizedBox(height: 20),
            _buildAdvancedSlider('진동 시간', '진동이 울리는 시간을 조절합니다.', '0초', '5초', vibrationDuration, (value) {
              setState(() {
                vibrationDuration = value;
              });
              _speak('진동 시간 $value 초로 설정되었습니다.');
            }),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: selectedMenu,
                  iconSize: 60.0, // 아이콘 크기 3배로 키움
                  items: ['안타', '홈런', '파울', '아웃', '볼']
                      .map((String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontSize: 24)), // 글자 크기 키움
                  ))
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedMenu = newValue!;
                    });
                    _speak('$selectedMenu 선택됨');
                  },
                ),
                SizedBox(width: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    padding: EdgeInsets.symmetric(horizontal: 48, vertical: 24), // 버튼 크기 3배로 키움
                  ),
                  onPressed: () {
                    _speak('설정이 적용되었습니다.');
                    // 적용 버튼 클릭 시 수행할 동작
                  },
                  child: Text('적용', style: TextStyle(fontSize: 26)), // 버튼 글자 크기 키움
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // _buildAdvancedSlider 메서드 정의
  Widget _buildAdvancedSlider(
      String title, String description, String minLabel, String maxLabel, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
        Text(description, style: TextStyle(fontSize: 16)),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 10.0, // 트랙 높이 다섯 배로 키움
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 24.0),
          ),
          child: Slider(
            value: value,
            min: 1,
            max: 10,
            divisions: 9,
            label: value.toStringAsFixed(0),
            onChanged: onChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(minLabel, style: TextStyle(fontSize: 16)),
            Text(maxLabel, style: TextStyle(fontSize: 16)),
          ],
        ),
        Divider(height: 20, thickness: 2),
      ],
    );
  }
}
