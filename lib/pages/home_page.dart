import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesture_vox_app/pages/settings_page.dart';
import 'package:gesture_vox_app/pages/sign_translate_page.dart';
import 'package:gesture_vox_app/pages/chat_page.dart';
import 'package:gesture_vox_app/pages/text_translate_page.dart';
import 'package:gesture_vox_app/pages/menu_page.dart';
import 'package:gesture_vox_app/pages/bottom_nav_bar.dart';
import 'package:gesture_vox_app/pages/background.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreenContent(),
    SignTranslatePage(),
    ChatPage(),
    TextTranslatePage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSettingsPage = _selectedIndex == 4;

    return Scaffold(
      body: BackgroundWidget(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: isSettingsPage
          ? null
          : BottomNavBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  int _currentIndex = 0;
  late Timer _timer;

  final List<String> _imagePaths = [
    "assets/images/translate.png",
    "assets/images/translate1.png",
    "assets/images/translate2.png",
    "assets/images/translate3.png",
  ];

  @override
  void initState() {
    super.initState();
    _startImageSlider();
  }

  void _startImageSlider() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _imagePaths.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, String>(
      builder: (context, language) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.menu,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MenuPage()),
                    );
                  },
                ),
                SizedBox(width: 8),
                Text(
                  language == 'عربي' ? 'Alaa مرحبا 👋' : 'Hi, Alaa 👋',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ],
            ),
            actions: [
            Padding(
             padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
              ? 'assets/images/logo1.png'  
              : 'assets/images/logo2.png', 
              height: 70,
            ),
            ),
            ],
          ),
          body: BackgroundWidget(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.purple[100],
                      ),
                      child: Row(
                        children: [
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 500),
                            child: Image.asset(
                              _imagePaths[_currentIndex],
                              key: ValueKey<int>(_currentIndex),
                              height: 200,
                              width: 250,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Let's Go",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "   to Translate",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      " Categories",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          categoryCard("Chatting", "assets/images/chat2.png",
                              "Connect with the people you want to chat with", const Color.fromRGBO(159, 102, 198, 100)),
                          categoryCard("Word Translator",
                              "assets/images/Rectangle 119.png",
                              "Translate Text and Speech to Arabic Sign Language",
                              const Color.fromRGBO(159, 102, 198, 100)),
                          categoryCard("Sign Translator",
                              "assets/images/Intersect.png",
                              "Translate Arabic Sign Language to Text and Speech",
                              const Color.fromRGBO(159, 102, 198, 100)),
                        ],
                      ),
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

  Widget categoryCard(String title, String icon, String subtitle, Color color) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color:  Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : const Color.fromARGB(255, 38, 37, 37),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.light
                        ? const Color.fromARGB(255, 173, 172, 172)
                        : const Color.fromARGB(255, 107, 106, 106),
            blurRadius: 5,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon, height: 50),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color:  Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Theme.of(context).brightness == Brightness.light
                        ? const Color.fromARGB(255, 90, 89, 89)
                        : const Color.fromARGB(255, 172, 172, 172),),
            ),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              "Start",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
