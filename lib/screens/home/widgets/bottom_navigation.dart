import 'package:flutter/material.dart';
import 'package:money_manager/screens/home/screen_home.dart';

class MoneyBottomNavigation extends StatelessWidget {
  const MoneyBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ScreenHome.selectedNotifier,
      builder: (BuildContext context, int updatedIndex, Widget? _) {
        return BottomNavigationBar(
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.blue,
            currentIndex: updatedIndex,
            onTap: (value) {
              ScreenHome.selectedNotifier.value = value;
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.currency_rupee), label: 'Transactions'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category), label: 'Category'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.analytics), label: 'Analytics'),
            ]);
      },
    );
  }
}
