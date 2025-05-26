import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart'; 

class MovementsPage extends StatefulWidget {
  final String translatedText;

  MovementsPage({required this.translatedText});

  @override
  _MovementsPageState createState() => _MovementsPageState();
}

class _MovementsPageState extends State<MovementsPage> {
  List<String> modelUrls = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchModels();
  }

  Future<void> fetchModels() async {
    Uri uri = Uri.parse('https://word-app-5.onrender.com/translate/');
    http.MultipartRequest request = http.MultipartRequest('POST', uri);

    request.fields['text'] = widget.translatedText;

    try {
      http.StreamedResponse streamedResponse = await request.send();

      if (streamedResponse.statusCode == 307) {
        final redirectedUrl = streamedResponse.headers['location'];
        if (redirectedUrl != null) {
          print('📍 Redirecting to: $redirectedUrl');
          uri = Uri.parse(redirectedUrl);
          request = http.MultipartRequest('POST', uri);
          request.fields['text'] = widget.translatedText;
          streamedResponse = await request.send();
        } else {
          print('❌ No redirect location provided.');
          return;
        }
      }

      final responseBody = await streamedResponse.stream.bytesToString();
      print('📥 Response body: $responseBody');

      if (streamedResponse.statusCode == 200) {
        final data = jsonDecode(responseBody);
        final models = data['cloudinary_links'];

        if (models != null && models is List) {
          setState(() {
            modelUrls = List<String>.from(models);
            isLoading = false;
          });
        } else {
          print('Response does not contain valid links list');
          setState(() => isLoading = false);
        }
      } else {
        print('Connection failed: ${streamedResponse.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error while sending: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Language Translation')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Text(
                  widget.translatedText,
                  style: TextStyle(fontSize: 24),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: modelUrls.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          height: 500,
                          child: ModelViewerWidget(
                          modelUrl: modelUrls[index]
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class ModelViewerWidget extends StatelessWidget {
  final String modelUrl;

  ModelViewerWidget({required this.modelUrl});

  @override
  Widget build(BuildContext context) {
    return ModelViewer(
      src: modelUrl,
      alt: "3D Model",
      ar: true,
      autoRotate: true,
      cameraControls: true,
      backgroundColor: Colors.transparent,
    );
  }
}