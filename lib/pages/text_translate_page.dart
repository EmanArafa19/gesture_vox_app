import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesture_vox_app/pages/background.dart';
import 'package:gesture_vox_app/pages/home_page.dart';
import 'package:gesture_vox_app/pages/recording_page.dart';
import 'package:gesture_vox_app/pages/settings_page.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class TextTranslatePage extends StatefulWidget {
  final String initialText;
  TextTranslatePage({Key? key, this.initialText = ""}) : super(key: key);

  @override
  _TextTranslatePageState createState() => _TextTranslatePageState();
}

class _TextTranslatePageState extends State<TextTranslatePage> {
  String _text = "";
  TextEditingController _controller = TextEditingController();

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

  void _finishInput() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovementsPage()),
    );
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
              style: TextStyle(fontWeight: FontWeight.bold),
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
                  Text(
                    language == 'عربي' ? 'رجوع' : 'Back',
                    style: TextStyle(
                      fontSize: 9,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
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
                Expanded(child: WordBody()),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Column(
                            children: [
                              ElevatedButton(
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
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(16),
                                  backgroundColor: const Color.fromRGBO(159, 102, 198, 1),
                                ),
                                child: Icon(
                                  _text.isNotEmpty ? Icons.send : Icons.mic,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                _text.isEmpty ? "Record" : "Finish",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              maxLength: 160,
                              controller: _controller,
                              onChanged: (value) {
                                setState(() {
                                  _text = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: language == 'عربي' ? 'أدخل النص' : 'Enter the text',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(159, 102, 198, 1),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
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
  @override
  Widget build(BuildContext context) {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    bool isKeyboardVisible = keyboardHeight > 0;

    return Center(
      child: ModelViewer(
        src: 'assets/models/gesture_character.glb',
        alt: "3D Gesture Character",
        ar: true,
        autoRotate: false,
        cameraControls: true,
        cameraOrbit: isKeyboardVisible ? "0deg 110deg auto" : "0deg 90deg auto",
        disablePan: true,
      ),
    );
  }
}


class MovementsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Movements Page")),
      body: Center(child: Text("Videos for gestures will be here!")),
    );
  }
}