import 'package:flutter/material.dart';
import 'package:echo_flutter_news/screens/favorites/favorites.dart';
import 'package:echo_flutter_news/screens/search/search_screen.dart';
// import 'package:echo_flutter_news/test_screen.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedBottomNavigationIndex = 0;

  void onNewIndex(int index) {
    setState(() {
      _selectedBottomNavigationIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screens = [
      // TestScreen(),
      SearchScreen(onNewTabSelected: onNewIndex),
      ProfileScreen(onNewTabSelected: onNewIndex),
    ];
    return screens[_selectedBottomNavigationIndex];
  }
}
