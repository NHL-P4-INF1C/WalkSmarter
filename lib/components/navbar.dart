import 'package:flutter/material.dart';
import 'package:walk_smarter/utils/pocketbase.dart';

var pb = PocketBaseSingleton().instance;

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final String profilePicture;

  const Navbar({required this.profilePicture,super.key});

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
                child: FutureBuilder<String>(
                  future: fetchPoints(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error',
                        style: TextStyle(fontSize: 14),
                      );
                    } else if (snapshot.hasData) {
                      return Text(
                        '${snapshot.data} Points',
                        style: TextStyle(fontSize: 14),
                      );
                    } else {
                      return Text(
                        '0 Points',
                        style: TextStyle(fontSize: 14),
                      );
                    }
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

  @override
  Size get preferredSize => Size.fromHeight(50);
}
