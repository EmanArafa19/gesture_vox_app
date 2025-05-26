import 'package:flutter/material.dart';
import 'package:gesture_vox_app/pages/text_translate_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gesture_vox_app/pages/background.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gesture_vox_app/pages/settings_page.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> recentHistory = [];
  List<String> favorites = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadHistory();
    _loadFavorites();
  }

  Future<void> _saveToHistory(String translatedText) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('translation_history') ?? [];

    if (history.contains(translatedText)) {
      history.remove(translatedText);
    }
    history.insert(0, translatedText);

    await prefs.setStringList('translation_history', history);
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recentHistory = prefs.getStringList('translation_history') ?? [];
    });
  }

  Future<void> _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('translation_history');
    setState(() {
      recentHistory.clear();
    });
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> _toggleFavorite(String text) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favorites.contains(text)) {
        favorites.remove(text);
      } else {
        favorites.add(text);
      }
    });
    await prefs.setStringList('favorites', favorites);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, String>(
      builder: (context, language) {
        bool isArabic = language == 'عربي';
        
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                isArabic ? 'السجل' : 'History',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Padding(
                padding: const EdgeInsets.all(10.0),
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
                  ],
                ),
              ),
              bottom: TabBar(
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [
                        Icon(Icons.history),
                        SizedBox(width: 8),
                        Text(isArabic ? 'حديث' : 'Recent'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite),
                        SizedBox(width: 8),
                        Text(isArabic ? 'المفضلة' : 'Favorites'),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.delete),
                  tooltip: isArabic ? 'مسح السجل' : 'Clear history',
                  onPressed: _clearHistory,
                )
              ],
            ),
            body: BackgroundWidget(
              child: TabBarView(
                children: [
                  _buildListView(recentHistory, isArabic),
                  _buildListView(favorites, isArabic),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView(List<String> list, bool isArabic) {
    return list.isEmpty
        ? Center(
            child: Text(
              isArabic ? 'لا توجد عناصر متاحة' : 'No items available',
              style: TextStyle(fontSize: 18),
            ),
          )
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(list[index]),
                  leading: IconButton(
                    icon: Icon(
                      favorites.contains(list[index]) 
                          ? Icons.favorite 
                          : Icons.favorite_border,
                      color: favorites.contains(list[index]) 
                          ? Color.fromRGBO(159, 102, 198, 1) 
                          : null,
                    ),
                    tooltip: isArabic 
                        ? (favorites.contains(list[index]) 
                            ? 'إزالة من المفضلة' 
                            : 'إضافة إلى المفضلة')
                        : (favorites.contains(list[index]) 
                            ? 'Remove favorite' 
                            : 'Add favorite'),
                    onPressed: () => _toggleFavorite(list[index]),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_red_eye_outlined),
                        color: const Color.fromRGBO(159, 102, 198, 1),
                        tooltip: isArabic ? 'عرض النص' : 'View text',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => 
                                  TextTranslatePage(initialText: list[index]),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}