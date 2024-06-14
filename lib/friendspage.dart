import 'package:flutter/material.dart';
import './utils/pocketbase.dart';
import 'friendDialog.dart';
import './components/navbar.dart';
import './components/bottombar.dart';

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
      final user =
          await pb.collection('users').getOne(pb.authStore.model['id']);
      List<String> friends = List<String>.from(user.data['friends']);
      friends.remove(friendId);

      final body = <String, dynamic>{
        "friends": friends,
      };
      final record = await pb
          .collection('users')
          .update(pb.authStore.model['id'], body: body);
      print(record);
    } catch (e) {
      print('Error deleting friend: $e');
    }
  }

  Future<void> addFriend(friendName) async {
    try {
      final user =
          await pb.collection('users').getOne(pb.authStore.model['id']);
      List<String> friends = List<String>.from(user.data['friends']);

      final friendRecords = await pb.collection('users').getFullList(
            filter: 'username="$friendName"',
          );

      if (friendRecords.isNotEmpty) {
        final friend = friendRecords.first;
        friends.add(friend.id);

        final body = <String, dynamic>{
          "friends": friends,
        };

        final updatedRecord = await pb
            .collection('users')
            .update(pb.authStore.model['id'], body: body);
        print('Friend added successfully: $updatedRecord');
      } else {
        print('Friend not found');
      }
    } catch (e) {
      print('Error adding friend: $e');
    }
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

  Future<List<Map<String, String>>> fetchFriendNames(
      List<String> friendIds) async {
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: Navbar(
          profilePicture:
              'path/to/profile/picture'), // Replace with actual profile picture path
      body: Stack(
        children: [
          Container(
            color: Color.fromRGBO(9, 106, 46, 1),
            height: double.infinity,
          ),
          Column(
            children: [
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
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            alignment: Alignment(0.9, 0),
                            child: GestureDetector(
                              onTap: () async {
                                String? friendName = await showInputDialog(
                                    context,
                                    'Enter Name',
                                    'Type your name here');
                                await addFriend(friendName);
                                setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 9, 106, 46),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 30),
                                child: Text(
                                  "Add Friend",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: FutureBuilder<List<Map<String, String>>>(
                              future: fetchFriendNamesForUser(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('No friends found'),
                                      ],
                                    ),
                                  );
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
                                        margin: EdgeInsets.only(
                                            left: 20, right: 20, top: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 5,
                                              offset: Offset(0, 5),
                                            ),
                                          ],
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
                                            backgroundImage: friendAvatar!
                                                    .isNotEmpty
                                                ? NetworkImage(friendAvatar)
                                                : AssetImage(
                                                        "assets/standardProfilePicture.png")
                                                    as ImageProvider,
                                          ),
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(width: 30),
                                                  Text(
                                                    '$friendName',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(width: 10),
                                                  IconButton(
                                                    icon: Icon(Icons.delete,
                                                        size: 24,
                                                        color: Colors.red),
                                                    onPressed: () async {
                                                      if (friendId != null) {
                                                        await deleteFriend(
                                                            friendId);
                                                        setState(() {});
                                                        print(friendId);
                                                        print(
                                                            'Deleted $friendName');
                                                      }
                                                    },
                                                  ),
                                                ],
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
              ),
            ],
          ),
          BottomNavBar(
            selectedIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ],
      ),
    );
  }
}
