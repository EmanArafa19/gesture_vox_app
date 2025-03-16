import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesture_vox_app/pages/settings_page.dart';

class RecordingPage extends StatefulWidget {
  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "";
  int _seconds = 0;
  Timer? _timer;
  final int _maxSeconds = 60;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
        _seconds = 0;
      });
      _speech.listen(
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
          });
        },
      );
      _startTimer();
    }
  }

  void _stopListening() {
    _speech.stop();
    _stopTimer();
    setState(() => _isListening = false);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds < _maxSeconds) {
        setState(() {
          _seconds++;
        });
      } else {
        _stopListening(); // إيقاف التسجيل تلقائيًا بعد 60 ثانية
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _speech.stop();
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = _seconds / _maxSeconds;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: BlocBuilder<LanguageCubit, String>(
          builder: (context, language) {
            return Text(
              language == 'عربي' ? 'مترجم الكلمات' : 'Word Translator',
              style: TextStyle(fontWeight: FontWeight.bold),
            );
          },
        ),
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 35,
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.zero,
                    side: BorderSide(
                      color: const Color.fromRGBO(159, 102, 198, 1),
                      width: 1.5,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    size: 14,
                    color: const Color.fromRGBO(159, 102, 198, 1),
                  ),
                ),
              ),
              BlocBuilder<LanguageCubit, String>(
                builder: (context, language) {
                  return Text(
                    language == 'عربي' ? 'رجوع' : 'Back',
                    style: TextStyle(
                      fontSize: 9,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<LanguageCubit, String>(
        builder: (context, language) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 65,
                    height: 65,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color.fromRGBO(159, 102, 198, 1),
                      ),
                    ),
                  ),
                  Text(
                    _formatTime(_seconds),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                language == 'عربي' ? "جاري التسجيل" : "Recording",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCircleButton(
                    icon: Icons.close,
                    label: language == 'عربي' ? "إلغاء" : "Cancel",
                    onPressed: () => Navigator.pop(context, ""),
                    size: 50,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 20),
                  _buildCircleButton(
                    icon: _isListening ? Icons.pause : Icons.play_arrow,
                    label: language == 'عربي' ? "ابدأ" : "Start",
                    onPressed: _isListening ? _stopListening : _startListening,
                    size: 70,
                    color: const Color.fromRGBO(159, 102, 198, 1),
                  ),
                  SizedBox(width: 20),
                  _buildCircleButton(
                    icon: Icons.send,
                    label: language == 'عربي' ? "إنهاء" : "Finish",
                    onPressed: () => Navigator.pop(context, _text),
                    size: 50,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required double size,
    required Color color,
  }) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(size / 4),
            backgroundColor: color,
          ),
          child: Icon(icon, color: Colors.white, size: size / 2),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),
      ],
    );
  }
}
