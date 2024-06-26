import "package:flutter/material.dart";
import './components/bottombar.dart';
import './components/darkmodebutton.dart';

class ProfileAppSettings extends StatefulWidget {
  @override
  State<ProfileAppSettings> createState() => _ProfileAppSettingsState();
}

class _ProfileAppSettingsState extends State<ProfileAppSettings> {
  int currentIndex = 0;
  String selectedLanguage = "English";

  void _onItemTapped(int index) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 243, 243),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          toolbarHeight: 50,
          automaticallyImplyLeading: false,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Color(0xFF096A2E)),
                onPressed: () {
                  Navigator.pushNamed(context, "/profilepagesettings");
                },
              ),
              SizedBox(width: 8),
              Row(
                children: [
                  Text(
                    "Go Back",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF096A2E)),
                  ),
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
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
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
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 50,
                  child: Container(
                    width: 355,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 10),
                        Text(
                          "Dark Mode",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        Spacer(),
                        DarkModeToggleSwitch(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 150,
                  child: Container(
                    width: 355,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 10),
                        Text(
                          "Language",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        Spacer(),
                        DropdownButton<String>(
                          value: selectedLanguage,
                          items: <String>["English", "Nederlands"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedLanguage = newValue!;
                            });
                          },
                        ),
                      ],
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
