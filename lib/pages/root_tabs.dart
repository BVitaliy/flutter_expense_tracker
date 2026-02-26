import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/widgets/expenses.dart';
import 'package:flutter_expense_tracker/pages/games_webview_page.dart';

class RootTabs extends StatefulWidget {
  const RootTabs({super.key});

  @override
  State<RootTabs> createState() => _RootTabsState();
}

class _RootTabsState extends State<RootTabs> {
  int _index = 0;

  static const _gamesUrl = 'https://smarton-dev.moonart.net.ua/courses';   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          Expenses(),
          GamesWebViewPage(
            initialUrl: _gamesUrl,
            cookieDomain: 'smarton-dev.moonart.net.ua',
            cookieName: 'jwt', 
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset),
            label: 'Games',
          ),
        ],
      ),
    );
  }
}