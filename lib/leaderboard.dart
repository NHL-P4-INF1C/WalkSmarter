import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  int _selectedIndex = 1;
  late String _selectedMonth;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('nl', null);
    _selectedMonth = DateFormat.MMMM('nl').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    List<String> months = [
      'januari', 'februari', 'maart', 'april', 'mei', 'juni',
      'juli', 'augustus', 'september', 'oktober', 'november', 'december'
    ];

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
                DropdownButton<String>(
                  value: _selectedMonth,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                    color: Color.fromRGBO(9, 106, 46, 1),
                    fontSize: 20,
                  ),
                  underline: Container(
                    height: 2,
                    color: Color.fromRGBO(9, 106, 46, 1),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMonth = newValue!;
                    });
                  },
                  items: months.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: 20,
              itemBuilder: (context, index) {
                String position;
                String emoji;
                switch (index) {
                  case 0:
                    position = '1';
                    emoji = '🏆';
                    break;
                  case 1:
                    position = '2';
                    emoji = '🥈';
                    break;
                  case 2:
                    position = '3';
                    emoji = '🥉';
                    break;
                  default:
                    position = '${index + 1}';
                    emoji = '';
                }
                return Container(
                  decoration: BoxDecoration(
                    // border: Border(
                    //   top: BorderSide(color: Colors.grey),
                    //   bottom: BorderSide(color: Colors.grey),
                    // ),
                  ),
                  child: ListTile(
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 25, // Set a fixed width for the ranking column
                          child: Text(
                            position,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ), // Display the position
                        SizedBox(width: 8), // Add spacing between ranking and profile picture
                        CircleAvatar(
                          radius: 20, // Adjust the radius as needed
                          child: Icon(Icons.account_circle, size: 40), // Use Icon widget instead of icon property
                        ),
                        SizedBox(width: 8), // Add spacing between profile picture and name
                        Text(
                          'Gebruikersnaam',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ), // Replace with actual name
                        SizedBox(width: 4), // Add spacing between name and emoji
                        Text(
                          emoji,
                          style: TextStyle(fontSize: 20),
                        ), // Replace with actual emoji
                        Spacer(), // Add spacer to push points to the end
                        Text(
                          '1000',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ), // Replace with actual points
                        SizedBox(width: 4), // Add spacing between points and 'Points'
                        Text(
                          'Punten',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
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
