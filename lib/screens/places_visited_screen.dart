import 'package:flutter/material.dart';

class PlacesVisitedScreen extends StatelessWidget {
  const PlacesVisitedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: "Lugares"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories_outlined),
            label: "Historias"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.military_tech_outlined),
            label: "Logros"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: "Perfil"
          ),
        ]
      ),
    );
  }
}