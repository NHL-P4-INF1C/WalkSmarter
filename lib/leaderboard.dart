import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import './components/bottombar.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  int _selectedIndex = 1;
  late String _selectedMonth;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('en', null);
    _selectedMonth = DateFormat.MMMM('en').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Color.fromRGBO(9, 106, 46, 1),
            height: double.infinity,
          ),
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    color: Color.fromRGBO(9, 106, 46, 1),
                  ),
                  AppBar(
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
                                '1001 Points',
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
                          Navigator.pushNamed(context, '/profilepage');
                        },
                      ),
                    ],
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Text(
                      'Leaderboard',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    SizedBox(width: 8),
                    PopupMenuButton<String>(
                      offset: Offset(0, 35),
                      itemBuilder: (BuildContext context) {
                        return months.map((String value) {
                          return PopupMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList();
                      },
                      onSelected: (String newValue) {
                        setState(() {
                          _selectedMonth = newValue;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                        decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.white)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedMonth,
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(Icons.arrow_drop_down, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 300,
                        color: Color.fromRGBO(9, 106, 46, 1),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Positioned(
                              bottom: 120,
                              left:
                                  MediaQuery.of(context).size.width * 0.2 - 60,
                              child: _buildTopThreeCircle(
                                  2, Colors.grey[300]!, 30,
                                  borderColor: Color(0xFFC0C0C0)),
                            ),
                            Positioned(
                              bottom: 150,
                              child: _buildTopThreeCircle(
                                  1, Colors.grey[300]!, 35,
                                  borderColor: Color(0xFFFFD700),
                                  isCrowned: true),
                            ),
                            Positioned(
                              bottom: 120,
                              right:
                                  MediaQuery.of(context).size.width * 0.2 - 60,
                              child: _buildTopThreeCircle(
                                  3, Colors.grey[300]!, 30,
                                  borderColor: Color(0xFFCD7F32)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 200),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 235, 235, 235),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: 17,
                        itemBuilder: (context, index) {
                          String position = (index + 4).toString();
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: ListTile(
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
                                    'Username',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Spacer(),
                                  Text(
                                    '1001',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 4),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          BottomNavBar(
            selectedIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
                switch (index) {
                  case 0:
                    Navigator.pushNamed(context, '/homepage');
                    return;
                  case 1:
                    Navigator.pushNamed(context, '/leaderboard');
                    return;
                  case 2:
                    Navigator.pushNamed(context, '/friendspage');
                    return;
                  default:
                    return;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopThreeCircle(int position, Color circleColor, double size,
      {bool isCrowned = false, required Color borderColor}) {
    return Column(
      children: [
        SizedBox(height: 10),
        Stack(
          alignment: Alignment.topCenter,
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
            Positioned(
              top: size * 1.5,
              child: Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: borderColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$position',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Column(
          children: [
            Text(
              '{username}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14),
            ),
            Text(
              '1001',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
