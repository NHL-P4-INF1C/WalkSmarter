import 'package:flutter/material.dart';
import 'dart:convert';
import 'utils/pocketbase.dart';
import 'package:walk_smarter/profilesettings.dart';
import 'components/bottombar.dart';
import 'components/navbar.dart';

var pb = PocketBaseSingleton().instance;

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = "Loading...";
  String _profilePicture = "";
  String _userID = pb.authStore.model['id'];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final jsonString =
          await pb.collection("users").getFirstListItem("id=\"$_userID\"");
      final record = jsonDecode(jsonString.toString());
      setState(() {
        _username = record["username"];
        if (record["avatar"] != null) {
          _profilePicture =
              pb.files.getUrl(jsonString, record["avatar"]).toString();
        } else {
          _profilePicture = "";
        }
      });
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        _username = "Error loading username";
        _profilePicture = "";
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchUserData();
  }

  Future<void> deleteUser(String recordId) async {
    try {
      await pb.collection('users').delete(recordId);
      print('User with ID $recordId deleted successfully.');
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  Future<List<Map<String, String>>> fetchFriendNamesForUser() async {
    print(pb.authStore.model['id']);
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
          'id': friend.id,
          'username': friend.data['username'],
          'avatar': profilePictureUrl,
        });
      } catch (e) {
        print('Error fetching friend with id $id: $e');
      }
    }
    return friends;
  }

  Future<String> fetchPoints() async {
    try {
      final response = await pb
          .collection('users')
          .getOne(pb.authStore.model['id'].toString());
      return response.data['points'].toString();
    } catch (error) {
      print('Error: $error');
      return 'Err';
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/homepage');
        break;
      case 1:
        Navigator.pushNamed(context, '/leaderboard');
        break;
      case 2:
        Navigator.pushNamed(context, '/friendspage',
            arguments: pb.authStore.model['id']);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 243, 243),
      appBar: Navbar(profilePicture: _profilePicture),
      body: SingleChildScrollView(
        child: Container(
          height: 1000,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 245, 243, 243),
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
                        backgroundImage: _profilePicture.startsWith("http")
                            ? NetworkImage(_profilePicture)
                            : AssetImage("assets/standardProfilePicture.png")
                                as ImageProvider,
                      )),
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
                    "Last Trophy",
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
                        Image.asset(
                          'assets/award.png',
                          width: 40,
                          height: 40,
                        ),
                        Text(
                          'April 2024',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
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
                        padding:
                            EdgeInsets.symmetric(vertical: 7, horizontal: 14),
                        child: Text(
                          "Edit profile",
                          style: TextStyle(
                              fontSize: 12,
                              color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 30,
                  top: 200,
                  child: Text(
                    'Friends',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  left: 30,
                  top: 230,
                  child: SizedBox(
                    width: 350,
                    height: 300,
                    child: FutureBuilder<List<Map<String, String>>>(
                      future: fetchFriendNamesForUser(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error fetching friends');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Text('No friends found');
                        } else {
                          final friends = snapshot.data!;
                          return ListView.builder(
                            itemCount: friends.length,
                            itemBuilder: (context, index) {
                              final friend = friends[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: friend['avatar']!
                                          .startsWith("http")
                                      ? NetworkImage(friend['avatar']!)
                                      : AssetImage(
                                              "assets/standardProfilePicture.png")
                                          as ImageProvider,
                                ),
                                title: Text(friend['username']!),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    await deleteUser(friend['id']!);
                                    setState(() {
                                      friends.removeAt(index);
                                    });
                                  },
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
        bottomNavigationBar: BottomNavBar(
        selectedIndex: currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
