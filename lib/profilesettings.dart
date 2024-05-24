import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:walk_smarter/loginpage.dart';
import 'package:walk_smarter/mappage.dart';
import 'package:pocketbase/pocketbase.dart';
import 'dart:convert';

final pb = PocketBase('https://inf1c-p4-pocketbase.bramsuurd.nl');

class ProfilePageSettings extends StatefulWidget {
  @override
  State<ProfilePageSettings> createState() => _ProfilePageSettingsState();
}

class _ProfilePageSettingsState extends State<ProfilePageSettings> {
  String _username = 'Loading...';
  String _profilePicture = '';
  String _userID = "9mk86rq53y5xuri";

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
                  left: 135,
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
                  left: 170,
                  top: 200, 
                  child: Text(
                    _username,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                left: 20,
                top: 300,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 10,),
                      Icon(
                        Icons.person_outline,
                        size: 30
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Profiel instellingen',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      SizedBox(width: 130),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 400,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 10),
                      Icon(
                        Icons.settings_outlined,
                        size: 30
                      ),
                      SizedBox(width: 10),
                      Text(
                        'App instellingen',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      SizedBox(width: 150),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 500,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LoginDemo(),
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 10),
                        Icon(
                          Icons.logout_outlined,
                          size: 30,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Log uit',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        SizedBox(width: 220),
                      ],
                    ),
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
