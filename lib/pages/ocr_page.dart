import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gesture_vox_app/pages/text_translate_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesture_vox_app/pages/settings_page.dart';
import 'package:gesture_vox_app/pages/background.dart';

class OCRPage extends StatefulWidget {
  @override
  _OCRPageState createState() => _OCRPageState();
}

class _OCRPageState extends State<OCRPage> {
  File? _image;
  String _extractedText = "";
  final picker = ImagePicker();
  final TextEditingController _textController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    var status = (source == ImageSource.camera)
        ? await Permission.camera.request()
        : await Permission.photos.request();

    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Permission denied!")),
        );
      }
      return;
    }

    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _extractedText = "";
        _textController.clear();
      });

      await _uploadImage(_image!);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    var uri = Uri.parse("https://scan2-1.onrender.com/ocr/");
    var request = http.MultipartRequest("POST", uri)
      ..files.add(await http.MultipartFile.fromPath("image", imageFile.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);
        setState(() {
          _extractedText = jsonResponse["extracted_text"] ?? "No text found";
          _textController.text = _extractedText;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to process image")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  void _sendTextToTranslatePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TextTranslatePage(initialText: _extractedText),
      ),
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
              language == 'عربي' ? 'مسح النص' : 'Scanner',
              style: TextStyle(fontWeight: FontWeight.bold),
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
          body: BackgroundWidget(
            child: OcrPage(
              image: _image,
              textController: _textController,
              pickImage: _pickImage,
              sendTextToTranslatePage: _sendTextToTranslatePage,
            ),
          ),
        );
      },
    );
  }
}

class OcrPage extends StatelessWidget {
  final File? image;
  final TextEditingController textController;
  final Function(ImageSource) pickImage;
  final VoidCallback sendTextToTranslatePage;

  const OcrPage({
    Key? key,
    required this.image,
    required this.textController,
    required this.pickImage,
    required this.sendTextToTranslatePage,
  }) : super(key: key);

  Widget _buildImagePickerButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required ImageSource source,
  }) {
    return GestureDetector(
      onTap: () => pickImage(source),
      child: Column(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: const Color.fromRGBO(159, 102, 198, 1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(159, 102, 198, 1).withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: Color.fromRGBO(159, 102, 198, 1),
                size: 30,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, String>(
      builder: (context, language) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(196, 196, 196, 0.5)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.zero,
                          child: Image.file(
                            image!,
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        )
                      : null,
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildImagePickerButton(
                      context,
                      icon: Icons.photo_library,
                      label: "",
                      source: ImageSource.gallery,
                    ),
                    SizedBox(width: 40),
                    _buildImagePickerButton(
                      context,
                      icon: Icons.camera_alt,
                      label: "",
                      source: ImageSource.camera,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  height: 75,
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return TextField(
                        controller: textController,
                        maxLines: 5,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: "Extracted Text",
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelStyle: TextStyle(
                            color: textController.text.isNotEmpty
                                ? Color.fromRGBO(159, 102, 198, 1)
                                : Color.fromRGBO(196, 196, 196, 1),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: textController.text.isNotEmpty
                                  ? Color.fromRGBO(159, 102, 198, 1)
                                  : Color.fromRGBO(196, 196, 196, 0.5),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(159, 102, 198, 1),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: sendTextToTranslatePage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(159, 102, 198, 1),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 90),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: Text(
                    language == 'عربي' ? 'إنهاء' : 'Finish',
                    style: TextStyle(fontSize: 18, color: Colors.white),
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