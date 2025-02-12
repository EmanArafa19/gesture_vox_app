import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesture_vox_app/pages/home_page.dart';
import 'package:gesture_vox_app/pages/settings_page.dart';
import 'package:gesture_vox_app/pages/log_out_page.dart';
import 'package:gesture_vox_app/pages/background.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, String>(builder: (context, language) {
      return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              language == 'عربي' ? 'القائمة' : 'Menu',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(3),
                    side: BorderSide(
                      color: const Color.fromRGBO(159, 102, 198, 1),
                      width: 1.5,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false,
                    );
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 18,
                    color: const Color.fromRGBO(159, 102, 198, 1),
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
          child: MenuBody(),
        ),
      );
    });
  }
}

class MenuBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String language = context.watch<LanguageCubit>().state;

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildDarkModeTile(context, language),
        _buildMenuItem(context, language, 'Language', 'اللغة', "assets/images/language.png"),
        _buildMenuItem(context, language, 'Share App', 'مشاركة التطبيق', "assets/images/share.png"),
        _buildMenuItem(context, language, 'Settings', 'الإعدادات', "assets/images/settings.png"),
        Divider(),
        _buildMenuItem(context, language, 'Connect Us', 'اتصل بنا', "assets/images/contact_icon.png"),
        _buildMenuItem(context, language, 'Log Out', 'تسجيل الخروج', "assets/images/logout.png"),
      ],
    );
  }
Widget _buildDarkModeTile(BuildContext context, String language) {
  return ListTile(
    leading: Image.asset(
      "assets/images/darkmode.png",
      width: 30,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black,
    ),
    title: Text(language == 'عربي' ? 'الوضع الداكن' : 'Dark Mode'),
    trailing: Switch(
      value: context.watch<ThemeCubit>().state,
      onChanged: (value) {
        context.read<ThemeCubit>().toggleTheme();
      },
      activeColor: const Color.fromRGBO(159, 102, 198, 1),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 6),
  );
}

  Widget _buildMenuItem(BuildContext context, String language, String title, String arabicTitle, String iconPath) {
    return ListTile(
      leading: Image.asset(
        iconPath,
        width: 30,
        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
      ),
      title: Text(language == 'عربي' ? arabicTitle : title),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 15,
        color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 6),
      onTap: () {
        if (title == 'Language') {
          _showLanguageDialog(context);
        } else if (title == 'Connect Us') {
          _launchURL('https://mail.google.com');
        } else if (title == 'Log Out') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LogOutPage(),
            ),
          );
        } else if (title == 'Settings') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsPage(),
            ),
          );
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
