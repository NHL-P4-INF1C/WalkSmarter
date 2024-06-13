import 'package:flutter/material.dart';

import "apimanager.dart";

class InformationPage extends StatefulWidget 
{
  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> 
{
  int currentIndex = 0;
  final requestManager = RequestManager(
    {
      "pointOfInterest":"NHL Stenden Emmen",
      "locationOfOrigin":"The Netherlands"
    }, "openai"
  );
  Map<String, dynamic> payload = {};
  String monumentInformation = "loading...";

  @override
  void initState() 
  {
    super.initState();
    _fetchData();
  }

  void _fetchData() async 
  {
    try 
    {
      payload = await requestManager.makeApiCall();
      if (payload['statusCode'] == 200) 
      {
        monumentInformation = payload['response']['description'];
      } 
      else 
      {
        monumentInformation = "${payload['response']}. Status code: ${payload['statusCode']}";
      }
    } 
    catch (e) 
    {
      print("API call failed: $e");
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: TextButton(
                    onPressed: () 
                    {
                      Navigator.pushNamed(context, "/homepage");
                    },
                    child: Text(
                      "< Go back",
                      style: TextStyle(
                        color: Color.fromARGB(255, 9, 106, 46),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(
              "Walk Smarter",
              style: TextStyle(fontSize: 14),
            ),
            Image(
              image: AssetImage("assets/walksmarterlogo.png"),
              height: 40,
              width: 40,
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "{Monument name}",
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // placeholder banner afbeelding monument
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Center(
                        child: Text(
                          "{banner picture of monument}",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 380,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 245, 245, 245),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Center(
                        child: Text(
                          monumentInformation,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: ElevatedButton(
                        onPressed: () 
                        {
                          Navigator.pushNamed(context, "/questionpage");
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 9, 106, 46)),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        child: Text(
                          "Go to question",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 15.0, left: 15.0, right: 15.0),
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
                  label: "Map",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.leaderboard),
                  label: "Leaderboard",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  label: "Friends",
                ),
              ],
              currentIndex: currentIndex,
              selectedItemColor: Color.fromARGB(255, 9, 106, 46),
              onTap: (index) 
              {
                setState(() 
                {
                  currentIndex = index;
                });
                switch (index) {
                  case 0:
                    Navigator.pushNamed(context, "/homepage");
                  case 1:
                    Navigator.pushNamed(context, "/leaderboard");
                  case 2:
                    Navigator.pushNamed(context, "/friendspage");
                  default:
                    break;
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
