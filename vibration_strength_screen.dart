import 'package:flutter/material.dart';
import 'advanced_settings_screen.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VibrationStrengthScreen extends StatefulWidget {
  @override
  _VibrationStrengthScreenState createState() => _VibrationStrengthScreenState();
}

class _VibrationStrengthScreenState extends State<VibrationStrengthScreen> {
  double antaStrength = 5;
  double homerunStrength = 5;
  double foulStrength = 5;
  double outStrength = 5;
  double ballStrength = 5;
  final FlutterTts flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _lastCommand = '';

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    await flutterTts.setLanguage("ko-KR");  // 한국어 설정
    await flutterTts.setSpeechRate(0.6);    // 말하기 속도 설정
    await flutterTts.setPitch(1.0);         // 음성 높이 조정
  }

  Future<void> _speak(String text) async {
    await flutterTts.stop();  // 이전 음성 출력 중지
    await flutterTts.speak(text);
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (result) {
        setState(() {
          _lastCommand = result.recognizedWords;
        });
        _processCommand(_lastCommand);
      });
    } else {
      _speak("음성 인식을 사용할 수 없습니다.");
    }
  }

  void _processCommand(String command) {
    RegExp regex = RegExp(r'(안타|홈런|파울|아웃|볼) 강도 (\d)로 설정');
    var match = regex.firstMatch(command);
    if (match != null) {
      String title = match.group(1)!;
      int strength = int.parse(match.group(2)!);

      setState(() {
        switch (title) {
          case '안타':
            antaStrength = strength.toDouble();
            _speak('안타 강도 $strength로 설정되었습니다.');
            break;
          case '홈런':
            homerunStrength = strength.toDouble();
            _speak('홈런 강도 $strength로 설정되었습니다.');
            break;
          case '파울':
            foulStrength = strength.toDouble();
            _speak('파울 강도 $strength로 설정되었습니다.');
            break;
          case '아웃':
            outStrength = strength.toDouble();
            _speak('아웃 강도 $strength로 설정되었습니다.');
            break;
          case '볼':
            ballStrength = strength.toDouble();
            _speak('볼 강도 $strength로 설정되었습니다.');
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('패턴의 강도 설정'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
            onPressed: _startListening,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildVibrationSlider('안타', antaStrength, (value) {
              setState(() => antaStrength = value);
            }),
            _buildVibrationSlider('홈런', homerunStrength, (value) {
              setState(() => homerunStrength = value);
            }),
            _buildVibrationSlider('파울', foulStrength, (value) {
              setState(() => foulStrength = value);
            }),
            _buildVibrationSlider('아웃', outStrength, (value) {
              setState(() => outStrength = value);
            }),
            _buildVibrationSlider('볼', ballStrength, (value) {
              setState(() => ballStrength = value);
            }),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                onPressed: () {
                  _speak('고급 설정 화면으로 이동합니다.');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdvancedSettingsScreen()),
                  );
                },
                child: Text('고급설정', style: TextStyle(fontSize: 22)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVibrationSlider(String title, double currentValue, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, backgroundColor: Colors.black, color: Colors.white),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 10.0,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 24.0),
          ),
          child: Slider(
            value: currentValue,
            min: 1,
            max: 10,
            divisions: 9,
            label: currentValue.toStringAsFixed(0),
            onChanged: (value) {
              setState(() {
                currentValue = value;
              });
            },
            onChangeEnd: (value) {
              onChanged(value);
              _speak('$title 강도 $value로 설정되었습니다.');
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('약', style: TextStyle(fontSize: 16)),
            Text('강', style: TextStyle(fontSize: 16)),
          ],
        ),
        Divider(height: 20, thickness: 2),
      ],
    );
  }
}
