import 'package:flutter/material.dart';
import 'package:walk_smarter/loginpage.dart';
import 'package:walk_smarter/mappage.dart';
import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('https://inf1c-p4-pocketbase.bramsuurd.nl');

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
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
            child: Stack(
              alignment: Alignment.topLeft, 
              children: [
                Positioned(
                  left: 10,
                  top: 50, 
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: Image.asset('assets/crusaderlogo.png'),
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 10, 
                  child: Text(
                    'Gebruikersnaam',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  left: 50,
                  top: 250,
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.group_add,
                          size: 80,
                        ),
                        Text(
                          'Friends',
                          style: TextStyle(fontSize: 18),
                        )
                      ]
                      ),
                  )
                ),
                Positioned(
                  left: 220,
                  top: 250,
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/award.png',
                        width: 80,
                        height: 80,
                        ),
                        Text(
                          'Achievements',
                          style: TextStyle(fontSize: 18),
                        )
                      ]
                      ),
                  )
                ),
                Positioned(
                  left: 50,
                  top: 400,
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.groups_2,
                          size: 80,
                        ),
                        Text(
                          'Groups',
                          style: TextStyle(fontSize: 18),
                        )
                      ]
                      ),
                  )
                ),
                Positioned(
                  left: 250,
                  top: 400,
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.settings,
                          size: 80,
                        ),
                        Text(
                          'Settings',
                          style: TextStyle(fontSize: 18),
                        )
                      ]
                      ),
                  )
                ),
               Positioned(
                left: 145,
                top: 575,
                child: SizedBox(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LoginDemo(),
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 17, 118, 20), 
                        borderRadius: BorderRadius.circular(8), 
                      ),
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12), 
                      child: Text(
                        'Log out',
                        style: TextStyle(fontSize: 18, color: Colors.white), 
                      ),
                    ),
                  ),
                ),
              )

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