import 'package:flutter/material.dart';
import './components/bottombar.dart';
import './utils/pocketbase.dart';
import 'dart:convert';

var pb = PocketBaseSingleton().instance;

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await pb.collection('users').getList();
      final userList = response.items.map((item) => item.toJson()).toList();
      userList.sort((a, b) => b['points'].compareTo(a['points']));
      setState(() {
        _users = userList;
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching user data: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> fetchPoints() async {
    try {
      final response = await pb.collection('users').getOne(pb.authStore.model['id']);
      return response.data['points'].toString();
    } catch (error) {
      print('Error: $error');
      return 'Err';
    }
  }

  Future<void> _fetchAvatar(String userId) async {
    try {
      final jsonString = await pb.collection("users").getFirstListItem('id="$userId"');
      final record = jsonDecode(jsonString.toString());
      setState(() {
        _users = _users.map((user) {
          if (user['id'] == userId) {
            user['avatarUrl'] = record["avatar"] != null
                ? pb.files.getUrl(jsonString, record["avatar"]).toString()
                : "";
          }
          return user;
        }).toList();
      });
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        _users = _users.map((user) {
          if (user['id'] == userId) {
            user['avatarUrl'] = "";
          }
          return user;
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                              child: FutureBuilder<String>(
                                future: fetchPoints(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Text(
                                      'Loading...',
                                      style: TextStyle(fontSize: 14),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text(
                                      'Error',
                                      style: TextStyle(fontSize: 14),
                                    );
                                  } else {
                                    return Text(
                                      '${snapshot.data} Points',
                                      style: TextStyle(fontSize: 14),
                                    );
                                  }
                                },
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
                              left: MediaQuery.of(context).size.width * 0.2 - 60,
                              child: _buildTopThreeCircle(2, Colors.grey[300]!, 30, borderColor: Color(0xFFC0C0C0)),
                            ),
                            Positioned(
                              bottom: 150,
                              child: _buildTopThreeCircle(1, Colors.grey[300]!, 35, borderColor: Color(0xFFFFD700), isCrowned: true),
                            ),
                            Positioned(
                              bottom: 120,
                              right: MediaQuery.of(context).size.width * 0.2 - 60,
                              child: _buildTopThreeCircle(3, Colors.grey[300]!, 30, borderColor: Color(0xFFCD7F32)),
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
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: _users.length <= 3 ? 0 : _users.length - 3,
                              itemBuilder: (context, index) {
                                var user = _users[index + 3];
                                String position = (index + 4).toString();
                                _fetchAvatar(user['id']);
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                                          backgroundImage: user['avatarUrl'] != null && user['avatarUrl'].isNotEmpty
                                              ? NetworkImage(user['avatarUrl'])
                                              : AssetImage('assets/default_avatar.png') as ImageProvider,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          user['username'],
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        Spacer(),
                                        Text(
                                          user['points'].toString(),
                                          style: TextStyle(fontWeight: FontWeight.bold),
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
                    break;
                  case 1:
                    Navigator.pushNamed(context, '/leaderboard');
                    break;
                  case 2:
                    Navigator.pushNamed(context, '/friendspage');
                    break;
                  default:
                    break;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopThreeCircle(int position, Color circleColor, double size, {bool isCrowned = false, required Color borderColor}) {
    var user = _users.length >= position ? _users[position - 1] : null;
    if (user != null && user['avatarUrl'] == null) {
      _fetchAvatar(user['id']);
    }
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
                backgroundImage: user != null && user['avatarUrl'] != null && user['avatarUrl'].isNotEmpty
                    ? NetworkImage(user['avatarUrl'])
                    : AssetImage('assets/default_avatar.png') as ImageProvider,
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
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        if (user != null)
          Column(
            children: [
              Text(
                user['username'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                user['points'].toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
      ],
    );
  }
}
