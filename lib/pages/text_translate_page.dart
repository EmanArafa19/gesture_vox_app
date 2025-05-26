import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesture_vox_app/pages/background.dart';
import 'package:gesture_vox_app/pages/home_page.dart';
import 'package:gesture_vox_app/pages/recording_page.dart';
import 'package:gesture_vox_app/pages/settings_page.dart';
import 'package:gesture_vox_app/pages/history_page.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gesture_vox_app/pages/Movements_Page.dart';

class TextTranslatePage extends StatefulWidget {
  final String initialText;
  
  const TextTranslatePage({
    Key? key,
    this.initialText = "",
  }) : super(key: key);

  @override
  _TextTranslatePageState createState() => _TextTranslatePageState();
}

class _TextTranslatePageState extends State<TextTranslatePage> {
  String _text = "";
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _text = widget.initialText;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendText() async {
    if (_controller.text.isNotEmpty) {
      await _saveToHistory(_controller.text);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MovementsPage(translatedText: _controller.text),
        ),
      );
    }
  }

  Future<void> _finishInput() async {
    if (_controller.text.isNotEmpty) {
      await _saveToHistory(_controller.text);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MovementsPage(translatedText: _controller.text),
        ),
      );
    }
  }

  Future<void> _openHistoryPage() async {
    final selectedText = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HistoryPage()),
    );

    if (selectedText != null) {
      setState(() {
        _controller.text = selectedText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, String>(
      builder: (context, language) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              language == 'عربي' ? 'مترجم الكلمات' : 'Word Translator',
              style: const TextStyle(fontWeight: FontWeight.bold),
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
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero,
                        side: const BorderSide(
                          color: Color.fromRGBO(159, 102, 198, 1),
                          width: 1.5,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 14,
                        color: Color.fromRGBO(159, 102, 198, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: BackgroundWidget(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(child: WordBody()),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 30.0), 
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color.fromRGBO(16, 31, 132, 1),
                                      Color.fromRGBO(159, 102, 198, 1),
                                    ],
                                  ),
                                ),
                                padding: const EdgeInsets.all(2),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13),
                                    color: const Color.fromRGBO(240, 233, 245, 1),
                                  ),
                                  child: TextField(
                                    maxLength: 160,
                                    controller: _controller,
                                    onChanged: (value) {
                                      setState(() {
                                        _text = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color.fromRGBO(159, 102, 198, 0.2),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none,
                                      ),
                                      hintText: language == 'عربي' ? 'أدخل النص' : 'Enter the text',
                                      hintStyle: const TextStyle(
                                        color: Color.fromRGBO(130, 126, 126, 0.8),
                                        fontSize: 14,
                                      ),
                                      counterText: '',
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      suffix: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '${_controller.text.length}',
                                              style: TextStyle(
                                                color: _controller.text.length > 0
                                                    ? const Color.fromRGBO(159, 102, 198, 1)
                                                    : Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const TextSpan(
                                              text: '/160 char',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_text.isNotEmpty) {
                                      _finishInput();
                                    } else {
                                      final recordedText = await Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => RecordingPage()),
                                      );

                                      if (recordedText != null && recordedText.isNotEmpty) {
                                        setState(() {
                                          _text = recordedText;
                                          _controller.text = recordedText;
                                        });
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(10),
                                    backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                                    side: const BorderSide(
                                      color: Color.fromRGBO(159, 102, 198, 1),
                                      width: 2,
                                    ),
                                  ),
                                  child: _text.isNotEmpty 
                                      ? const Icon(
                                          Icons.send,
                                          color: Color.fromRGBO(159, 102, 198, 1),
                                          size: 25,
                                        )
                                      : SvgPicture.asset(
                                          'assets/images/mic.svg',
                                          width: 22,
                                          height: 22,
                                        ),  
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _text.isEmpty ? "" : "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class WordBody extends StatelessWidget {
  const WordBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;

    return Center(
      child: ModelViewer(
        src: 'assets/models/gesture_character.glb',
        alt: "3D Gesture Character",
        ar: true,
        arModes: const [],
        autoRotate: false,
        cameraControls: true,
        cameraOrbit: isKeyboardVisible ? "0deg 110deg auto" : "0deg 90deg auto",
        disablePan: true,
        interactionPrompt: InteractionPrompt.none,
      ),
    );
  }
}

Future<void> _saveToHistory(String translatedText) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> history = prefs.getStringList('translation_history') ?? [];
  history.add(translatedText);
  await prefs.setStringList('translation_history', history);
}