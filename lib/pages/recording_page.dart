import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesture_vox_app/pages/settings_page.dart';
import 'package:gesture_vox_app/pages/background.dart';
import 'package:gesture_vox_app/pages/bottom_nav_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecordingPage extends StatefulWidget {
  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage>
    with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "";
  int _seconds = 0;
  Timer? _timer;
  final int _maxSeconds = 60;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.0).animate(_animationController);
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
        _seconds = 0;
        _animation = Tween<double>(begin: 1.0, end: 1.07).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
        );
        _animationController.repeat(reverse: true);
      });

      _speech.listen(onResult: (result) {
        setState(() {
          _text = result.recognizedWords;
        });
      });
      _startTimer();
    }
  }

  void _stopListening() {
    _speech.stop();
    _stopTimer();
    setState(() {
      _isListening = false;
      _animationController.stop();
      _animation = Tween<double>(begin: 1.0, end: 1.0).animate(_animationController);
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds < _maxSeconds) {
        setState(() {
          _seconds++;
        });
      } else {
        _stopListening();
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
    if (_animationController.isAnimating) {
      _animationController.stop();
    }
    _animationController.dispose();
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
              language == 'عربي' ? 'تسجيل الصوت' : 'Audio Recording',
              style: TextStyle(fontWeight: FontWeight.bold),
            );
          },
        ),
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
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
            ],
          ),
        ),
      ),
      body: BlocBuilder<LanguageCubit, String>(
        builder: (context, language) {
          return BackgroundWidget(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 6,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          const Color.fromRGBO(159, 102, 198, 1),
                        ),
                      ),
                    ),
                    ScaleTransition(
                      scale: _animation,
                      child: Image.asset(
                        'assets/images/anim.png',
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  _formatTime(_seconds),
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCircleButton(
                      icon: Icon(Icons.close, color: const Color.fromRGBO(159, 102, 198, 1)),
                      label: "",
                      onPressed: () => Navigator.pop(context, ""),
                      size: 50,
                    ),
                    SizedBox(width: 20),
                    _buildCircleButton(
                      icon: Icon( 
                        _isListening ? Icons.pause : Icons.stop,
                        color: const Color.fromRGBO(159, 102, 198, 1),
                      ),
                      label: "",
                      onPressed: _isListening ? _stopListening : _startListening,
                      size: 70,
                    ),
                    SizedBox(width: 20),
                    _buildCircleButton(
                      icon: SvgPicture.asset(
                        'assets/icons/done.svg',
                        height: 20,
                        width: 20,
                      ),
                      label: "",
                      onPressed: () => Navigator.pop(context, _text),
                      size: 50,
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCircleButton({
    required Widget icon,
    required String label,
    required VoidCallback onPressed,
    required double size,
  }) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: const Color.fromRGBO(159, 102, 198, 1),
              width: 2,
            ),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: icon,
            iconSize: size / 2,
          ),
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