import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesture_vox_app/pages/ocr_page.dart';
import 'package:gesture_vox_app/pages/settings_page.dart';
import 'package:gesture_vox_app/pages/log_out_page.dart';
import 'package:gesture_vox_app/pages/history_page.dart';
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
      
      _buildProfileSection(),
        SizedBox(height: 10),
          Divider(thickness: 0.5,color: Theme.of(context).brightness == Brightness.dark 
                  ? const Color.fromRGBO(224, 224, 224, 1)  
                  : const Color.fromRGBO(224, 224, 224, 1)),
        _buildMenuItem(context, language, 'Scan', 'المسح الضوئي', "assets/images/scan1.png"),
        _buildMenuItem(context, language, 'History', ' السجل', "assets/images/history.png"),
        _buildMenuItem(context, language, 'Language', 'اللغة', "assets/images/language.png"),
        _buildDarkModeTile(context, language),

        Divider(thickness: 0.5,color: Theme.of(context).brightness == Brightness.dark 
                  ? const Color.fromRGBO(224, 224, 224, 1)  
                  : const Color.fromRGBO(224, 224, 224, 1)),
        _buildMenuItem(context, language, 'Connect Us', 'اتصل بنا', "assets/images/contact_icon.png"),
        _buildMenuItem(context, language, 'Log Out', 'تسجيل الخروج', "assets/images/logout.png"),
      ],
    );
  }

 Widget _buildProfileSection() {
    return Container(
      height: 150,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
  radius: 40,
  backgroundColor: const Color.fromRGBO(159, 102, 198, 1),
  child: Icon(
    Icons.person,  
    size:50, 
    color: Colors.white,  
  ),
),
          SizedBox(height: 10),
          Text(
            'Alaa Ahmed',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'alaa@bb.com',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
  Widget _buildDarkModeTile(BuildContext context, String language) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 123, 122, 122).withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
    ),
    child: ListTile(
      leading: Padding(
        padding: EdgeInsets.only(left: 2), 
        child: Image.asset(
          "assets/images/darkmode.png",
          width: 25,
          color: const Color.fromRGBO(159, 102, 198, 1),
        ),
      ),
      title: Text(language == 'عربي' ? 'الوضع الداكن' : 'Dark Mode'),
      trailing: Switch(
        value: context.watch<ThemeCubit>().state,
        onChanged: (value) {
          context.read<ThemeCubit>().toggleTheme();
        },
        activeColor: const Color.fromRGBO(159, 102, 198, 1),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 10), 
    ),
  );
}


  Widget _buildMenuItem(BuildContext context, String language, String title, String arabicTitle, String iconPath) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 123, 122, 122).withOpacity(0.1), 
      borderRadius: BorderRadius.circular(10),
    ),
    child: ListTile(
      leading: Padding(
        padding: EdgeInsets.only(left: 1), 
        child: Image.asset(
          iconPath,
          width: 25,
          color: const Color.fromRGBO(159, 102, 198, 1),
        ),
      ),
      title: Text(language == 'عربي' ? arabicTitle : title),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 12,
        color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 10), 
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
        } else if (title == 'Scan') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OCRPage(),
            ),
          );
        }
        else if (title == 'History') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryPage(),
            ),
          );
        }
      },
    ),
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
