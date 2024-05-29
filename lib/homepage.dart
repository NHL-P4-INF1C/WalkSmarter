import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class UserDialog extends StatelessWidget {
  final PocketBase client = PocketBase('https://inf1c-p4-pocketbase.bramsuurd.nl');

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
            final data = snapshot.data!
                .where((user) => user.data['friends'] != null && user.data['friends'].isNotEmpty)
                .toList();

            if (data.isEmpty) {
              return Text('No friends found');
            }

            return Container(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final user = data[index];
                  final friends = user.data['friends'];

                  if (friends is List) {
                    return FutureBuilder<List<String>>(
                      future: fetchFriendNames(friends.cast<String>()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return ListTile(
                            title: Text('Loading friends...'),
                          );
                        } else if (snapshot.hasError) {
                          return ListTile(
                            title: Text('Error loading friends'),
                          );
                        } else {
                          final friendNames = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              ...friendNames.asMap().entries.map((entry) {
                                final rank = entry.key + 1;
                                final friendName = entry.value;
                                return ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.person, size: 24, color: Colors.amber),
                                          SizedBox(width: 10),
                                          Text(
                                            '$friendName',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.chat, size: 24, color: Colors.blue),
                                            onPressed: () {
                                              // Add your chat function here
                                              print('Chat with $friendName');
                                            },
                                          ),
                                          SizedBox(width: 10),
                                          IconButton(
                                            icon: Icon(Icons.delete, size: 24, color: Colors.red),
                                            onPressed: () async {
                                              // Add your delete function here
                                              //await deleteUser(user.id);
                                              print('Deleted $friendName');
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              SizedBox(height: 10),
                            ],
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
    List<String> friendNames = [];
    for (String id in friendIds) {
      final friend = await client.collection('users').getOne(id);
      friendNames.add(friend.data['username']);
    }
    return friendNames;
  }

  // Future<void> deleteUser(String recordId) async {
  //   try {
  //     await client.collection('users').delete(recordId);
  //     print('User with ID $recordId deleted successfully.');
  //   } catch (e) {
  //     print('Error deleting user: $e');
  //   }
  // }
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
                        Navigator.pushNamed(context, '/informationpage');
                      },
                      child: Text('Question'),
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
        selectedItemColor: Color(0xFF096A2E),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          handleSwitchCase(context, index);
          handleSwitchCase(context, index);
        },
      ),
    );
  }
}
