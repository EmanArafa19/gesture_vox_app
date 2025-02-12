import 'package:flutter/material.dart';
import 'package:gesture_vox_app/pages/background.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesture_vox_app/pages/settings_page.dart';

class LogOutPage extends StatefulWidget {
  @override
  _LogOutPageState createState() => _LogOutPageState();
}

class _LogOutPageState extends State<LogOutPage> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, String>(
      builder: (context, language) {
        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text(
                language == 'عربي' ? 'تسجيل الخروج' : 'Log Out',
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
                      Navigator.pop(context);
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 20),
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color.fromRGBO(159, 102, 198, 1),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Alaa Ahmed",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
                SizedBox(height: 10),
                _buildTextField(
                  label: language == 'عربي' ? "الاسم الكامل" : "Full Name",
                  hintText: language == 'عربي' ? "أدخل اسمك" : "Enter your name",
                  icon: Icons.person,
                ),
                SizedBox(height: 15),
                _buildTextField(
                  label: language == 'عربي' ? "كلمة المرور" : "Password",
                  hintText: language == 'عربي' ? "أدخل كلمة المرور" : "Enter your password",
                  icon: _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(159, 102, 198, 1),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    language == 'عربي' ? "خروج" : "Exit",
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

  Widget _buildTextField({required String label, required String hintText, required IconData icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        TextField(
          obscureText: label.contains("Password") && !_isPasswordVisible,  
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: const Color.fromRGBO(159, 102, 198, 1).withOpacity(0.1),
            suffixIcon: label.contains("Password")
                ? IconButton(
                    icon: Icon(icon),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
