import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  BottomNavBar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color backgroundColor = isDarkMode ? Colors.black : Colors.white;
    Color iconColor =
        const Color.fromRGBO(157, 178, 206, 1);
    Color selectedColor = const Color.fromRGBO(159, 102, 198, 1);
    Color fabIconColor = isDarkMode ? Colors.black : Colors.white;

    List<Map<String, dynamic>> items = [
      {"icon": "assets/icons/home1.svg", "label": "Home", "width": 22.0},
      {"icon": "assets/icons/sign1.svg", "label": "Sign", "width": 30.0},
      {"icon": "", "label": "", "width": 0.0},
      {"icon": "assets/icons/Group.svg", "label": "Word", "width": 23.0},
      {"icon": "assets/icons/settings1.svg", "label": "Settings", "width": 25.0},
    ];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipPath(
          child: Container(
            height: 60,
            color: backgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (index) {
                if (index == 2) {
                  return const SizedBox(width: 60);
                }
                return GestureDetector(
                  onTap: () => onItemTapped(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height:7),
                      SvgPicture.asset(
                        items[index]["icon"],
                        width: items[index]["width"],
                        colorFilter: ColorFilter.mode(
                          selectedIndex == index ? selectedColor : iconColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        selectedIndex == index ? items[index]["label"] : "",
                        style: TextStyle(
                          color: selectedColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),

        Positioned(
          bottom: 25,
          left: MediaQuery.of(context).size.width / 2 - 35,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selectedColor,
              boxShadow: [
                BoxShadow(
                  color: selectedColor.withOpacity(0.7),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                "assets/icons/chat.svg",
                width: 30,
                colorFilter: ColorFilter.mode(fabIconColor, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
