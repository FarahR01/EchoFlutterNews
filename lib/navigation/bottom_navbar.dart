import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({
    super.key,
    required this.selected,
    required this.onTap,
  });
  final int selected;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: const Color(0xFFF7BD5F), // Couleur de l'élément sélectionné
      currentIndex: selected,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.article_rounded),
          label: 'Articles',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_rounded),
          label: 'Favorites',
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.surface, // Fond pour la barre de navigation
      onTap: (index) {
        onTap(index);
      },
    );
  }
}
