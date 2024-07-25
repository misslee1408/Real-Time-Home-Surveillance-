import 'package:flutter/material.dart';


class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomBottomNavigationBar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(
            Icons.person,
            color: selectedIndex == 0 ? Colors.red : Colors.white,
          ),
          onPressed: () => onItemTapped(0),
        ),
        IconButton(
          icon: Icon(
            Icons.home,
            color: selectedIndex == 1 ? Colors.red : Colors.white,
          ),
          onPressed: () => onItemTapped(1),
        ),
        IconButton(
          icon: Icon(
            Icons.settings,
            color: selectedIndex == 2 ? Colors.red : Colors.white,
          ),
          onPressed: () => onItemTapped(2),
        ),
      ],
    );
  }
}
