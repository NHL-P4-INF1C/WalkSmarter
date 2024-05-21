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
                    '1001 Punten',
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
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Color.fromRGBO(9, 106, 46, 1),
              borderRadius: BorderRadius.only(
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(9, 106, 46, 1),
                    borderRadius: BorderRadius.only(
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTopThreeCircle(2, Colors.grey[300]!, 30, borderColor: Color(0xFFC0C0C0)), // Silver border
                      SizedBox(width: 20),
                      _buildTopThreeCircle(1, Colors.grey[300]!, 35, borderColor: Color(0xFFFFD700), isCrowned: true), // Gold border
                      SizedBox(width: 20),
                      _buildTopThreeCircle(3, Colors.grey[300]!, 30, borderColor: Color(0xFFCD7F32)), // Bronze border
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(thickness: 2),
          Expanded(
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: 17,
              itemBuilder: (context, index) {
                String position = (index + 4).toString();
                return ListTile(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 25,
                        child: Text(
                          position,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.account_circle, size: 40),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Gebruikersnaam',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Spacer(),
                      Text(
                        '1001',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Punten',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
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
Widget _buildTopThreeCircle(int position, Color circleColor, double size, {bool isCrowned = false, required Color borderColor}) {
  return Column(
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: size + 3,
            backgroundColor: borderColor,
            child: CircleAvatar(
              radius: size,
              backgroundColor: circleColor,
              child: Icon(Icons.account_circle, size: size * 2),
            ),
          ),
          if (isCrowned)
            Positioned(
              top: -10,
              child: Text(
                '👑',
                style: TextStyle(fontSize: 24),
              ),
            ),
        ],
      ),
      Text(
        '{gebruikersnaam}',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      Text('1001',
      style: TextStyle(color: Colors.white),
      ),
    ],
  );
}
  }
