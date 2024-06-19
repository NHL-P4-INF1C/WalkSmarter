import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'components/bottombar.dart';
import "utils/apimanager.dart";

class InformationPage extends StatefulWidget {
  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  int currentIndex = 0;
  late RequestManager requestManager;
  Map<String, dynamic> payload = {};
  String monumentInformation = "loading...";
  bool isLoading = true;
  late dynamic pointOfInterestData;
  bool _initialized = false;
  late String photoLink;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      pointOfInterestData = ModalRoute.of(context)?.settings.arguments;
      List<String> location = pointOfInterestData['plus_code']['compound_code'].split(' ');
      requestManager = RequestManager({
        "pointOfInterest": "${pointOfInterestData['name']}",
        "locationOfOrigin": location.sublist(1).join(' '),
      }, "openai");
      if(pointOfInterestData['photos'] != null) {
        photoLink = 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=1920&photoreference=${pointOfInterestData['photos'][0]['photo_reference']}&key=${dotenv.env['GOOGLE_API_KEY']}';
      } else if(pointOfInterestData['icon'] != null) {
        photoLink = pointOfInterestData['icon'];
      } else {
        photoLink = '';
      }
      _initialized = true;
      _fetchData();
    }
  }

  void _fetchData() async {
    try {
      payload = await requestManager.makeApiCall();
      if (payload['statusCode'] == 200) {
        monumentInformation = payload['response']['description'];
      } else {
        monumentInformation ="${payload['response']}. Status code: ${payload['statusCode']}";
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("API call failed: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Still loading"),
          content: Text("Please wait until everything has loaded"),
          actions: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 9, 106, 46),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
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
                    onPressed: () {
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
                      pointOfInterestData['name'],
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color:
                            Colors.grey[300], // Placeholder banner image color
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Center(
                          child: Image.network(
                            photoLink,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                              return Image.asset(
                                'assets/walksmarterlogo.png',
                                  fit: BoxFit.fitHeight,
                                  width: double.infinity,
                                  height: double.infinity,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 350,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 245, 245, 245),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              monumentInformation,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
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
                        onPressed: () {
                          print(payload);
                          if (isLoading) {
                            _showLoadingDialog();
                          } else {
                            Navigator.pushNamed(
                              context,
                              "/questionpage",
                              arguments: payload,
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 9, 106, 46)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
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
        padding: EdgeInsets.only(bottom: 10, left: 15, right: 15),
        child: BottomNavBar(
          selectedIndex: currentIndex,
          onTap: onItemTapped,
        ),
      ),
    );
  }
}
