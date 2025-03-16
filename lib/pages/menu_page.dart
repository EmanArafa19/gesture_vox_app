import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesture_vox_app/pages/settings_page.dart';
import 'package:gesture_vox_app/pages/log_out_page.dart';
import 'package:gesture_vox_app/pages/background.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea( 
          child: MenuBody(),
        ),
      ),
    );
  }
}


class MenuBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String language = context.watch<LanguageCubit>().state;

    return ListView(
      padding: EdgeInsets.all(12),
      children: [
          Container(
          height: 150, 
          alignment: Alignment.centerLeft, 
          child: ListTile(
            leading: CircleAvatar(
              radius: 40, 
              backgroundColor: const Color.fromRGBO(159, 102, 198, 1),
              child: Icon(Icons.person, color: Colors.white, size: 30),
            ),
            title: Text(
              'Alaa Ahmed',
              style: TextStyle(
                fontSize: 22, 
                fontWeight: FontWeight.bold, 
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),

        
        Divider(thickness: 1.3,color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.white  
                  : Colors.black),
        _buildDarkModeTile(context, language),
        _buildMenuItem(context, language, 'Language', 'اللغة', "assets/images/language.png"),
        _buildMenuItem(context, language, 'Share App', 'مشاركة التطبيق', "assets/images/share.png"),
        _buildMenuItem(context, language, 'Settings', 'الإعدادات', "assets/images/settings.png"),
        Divider(thickness: 0.3,color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.white  
                  : Colors.black),
        _buildMenuItem(context, language, 'Connect Us', 'اتصل بنا', "assets/images/contact_icon.png"),
        _buildMenuItem(context, language, 'Log Out', 'تسجيل الخروج', "assets/images/logout.png"),
      ],
    );
  }

  Widget _buildDarkModeTile(BuildContext context, String language) {
    return ListTile(
      leading: Image.asset(
        "assets/images/darkmode.png",
        width: 22,
        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
      ),
      title: Text(language == 'عربي' ? 'الوضع الداكن' : 'Dark Mode'),
      trailing: Switch(
        value: context.watch<ThemeCubit>().state,
        onChanged: (value) {
          context.read<ThemeCubit>().toggleTheme();
        },
        activeColor: const Color.fromRGBO(159, 102, 198, 1),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 1),
    );
  }

  Widget _buildMenuItem(BuildContext context, String language, String title, String arabicTitle, String iconPath) {
    return ListTile(
      leading: Image.asset(
        iconPath,
        width: 22,
        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
      ),
      title: Text(language == 'عربي' ? arabicTitle : title),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 12,
        color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 1),
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
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black), 
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
