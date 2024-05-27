import 'package:flutter/material.dart';
import 'package:walk_smarter/loginpage.dart';
import 'package:walk_smarter/mappage.dart';
import 'package:pocketbase/pocketbase.dart';
import 'dart:convert';

import 'package:walk_smarter/profilesettings.dart';

final pb = PocketBase('https://inf1c-p4-pocketbase.bramsuurd.nl');

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = 'Loading...';
  String _profilePicture = '';
  String _userID = "08ars3msi5hgi5o";

  @override
  void initState() 
  {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try
    {
      final jsonString = await pb.collection('users').getFirstListItem(
        'id="$_userID"' 
      );
      final record = jsonDecode(jsonString.toString());
      setState(() 
      {
        _username = record["username"];
        if(record['avatar'] != null)
        {
          _profilePicture = pb.files.getUrl(jsonString, record['avatar']).toString();          
        }
        else
        {
          _profilePicture = '';
        }
      });
    } 
    catch (e) 
    {
      print('Error fetching user data: $e');
      setState(() 
      {
        _username = 'Error loading username';
        _profilePicture = '';
      });
    }
  }
  
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
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 800,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 245, 243, 243),
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
            child: Stack(
              alignment: Alignment.topLeft, 
              children: [
                Positioned(
                  left: 10,
                  top: 50, 
                  child: SizedBox(
                    width: 130,
                    height: 130,
                    child: CircleAvatar(
                      radius: 0,
                      backgroundImage: _profilePicture.startsWith('http')
                        ? NetworkImage(_profilePicture) 
                        : AssetImage('assets/standardProfilePicture.png') as ImageProvider
                    ) 
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 10, 
                  child: Text(
                    _username,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  left: 150,
                  top: 50, 
                  child: Text(
                    'Laatste Trofee',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  left: 150,
                  top: 80,
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/award.png',
                          width: 40,
                          height: 40,
                        ),
                        Text(
                          'April 2024',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                        )
                      ]
                      ),
                  )
                ),
                Positioned(
                left: 150,
                top: 145,
                child: SizedBox(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfilePageSettings(),
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 216, 219, 216), 
                        borderRadius: BorderRadius.circular(8), 
                      ),
                      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 14), 
                      child: Text(
                        'Profiel aanpassen',
                        style: TextStyle(fontSize: 12, color: const Color.fromARGB(255, 0, 0, 0)), 
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 400,
                child: Container(
                  height: 1,
                  color: Colors.black,
                ),
              ),
              Positioned(
                  left: 30,
                  top: 420, 
                  child: Text(
                    'Vrienden',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  left: 200,
                  top: 420,
                  child: SizedBox(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginDemo(),
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 9, 106, 46), 
                          borderRadius: BorderRadius.circular(8), 
                        ),
                        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 30), 
                        child: Text(
                          'Meer weergeven',
                          style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 255, 255, 255)), 
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                left: 20,
                top: 480,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '1',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.account_circle,
                        size: 40
                      ),
                      SizedBox(width: 10),
                      Text(
                        '{gebruikersnaam}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      SizedBox(width: 100),
                      Icon(
                        Icons.more_horiz,
                        size: 40,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 580,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '2',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.account_circle,
                        size: 40
                      ),
                      SizedBox(width: 10),
                      Text(
                        '{gebruikersnaam}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      SizedBox(width: 100),
                      Icon(
                        Icons.more_horiz,
                        size: 40,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 680,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '3',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.account_circle,
                        size: 40
                      ),
                      SizedBox(width: 10),
                      Text(
                        '{gebruikersnaam}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      SizedBox(width: 100),
                      Icon(
                        Icons.more_horiz,
                        size: 40,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ],
                  ),
                ),
              ),
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
            if (index == 0) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MyHomePage(),
              ));
            }
          }
        ),
    );
  }
}
