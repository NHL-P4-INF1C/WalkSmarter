import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void handleSwitchCase(BuildContext context, int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, '/leaderboard');
        break;
      case 2:
        showDialogFriendList(context);
        break;
      default:
        break;
    }
  }

  void showDialogFriendList(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => UserDialog(),
    );
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
            onPressed: () {
              Navigator.pushNamed(context, '/profilepage');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.70,
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
                child: Text('Google Maps Widget Here'),
              ),
            ),
          ),
        ],
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
        selectedItemColor: Color(0xFF096A2E),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          handleSwitchCase(context, index);
        },
      ),
    );
  }
}

class UserDialog extends StatelessWidget {
  final PocketBase client =
      PocketBase('https://inf1c-p4-pocketbase.bramsuurd.nl');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Friends'),
      content: FutureBuilder<List<RecordModel>>(
        future: fetchAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No users found');
          } else {
            final data = snapshot.data!;
            return Container(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final user = data[index];
                  final friends = user.data['friends'];

                  if (friends == null || friends.isEmpty) {
                    return ListTile(
                      title: Text('No friends'),
                    );
                  } else if (friends is List) {
                    return FutureBuilder<List<String>>(
                      future: fetchFriendNames(friends.cast<String>()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListTile(
                            title: Text('Loading friends...'),
                          );
                        } else if (snapshot.hasError) {
                          return ListTile(
                            title: Text('Error loading friends'),
                          );
                        } else {
                          final friendNames = snapshot.data!;
                          return ListTile(
                            title: Text(friendNames.join(', ')),
                          );
                        }
                      },
                    );
                  } else {
                    return ListTile(
                      title: Text('Invalid friends data'),
                    );
                  }
                },
              ),
            );
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }

  Future<List<RecordModel>> fetchAllUsers() async {
    final record = await client.collection('users').getFullList();
    return record;
  }

  Future<List<String>> fetchFriendNames(List<String> friendIds) async {
    final List<String> friendNames = [];
    for (var id in friendIds) {
      final record = await client.collection('users').getOne(id);
      friendNames.add(record.data[
          'username']); // Assuming 'username' is the field for friend's name
    }
    return friendNames;
  }
}
