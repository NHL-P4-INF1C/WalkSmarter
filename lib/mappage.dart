import 'package:flutter/material.dart';
import 'profilepage.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        actions: [
          IconButton(
            iconSize: 40,
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ));
            },

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
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/questionpage');
                      },
                      child: Text('Question Available'),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Google Maps widget here"),
                ],
              ),
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
          selectedItemColor: Color(int.parse('0xFF096A2E')),
          onTap: (index) {
          },
        ),
    );
  }
}
