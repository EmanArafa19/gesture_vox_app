import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesture_vox_app/pages/privacy_policy_page.dart';
import 'package:gesture_vox_app/pages/edit_profile_page.dart';
import 'package:gesture_vox_app/pages/log_out_page.dart';
import 'package:gesture_vox_app/pages/about_us.dart';
import 'package:gesture_vox_app/pages/Terms_and_conditions.dart';
import 'package:gesture_vox_app/pages/home_page.dart';
import 'package:gesture_vox_app/pages/background.dart';
import 'package:url_launcher/url_launcher.dart';

 
class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false);

  void toggleTheme() => emit(!state);
}

class LanguageCubit extends Cubit<String> {
  LanguageCubit() : super('English');

  void changeLanguage(String language) => emit(language);
}
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, String>(
      builder: (context, language) {
        return Scaffold(
          appBar: AppBar(
          centerTitle: true, 
          title: Text(
                language == 'عربي' ? 'الإعدادات' : 'Settings',
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
            child: SettingsBody(),
          ),
        );
      },
    );
  }
}

class SettingsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String language = context.watch<LanguageCubit>().state;

    return ListView(
      padding: EdgeInsets.all(1),
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color.fromRGBO(159, 102, 198, 1),
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text(
            'Alaa Ahmed',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              fontFamily: 'Roboto',
            ),
          ),
          trailing: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(159, 102, 198, 1),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(),
                ),
              );
            },
            child: Text(
              language == 'عربي' ? 'تعديل الملف الشخصي' : 'Edit profile',
              style: TextStyle(fontSize: 12,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
        ),
        Divider(),
        _buildSectionTitle(language == 'عربي' ? 'الإجراءات' : 'Actions', language),
        _buildActionItem(context, language, 'Report Problem', 'الإبلاغ عن مشكلة'),
        _buildActionItem(context, language, 'Contact Us', 'اتصل بنا'),
        _buildActionItem(context, language, 'Share App', 'مشاركة التطبيق'),
        _buildActionItem(context, language, 'Rate App', 'تقييم التطبيق'),
        _buildActionItem(context, language, 'Language', 'اللغة'),
        SwitchListTile(
          title: Text(language == 'عربي' ? 'الوضع الداكن' : 'Dark mode'),
          value: context.watch<ThemeCubit>().state,
          onChanged: (value) {
            context.read<ThemeCubit>().toggleTheme();
          },
        ),
        Divider(),
        _buildSectionTitle(language == 'عربي' ? 'معلومات التطبيق' : 'App Information', language),
        _buildActionItem(context, language, 'About us', 'معلومات عنا'),
        _buildActionItem(context, language, 'Privacy policy', 'سياسة الخصوصية'),
        _buildActionItem(context, language, 'Terms and conditions', 'الشروط والأحكام'),
        Divider(),
        _buildSectionTitle(language == 'عربي' ? 'إدارة الحساب' : 'Account Management', language),
        _buildActionItem(context, language, 'Log Out', 'تسجيل الخروج'),
      ],
    );
  }

  Widget _buildSectionTitle(String title, String language) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: const Color.fromRGBO(159, 102, 198, 1),
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, String language, String title, String arabicTitle) {
    return ListTile(
      title: Text(language == 'عربي' ? arabicTitle : title),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 12,
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : Colors.white,
      ),
      onTap: () {
        if (title == 'Privacy policy') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PrivacyPolicyPage(),
            ),
          );
        } else if (title == 'Language') {
          _showLanguageDialog(context);
        }  else if (title == 'About us') {
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AboutUsPage(),
            ),
          );
        } 
        else if (title == 'Log Out') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LogOutPage(),
            ),
          );
        } else if (title == 'Terms and conditions') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TermsAndConditionsPage(),
            ),
          );
        } 
        
        else if (title == 'Rate App') {
          _launchURL('https://play.google.com/store');
        } else if (title == 'Contact Us' || title == 'Report Problem') {
          _launchURL('https://mail.google.com');
        }
        
      },
    );
  }
  
  void _showLanguageDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Select Language'),
            IconButton(
              icon: Icon(Icons.close, 
                color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.white  
                  : Colors.black),
              onPressed: () {
                Navigator.pop(context); 
              },
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('English'),
              onTap: () {
                context.read<LanguageCubit>().changeLanguage('English');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('عربي'),
              onTap: () {
                context.read<LanguageCubit>().changeLanguage('عربي');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
