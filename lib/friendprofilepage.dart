import "package:flutter/material.dart";
import "package:walk_smarter/leaderboard.dart";
import "dart:convert";
import "dart:math";
import "utils/pocketbase.dart";
import "./components/bottombar.dart";

var pb = PocketBaseSingleton().instance;

class FriendProfilePage extends StatefulWidget {
  @override
  State<FriendProfilePage> createState() => _FriendProfilePageState();
}

class _FriendProfilePageState extends State<FriendProfilePage> {
  String _username = "Loading...";
  String _profilePicture = "";
  int currentIndex = 0;
  int amountOfPoints = 0;
  int amountOfTrophies = 0;
  String? friendId;
  String newestTrophy = 'Latest Trophy: Made an account';
  List<int> valueOfTrophies = [];

  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    friendId = ModalRoute.of(context)?.settings.arguments as String?;
    print("Friend ID: $friendId");
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (friendId == null) return;

    try {
      final jsonString =
          await pb.collection("users").getFirstListItem("id=\"$friendId\"");
      final record = jsonDecode(jsonString.toString());
      setState(() {
        _username = record["username"];
        if(record["points"] != null) {
          amountOfPoints = (record["points"]);
          _initialiseTrophies();
        }
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

  Future<void> _initialiseTrophies() async {
    setState(() {
      int points = amountOfPoints;
      amountOfTrophies = 0;
      valueOfTrophies.clear();
    
      if(amountOfPoints >= 10) {
        while (points >= 10) {
          amountOfTrophies += 1;
          valueOfTrophies.add(pow(10, amountOfTrophies).toInt());
          points ~/= 10;
        }
        newestTrophy = 'Latest Trophy: Achieved ${pow(10, amountOfTrophies).toInt()} points!';
      }
    });
  }

  Future<String> fetchPoints() async {
    try {
      final response = await pb
          .collection('users')
          .getFirstListItem("id=\"$friendId\"");
      print(response);
      return response.data['points'].toString();
    } catch (error) {
      print('Error: $error');
      return 'Err';
    }
  }

  Widget _buildTrophyWiget(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: 355,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Color(0xFF096A2E), // Green color
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Center(
                child: Image.asset(
                  "assets/award.png",
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 20, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Earned in April 2024",
                        style: TextStyle(
                          fontSize: 10,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTrophyWidgets() {
    List<Widget> trophyWidgets = [];
    int startIndex = (valueOfTrophies.length - 3).clamp(0, valueOfTrophies.length);
    List<int> lastThreeTrophies = valueOfTrophies.sublist(startIndex);

    int currentAmountOfTrophies = 0;
    for (int trophy in lastThreeTrophies) {
      if (currentAmountOfTrophies >= 3) {
        break;
      }
      trophyWidgets.add(_buildTrophyWiget("$trophy Points trophy"));
      currentAmountOfTrophies++;
    }

    if (lastThreeTrophies.isEmpty) {
      trophyWidgets.add(_buildTrophyWiget("Successfully made an account!"));
    }

    return trophyWidgets;
  }

  @override
  Widget build(BuildContext context) {
    void onItemTapped(int index) {
      setState(() {
        currentIndex = index;
      });

      switch (index) {
        case 0:
          Navigator.pushNamed(context, "/homepage");
          return;
        case 1:
          Navigator.pushNamed(context, "/leaderboard");
          return;
        case 2:
          Navigator.pushNamed(context, "/friendspage");
          return;
        default:
          return;
      }
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 243, 243),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          toolbarHeight: 50,
          automaticallyImplyLeading: true,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text("Go Back",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF096A2E))),
                  SizedBox(width: 8),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Walk Smarter",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Image(
                      image: AssetImage("assets/walksmarterlogo.png"),
                      height: 40,
                      width: 40,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 600,
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
                                  as ImageProvider)),
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
                              newestTrophy,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ]),
                    )),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 200,
                  child: Container(
                    height: 1,
                    color: Colors.black,
                  ),
                ),
                Positioned(
                  left: 30,
                  top: 220,
                  child: Text(
                    "Trophies",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  left: 200,
                  top: 220,
                  child: SizedBox(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LeaderboardPage(),
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 9, 106, 46),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 7, horizontal: 30),
                        child: Text(
                          "View more",
                          style: TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 280,
                  child: Column(
                    children: _buildTrophyWidgets(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: currentIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
