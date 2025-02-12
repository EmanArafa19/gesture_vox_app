import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  BottomNavBar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDarkMode ? Colors.black : Colors.white,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        currentIndex: selectedIndex,
        selectedItemColor: const Color.fromRGBO(159, 102, 198, 1),
        unselectedItemColor: isDarkMode ? Colors.white : Colors.black,
        onTap: onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/home.png",
              width: 40,
              color: selectedIndex == 0 ? const Color.fromRGBO(159, 102, 198, 1) : (isDarkMode ? Colors.white : Colors.black),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/Sign.png",
              width: 40,
              color: selectedIndex == 1 ? const Color.fromRGBO(159, 102, 198, 1) : (isDarkMode ? Colors.white : Colors.black),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromRGBO(159, 102, 198, 1),
              ),
              child: Center(
                child: Image.asset(
                  "assets/icons/chat.png",
                  width: 30,
                  color: Colors.white, 
                ),
              ),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/Group.png",
              color: selectedIndex == 3 ? const Color.fromRGBO(159, 102, 198, 1) : (isDarkMode ? Colors.white : Colors.black),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/settings.png",
              color: selectedIndex == 4 ? const Color.fromRGBO(159, 102, 198, 1) : (isDarkMode ? Colors.white : Colors.black),
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}
