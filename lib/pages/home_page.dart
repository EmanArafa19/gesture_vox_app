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
import 'package:gesture_vox_app/pages/ocr_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  final ScrollController _scrollController = ScrollController();
  bool _canScrollLeft = false;
  bool _canScrollRight = true;

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
    _scrollController.addListener(_updateScrollButtons);
  }

  void _updateScrollButtons() {
    if (!_scrollController.hasClients) return;
    setState(() {
      _canScrollLeft = _scrollController.offset > 0;
      _canScrollRight = _scrollController.offset < _scrollController.position.maxScrollExtent;
    });
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
            leading: Builder(
              builder: (context) => IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/menu.svg',
                  height: 30,
                  width: 30,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            title: Text(
              language == 'عربي' ? 'مرحبًا، آلاء 👋' : 'Hi, Alaa 👋', // Arabic translation
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
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
          drawer: Drawer(
            child: Container(
              height: MediaQuery.of(context).size.height, 
              color: Colors.white, 
              child: Column(
                children: [
                  Expanded(
                    child: MenuPage(),
                  ),
                ],
              ),
            ),
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
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).brightness == Brightness.light
                            ? const Color.fromRGBO(159, 102, 198, 0.25).withOpacity(0.25)
                            : const Color.fromRGBO(159, 102, 198, 0.25).withOpacity(0.30),
                      ),
                      child: Row(
                        children: [
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 500),
                            child: Image.asset(
                              _imagePaths[_currentIndex],
                              key: ValueKey<int>(_currentIndex),
                              height: 205,
                              width: 185,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    language == 'عربي' ? 'هيا لنبدأ' : "Let's Go", // Arabic translation
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).brightness == Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                  Text(
                                    language == 'عربي' ? 'الترجمة' : "to Translate", // Arabic translation
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context).brightness == Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 35),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      _imagePaths.length,
                                      (index) {
                                        bool isActive = _currentIndex == index;
                                        return Container(
                                          margin: EdgeInsets.symmetric(horizontal: 2),
                                          child: isActive
                                              ? Container(
                                                  width: 14, 
                                                  height: 5,
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(255, 113, 68, 144),
                                                    borderRadius: BorderRadius.circular(20), 
                                                  ),
                                                )
                                              : Container(
                                                  width: 7,
                                                  height: 7,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: const Color.fromARGB(255, 245, 244, 244).withOpacity(0.7),
                                                  ),
                                                ),
                                        );
                                      },
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
                      language == 'عربي' ? " الفئات" : " Categories", // Arabic translation
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Stack(
                      children: [
                        SizedBox(
                          height: 280,
                          child: ListView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            children: [
                              categoryCard(
                                language == 'عربي' ? "محادثة" : "Chatting", // Arabic translation
                                "assets/images/chat2.png",
                                language == 'عربي' 
                                    ? "تواصل وتفاعل وشارك لغتك الإشارية"
                                    : "Connect, communicate \n and share your sign \n language",
                                const Color.fromRGBO(159, 102, 198, 1),
                                false),
                              categoryCard(
                                language == 'عربي' ? "مترجم الإشارة" : "Sign Translator", // Arabic translation
                                "assets/images/Intersect.png",
                                language == 'عربي' 
                                    ? "ترجمة لغة الإشارة العربية إلى نص وكلام"
                                    : "Translate Arabic Sign Language to Text\n and Speech",
                                const Color.fromRGBO(159, 102, 198, 0.25).withOpacity(0.25),
                                true),
                              categoryCard(
                                language == 'عربي' ? "مترجم النص" : "Word Translator", // Arabic translation
                                "assets/images/Rectangle 119.png",
                                language == 'عربي' 
                                    ? "ترجمة النص والكلام إلى لغة الإشارة العربية"
                                    : "Translate Text and Speech\n to Arabic Sign\n Language",
                                const Color.fromRGBO(159, 102, 198, 1),
                                false),
                              categoryCard(
                                language == 'عربي' ? "مسح" : "Scan", // Arabic translation
                                "assets/images/scan.png",
                                language == 'عربي' 
                                    ? "مسح والتعرف على الإشارات أو النص فورًا"
                                    : "Scan and recognize signs \nor text instantly",
                                const Color.fromRGBO(159, 102, 198, 0.25).withOpacity(0.25),
                                true),
                            ],
                          ),
                        ),
                      ],
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

Widget categoryCard(String title, String icon, String subtitle, Color color, bool fixedColor) {
  return BlocBuilder<LanguageCubit, String>(
    builder: (context, language) {
      return Container(
        width: 180,
        margin: EdgeInsets.only(left: 5, right: 15, bottom: 10, top: 10),
        decoration: BoxDecoration(
          color: fixedColor
              ? (Theme.of(context).brightness == Brightness.dark
                  ? const Color.fromRGBO(159, 102, 198, 0.25).withOpacity(0.30)
                  : color)
              : (Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : const Color.fromARGB(255, 38, 37, 37)),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.light
                  ? const Color.fromARGB(255, 127, 126, 126).withOpacity(0.3)
                  : const Color.fromARGB(255, 75, 74, 74).withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 1),
            )    ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Image.asset(icon, height: 70),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: (title == "Sign Translator" || title == "Scan" || 
                       title == "مترجم الإشارة" || title == "مسح")
                    ? const Color.fromARGB(255, 0, 0, 0)
                    : (Theme.of(context).brightness == Brightness.light 
                        ? Colors.black 
                        : Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: (title == "Sign Translator" || title == "Scan" || 
                         title == "مترجم الإشارة" || title == "مسح")
                      ? (Theme.of(context).brightness == Brightness.light
                          ? const Color.fromARGB(255, 90, 89, 89).withOpacity(0.7)
                          : const Color.fromARGB(255, 172, 172, 172).withOpacity(0.7))
                      : (Theme.of(context).brightness == Brightness.light
                          ? const Color.fromARGB(255, 90, 89, 89).withOpacity(0.6)
                          : const Color.fromARGB(255, 172, 172, 172).withOpacity(0.6)),
                ),
              ),
            ),
            SizedBox(height: 25),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: ElevatedButton(
                  onPressed: () {
                    if (title == "Scan" || title == "مسح") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OCRPage()),
                      );
                    }
                    else if (title == 'Word Translator' || title == 'مترجم النص') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TextTranslatePage(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (title == "Sign Translator" || title == "Scan" || 
                                   title == "مترجم الإشارة" || title == "مسح")
                        ? (Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.black)
                        : const Color.fromRGBO(159, 102, 198, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    language == 'عربي' ? "ابدأ" : "Start",
                    style: TextStyle(
                      color: (title == "Sign Translator" || title == "Scan" || 
                             title == "مترجم الإشارة" || title == "مسح")
                          ? const Color.fromRGBO(159, 102, 198, 1)
                          : (Theme.of(context).brightness == Brightness.light
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}}