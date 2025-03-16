import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesture_vox_app/pages/settings_page.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, String>(
      builder: (context, language) {
        return Scaffold(
          appBar: AppBar(
          centerTitle: true, 
          title: Text(
                language == 'عربي' ? 'معلومات عنا' : 'About Us',
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
          body:  SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
              ? 'assets/images/logo1.png'  
              : 'assets/images/logo2.png', 
                    width: 100,
                    height: 100,
                  ),
                ),
                SizedBox(height: 20),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
                SizedBox(height: 10),
                Text(
                  language == 'عربي'
                      ? "Gesture Vox هو تطبيق يساعد على تسهيل التواصل بين الأشخاص ذوي الإعاقة السمعية وبقية المجتمع. يقوم التطبيق بترجمة لغة الإشارة إلى كلام منطوق والعكس، مما يساعد في جعل التواصل أكثر سهولة وسلاسة."
                      : "Gesture Vox is an application that facilitates communication between hearing-impaired individuals and the rest of society. The app translates sign language into spoken words and vice versa, making communication easier and more seamless.",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 20),
                Text(
                  language == 'عربي' ? "مميزات التطبيق:" : "App Features:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _buildFeatureItem(
                  language == 'عربي' ? "ترجمة فورية بين لغة الإشارة والكلام." : "Real-time translation between sign language and speech.",
                ),
                _buildFeatureItem(
                  language == 'عربي' ? "واجهة سهلة الاستخدام." : "User-friendly interface.",
                ),
                _buildFeatureItem(
                  language == 'عربي' ? "يدعم اللغتين العربية والإنجليزية." : "Supports both Arabic and English.",
                ),
                _buildFeatureItem(
                  language == 'عربي'
                      ? "إمكانية الدردشة والمشاركة: يمكنك مشاركة الترجمات التي تقوم بها مع الآخرين عبر الدردشة، مما يساعدك على التواصل بشكل أفضل مع أصدقائك وأفراد عائلتك. سواء كنت بحاجة إلى توضيح أو ترغب في بدء محادثة، يوفر التطبيق وسيلة تفاعلية لبناء مجتمع متصل."
                      : "Chat and Sharing: You can share your translations with others through the chat feature, making it easier to communicate with friends and family. Whether you need clarification or just want to start a conversation, the app provides an interactive way to build a connected community.",
                ),
                SizedBox(height: 30),
                Center(
                  child: Text(
                    language == 'عربي' ? "شكرًا لاستخدامكم تطبيقنا!" : "Thank you for using our app!",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        );
      },
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: const Color.fromRGBO(159, 102, 198, 1)),
          SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
