import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
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
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return ListTile(
                  title: Text(user.getStringValue('name')),
                  subtitle: Text(user.getStringValue('email')),
                  // Add more fields as needed
                );
              },
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
    final resultList =
        await client.collection('users').getFullList(fields: "friends");
    return resultList;
  }
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
      builder: (BuildContext context) => AlertDialog(
        content: UserDialog(),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          )
        ],
      ),
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
              height: MediaQuery.of(context).size.height * 0.86,
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
