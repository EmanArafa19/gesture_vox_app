import 'package:flutter/material.dart';
import 'package:gesture_vox_app/pages/background.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesture_vox_app/pages/settings_page.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, String>(
      builder: (context, language) {
        return Scaffold(
          appBar: AppBar(
          centerTitle: true, 
          title: Text(
                language == 'عربي' ? 'سياسة الخصوصية' : 'Privacy Policy',
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(language == 'عربي' ? "١. المعلومات التي نجمعها" : "1. Information We Collect", language),
                    _buildSectionText(
                      language == 'عربي'
                          ? "عند استخدام التطبيق، قد نقوم بجمع المعلومات التالية:\n"
                            "• البيانات الشخصية: مثل الاسم أو البريد الإلكتروني إذا قمت بالتسجيل أو الاتصال بنا.\n"
                            "• الصور والفيديوهات: تُستخدم فقط لغرض ترجمة لغة الإشارة مباشرة، ولا يتم تخزينها أو مشاركتها.\n"
                            "• البيانات التحليلية: مثل نوع الجهاز وتكرار الاستخدام، بهدف تحسين الخدمة."
                          : "When you use our app, we may collect the following information:\n"
                            "• Personal Data: Such as your name or email if you register or contact us.\n"
                            "• Images and Videos: Used solely for sign language translation and are neither stored nor shared.\n"
                            "• Analytical Data: Device type, usage frequency, and time spent in the app to improve service.",
                    ),
                     Divider(thickness: 1, color: Colors.grey),
                    _buildSectionTitle(language == 'عربي' ? "٢. كيف نستخدم البيانات" : "2. How We Use the Data", language),
                    _buildSectionText(
                      language == 'عربي'
                          ? "• الترجمة الفورية: يتم استخدام الصور والفيديوهات فورياً دون تخزينها.\n"
                            "• تحسين التطبيق: نحلل البيانات لمعرفة كيفية تحسين تجربة المستخدم.\n"
                            "• التواصل: إذا قدمت بياناتك، فقد نستخدمها للرد على استفساراتك أو إبلاغك بالتحديثات."
                          : "• Instant Translation: Images and videos are processed immediately without storage.\n"
                            "• App Improvement: We analyze data to enhance user experience.\n"
                            "• Communication: Your contact info may be used for inquiries or updates.",
                    ),
                     Divider(thickness: 1, color: Colors.grey),
                    _buildSectionTitle(language == 'عربي' ? "٣. مشاركة البيانات" : "3. Data Sharing", language),
                    _buildSectionText(
                      language == 'عربي'
                          ? "• لا نقوم بمشاركة الصور أو الفيديوهات أو البيانات الشخصية مع أي جهة خارجية.\n"
                            "• قد نشارك بيانات تحليلية مع مقدمي الخدمات لتحسين الأداء، ولكن دون تحديد هويتك."
                          : "• We do not share images, videos, or personal data with third parties.\n"
                            "• Analytical data may be shared with service providers for performance improvements but remains anonymous.",
                    ),
                     Divider(thickness: 1, color: Colors.grey),
                    _buildSectionTitle(language == 'عربي' ? "٤. حقوق المستخدم" : "4. User Rights", language),
                    _buildSectionSubTitle(language == 'عربي' ? "• الوصول إلى بياناتك الشخصية:" : "• Access Your Personal Data:", language),
                    _buildSectionText(
                      language == 'عربي'
                          ? "يمكنك طلب تفاصيل حول البيانات التي نجمعها عنك."
                          : "You can request details about the information we collect about you.",
                    ),
                   Divider(thickness: 1, color: Colors.grey),
                    _buildSectionSubTitle(language == 'عربي' ? "• تعديل أو حذف البيانات:" : "• Modify or Delete Data:", language),
                    _buildSectionText(
                      language == 'عربي'
                          ? "إذا رغبت في تعديل أو حذف بياناتك، يمكنك التواصل معنا وسنتخذ الخطوات اللازمة."
                          : "If you wish to modify or delete your personal data, contact us, and we will take the necessary steps.",
                    ),
                                         Divider(thickness: 1, color: Colors.grey),
                    _buildSectionSubTitle(language == 'عربي' ? "• سحب الموافقة:" : "• Withdraw Consent:", language),
                    _buildSectionText(
                      language == 'عربي'
                          ? "يمكنك سحب موافقتك على معالجة البيانات في أي وقت من خلال إعدادات التطبيق أو بالتواصل معنا."
                          : "You can withdraw your consent for data processing anytime via app settings or by contacting us.",
                    ),
                     Divider(thickness: 1, color: Colors.grey),
                    _buildSectionTitle(language == 'عربي' ? "٥. أمان البيانات" : "5. Data Security", language),
                    _buildSectionText(
                      language == 'عربي'
                          ? "نعتمد تدابير تقنية وأمنية متقدمة لضمان حماية الصور والفيديوهات من الوصول غير المصرح به. لا يتم تخزين البيانات على أي خادم."
                          : "We implement advanced security measures to protect images and videos from unauthorized access. No data is stored on any server.",
                    ),
                     Divider(thickness: 1, color: Colors.grey),
                    _buildSectionTitle(language == 'عربي' ? "٦. تخزين البيانات" : "6. Data Storage", language),
                    _buildSectionText(
                      language == 'عربي'
                          ? "لا يتم تخزين الصور أو الفيديوهات الملتقطة أثناء استخدام التطبيق. تُستخدم مؤقتًا ثم تُحذف فور انتهاء عملية الترجمة."
                          : "No images or videos captured during app use are stored. Data is temporarily used for translation and deleted immediately afterward.",
                    ),
                     Divider(thickness: 1, color: Colors.grey),
                    _buildSectionTitle(language == 'عربي' ? "٧. التعديلات على سياسة الخصوصية" : "7. Changes to the Privacy Policy", language),
                    _buildSectionText(
                      language == 'عربي'
                          ? "قد نقوم بتحديث هذه السياسة من وقت لآخر. سيتم إخطارك بأي تغييرات عبر تحديث تاريخ السريان في أعلى هذه الصفحة."
                          : "We may update this policy occasionally. You will be notified of any changes by updating the effective date at the top of this page.",
                    ),
                  
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, String language) {
    return Padding(
      padding: const EdgeInsets.only(top: 13.0, bottom: 8.0),
      child: Text(
        title,
        textAlign: language == 'عربي' ? TextAlign.right : TextAlign.left,
        style: TextStyle(
          color: Color.fromRGBO(159, 102, 198, 1),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionSubTitle(String title, String language) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Text(
        title,
        textAlign: language == 'عربي' ? TextAlign.right : TextAlign.left,
        style: TextStyle(
          color: Color.fromRGBO(84, 58, 101, 1),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
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
