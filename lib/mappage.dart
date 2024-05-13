// my_app.dart

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {}

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Logo'),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Text(
                    '1000 Points',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            iconSize: 40,
            icon: Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.81,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black,
                width: 1,
              ),
              bottom: BorderSide(
                color: Colors.black,
                width: 1,
              ),
            ),
          ),
          child: Center(
            child: Text('Google Maps Widget Here'),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Friends',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF096A2E),
        onTap: _onItemTapped,
      ),
    );
  }
}
