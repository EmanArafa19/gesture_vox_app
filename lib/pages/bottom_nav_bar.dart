import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  BottomNavBar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color backgroundColor = isDarkMode ? Colors.black : Colors.white;
    Color iconColor = isDarkMode ? Colors.white : Colors.black;
    Color selectedColor = const Color.fromRGBO(159, 102, 198, 1);

    
    List<Map<String, dynamic>> items = [
      {"icon": "assets/icons/home1.png", "label": "Home", "width": 29.0},
      {"icon": "assets/icons/sign1.png", "label": "Sign", "width": 39.0},
      {"icon": "", "label": "", "width": 0.0},
      {"icon": "assets/icons/Group.png", "label": "Word", "width": 34.0},
      {"icon": "assets/icons/settings1.png", "label": "Settings", "width": 29.0},
    ];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: Container(
            color: backgroundColor,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: backgroundColor,
              currentIndex: selectedIndex,
              selectedItemColor: selectedColor,
              unselectedItemColor: iconColor,
              onTap: onItemTapped,
              items: List.generate(items.length, (index) {
                if (index == 2) {
                  return const BottomNavigationBarItem(
                    icon: SizedBox.shrink(),
                    label: "",
                  );
                }
                return BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      Image.asset(
                        items[index]["icon"]!,
                        width: items[index]["width"], 
                        color: selectedIndex == index ? selectedColor : iconColor,
                      ),
                      if (selectedIndex == index) 
                        Text(
                          items[index]["label"]!,
                          style: TextStyle(
                            color: selectedColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  label: "",
                );
              }),
            ),
          ),
        ),

        
        Positioned(
          bottom: 45,
          left: MediaQuery.of(context).size.width / 2 - 30,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selectedColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                "assets/icons/chat.png",
                width: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
