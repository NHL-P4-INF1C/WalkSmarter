import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:walk_smarter/utils/pocketbase.dart';

var pb = PocketBaseSingleton().instance;

class Navbar extends StatefulWidget implements PreferredSizeWidget {
  Navbar({super.key});
  @override
  NavbarState createState() => NavbarState();

  @override
  Size get preferredSize => Size.fromHeight(50);
}

class NavbarState extends State<Navbar> {
  String profilePicture = '';
  String pointsData = "Loading..";
  String _userID = pb.authStore.isValid ? pb.authStore.model['id'] : 'ErrToken';

  Future<void> _fetchUserData() async {
    try {
      final jsonString =
          await pb.collection("users").getFirstListItem("id=\"$_userID\"");
      final record = jsonDecode(jsonString.toString());

      setState(() {
        if (record["avatar"] != null) {
          profilePicture =
              pb.files.getUrl(jsonString, record["avatar"]).toString();
        } else {
          profilePicture = "";
        }
      });
    } catch (e) {
      setState(() {
        profilePicture = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
                child: FutureBuilder<void>(
                  future: _callFunctions(),
                  builder: (context, snapshot) {
                    return Text(
                      '$pointsData Points',
                      style: TextStyle(fontSize: 14),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profilepage');
            },
            child: CircleAvatar(
              radius: 23,
              backgroundImage: profilePicture.startsWith("http")
                  ? NetworkImage(profilePicture)
                  : AssetImage("assets/standardProfilePicture.png")
                      as ImageProvider,
            ),
          ),
        ),
      ],
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
    );
  }

  Future<void> _callFunctions() async {
    await _fetchUserData();

    await fetchPoints();
  }

  Future<void> fetchPoints() async {
    try {
      final response = await pb
          .collection('users')
          .getOne(pb.authStore.model['id'].toString());
      setState(() {
        pointsData = response.data['points'].toString();
      });
    } catch (error) {
      setState(() {
        pointsData = 'Err';
      });
    }
  }
}
