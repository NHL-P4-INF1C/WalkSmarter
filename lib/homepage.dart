import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Center(
              child: Text('Google Maps Widget Here'),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: PreferredSize(
              preferredSize: Size.fromHeight(80.0),
              child: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: 50,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/walksmarterlogo.png'),
                      height: 40,
                      width: 40,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Walk Smarter',
                      style: TextStyle(fontSize: 14),
                    ),
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
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(
                  color: Color(0xFF096A2E),
                  width: 2.0,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: BottomNavigationBar(
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
                  selectedItemColor: Color(0xFF096A2E),
                  currentIndex: _selectedIndex,
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                    switch (index) {
                      case 0:
                        Navigator.pushNamed(context, '/homepage');
                        break;
                      case 1:
                        Navigator.pushNamed(context, '/leaderboard');
                        break;
                      case 2:
                        Navigator.pushNamed(context, '/friends');
                        break;
                      default:
                        break;
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
