import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesture_vox_app/pages/settings_page.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, String>(
      builder: (context, language) {
        return Scaffold(
          appBar: AppBar(
          centerTitle: true, 
          title: Text(
                language == 'عربي' ? 'الشروط والأحكام' : 'Terms and Conditions',
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child:Image.asset(
              Theme.of(context).brightness == Brightness.dark
              ? 'assets/images/logo1.png'  
              : 'assets/images/logo2.png', 
                      width: 100,
                      height: 100,
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(color: Colors.grey, thickness: 1),
                  SizedBox(height: 10),
                  Text(
                    language == 'عربي'
                        ? "يرجى قراءة هذه الشروط والأحكام بعناية قبل استخدام تطبيق Gesture Vox."
                        : "Please read these terms and conditions carefully before using the Gesture Vox application.",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20),
                  _buildSectionTitle(language == 'عربي' ? "1. الاستخدام المقبول" : "1. Acceptable Use"),
                  _buildSectionText(
                    language == 'عربي'
                        ? "يجب استخدام التطبيق فقط للأغراض المشروعة وتحسين التواصل. يُمنع استخدامه في أي أنشطة غير قانونية أو ضارة."
                        : "The application must be used solely for legal purposes and to improve communication. Any illegal or harmful activities are strictly prohibited.",
                  ),
                  _buildSectionTitle(language == 'عربي' ? "2. حماية البيانات" : "2. Data Protection"),
                  _buildSectionText(
                    language == 'عربي'
                        ? "نحن نحرص على حماية خصوصيتك. لا نقوم بمشاركة بياناتك الشخصية مع أي طرف ثالث بدون إذنك."
                        : "We are committed to protecting your privacy. We do not share your personal data with third parties without your consent.",
                  ),
                  _buildSectionTitle(language == 'عربي' ? "3. حدود المسؤولية" : "3. Limitation of Liability"),
                  _buildSectionText(
                    language == 'عربي'
                        ? "نحن غير مسؤولين عن أي استخدام غير صحيح للتطبيق أو أي أضرار ناتجة عن ذلك."
                        : "We are not responsible for any misuse of the application or any resulting damages.",
                  ),
                  _buildSectionTitle(language == 'عربي' ? "4. التعديلات على الشروط" : "4. Changes to Terms"),
                  _buildSectionText(
                    language == 'عربي'
                        ? "نحتفظ بالحق في تعديل هذه الشروط والأحكام في أي وقت. يُرجى مراجعتها بانتظام."
                        : "We reserve the right to modify these terms and conditions at any time. Please review them regularly.",
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      language == 'عربي' ? "باستخدام التطبيق، فإنك توافق على هذه الشروط." : "By using the app, you agree to these terms.",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 5),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color.fromRGBO(159, 102, 198, 1)),
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
