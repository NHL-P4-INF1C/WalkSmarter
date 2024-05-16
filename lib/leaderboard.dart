import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    String currentMonth = DateFormat('MMMM').format(DateTime.now());

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
            onPressed: () {},
          ),
        ],
      ),
body: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            'Leaderboard',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(width: 8),
          Text(
            currentMonth,
            style: TextStyle(fontSize: 20),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // Add functionality for the button here
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color.fromRGBO(9, 106, 46, 1)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                child: Text(
                  'Selecteer maand',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    Expanded(
      child: ListView.builder(
        itemCount: 10, // Example number of items
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item $index'),
            // Add more widgets for each item as needed
          );
        },
      ),
    ),
  ],
),



      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
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
    );
  }
}
