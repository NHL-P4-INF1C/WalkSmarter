import 'package:flutter/material.dart';
import 'pocketbase.dart';

class MyFriendsPage extends StatefulWidget {
  @override
  State<MyFriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<MyFriendsPage> {
  final pb = PocketBaseSingleton().instance;
  int _selectedIndex = 2;
  String? username;

  Future<void> deleteFriend(String friendId) async {
    try {
      // Retrieve the current user record
      final record =
          await pb.collection('users').getOne(pb.authStore.model['id']);
      final user = record.data;

      // Extract the current list of friends
      List<String> friends = List<String>.from(user['friends']);

      // Remove the specified friend
      friends.remove(friendId);

      // Update the user record with the new list of friends
      final body = <String, dynamic>{
        "friends": friends,
      };
      final updatedRecord = await pb
          .collection('users')
          .update(pb.authStore.model.id, body: body);

      print('Friend removed successfully: $updatedRecord');
    } catch (e) {
      print('Error deleting friend: $e');
    }
  }

  void _onItemTapped(int index) {
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
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

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
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: screenHeight * 0.15,
                        color: Color.fromRGBO(9, 106, 46, 1),
                        child: Center(
                          child: Text(
                            'Friends',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: screenHeight * 0.15),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 235, 235, 235),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: FutureBuilder<List<Map<String, String>>>(
                        future: fetchFriendNamesForUser(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text('No friends found'));
                          } else {
                            final friends = snapshot.data!;
                            return ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: friends.length,
                              itemBuilder: (context, index) {
                                final friend = friends[index];
                                final friendName = friend['username'];
                                final friendId = friend['id'];
                                final friendAvatar = friend['avatar'];
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/friendprofilepage',
                                        arguments: friendId,
                                      );
                                      print(friendId);
                                    },
                                    leading: CircleAvatar(
                                      radius: 24,
                                      backgroundImage: friendAvatar!.isNotEmpty
                                          ? NetworkImage(friendAvatar)
                                          : AssetImage("assets/standardProfilePicture.png") as ImageProvider,
                                    ),
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '$friendName',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete, size: 24, color: Colors.red),
                                          onPressed: () async {
                                            if (friendId != null) {
                                              await deleteFriend(friendId);
                                              setState(() {});
                                              print(friendId);
                                              print('Deleted $friendName');
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(
                  color: Color(0xFF096A2E),
                  width: 2.0,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
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
                  onTap: _onItemTapped,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, String>>> fetchFriendNamesForUser() async {
    try {
      final user =
          await pb.collection('users').getOne(pb.authStore.model['id']);
      final friendIds = user.data['friends'] as List<dynamic>;
      return fetchFriendNames(friendIds.cast<String>());
    } catch (e) {
      print('Error fetching friends: $e');
      return [];
    }
  }

  Future<List<Map<String, String>>> fetchFriendNames(List<String> friendIds) async {
    List<Map<String, String>> friends = [];
    for (String id in friendIds) {
      try {
        final friend = await pb.collection('users').getOne(id);
        final profilePictureUrl = friend.data['avatar'] != null
            ? pb.files.getUrl(friend, friend.data['avatar']).toString()
            : '';
        friends.add({
          'id': id,
          'username': friend.data['username'],
          'avatar': profilePictureUrl,
        });
      } catch (e) {
        print('Error fetching friend with ID $id: $e');
      }
    }
    return friends;
  }
}
