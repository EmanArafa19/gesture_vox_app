import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gesture_vox_app/pages/text_translate_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
    var uri = Uri.parse("https://scan-7-xvse.onrender.com/ocr/");
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("OCR Scanner"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_sharp, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              if (_image != null) Image.file(_image!, height: 200),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildImagePickerButton(
                      icon: Icons.camera_alt,
                      label: "Camera",
                      source: ImageSource.camera),
                  SizedBox(width: 20),
                  _buildImagePickerButton(
                      icon: Icons.photo_library,
                      label: "Gallery",
                      source: ImageSource.gallery),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: _textController,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Extracted Text",
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendTextToTranslatePage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(159, 102, 198, 1),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "Finish",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerButton(
      {required IconData icon,
      required String label,
      required ImageSource source}) {
    return Column(
      children: [
        FloatingActionButton(
  heroTag: label,
  onPressed: () => _pickImage(source),
  backgroundColor: const Color.fromRGBO(159, 102, 198, 1),
  child: Icon(icon, color: Colors.white),
),

        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
