import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pocketbase.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:permission_handler/permission_handler.dart';

var pb = PocketBaseSingleton().instance;

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  late GoogleMapController mapController;
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: dotenv.env['GOOGLE_API_KEY']);

  static const List<String> majorPlaceTypes = [
  'art_gallery', 'museum', 'library', 'cemetery', 'church', 'synagogue', 
  'mosque', 'hindu_temple', 'city_hall', 'aquarium', 'zoo', 'park', 
  'amusement_park', 'movie_theater', 'tourist_attraction', 'school', 
  'university', 'courthouse', 'embassy'
  ];

  // ignore: unused_fields
  late Position _currentPosition;
  late Timer _timer;
  Marker? _currentLocationMarker;

  final LatLng _center = const LatLng(52.778382, 6.913517);

  String mapStyle = '';
  String _profilePicture = "";
  String _userID = pb.authStore.model['id'];

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.json').then((string) {
      setState(() {
        mapStyle = string;
      });
    });
    requestLocationPermission();
    _fetchUserData();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    print('Map created and controller initialized');
    if (mapStyle.isNotEmpty) {
      mapController.setMapStyle(mapStyle);
    }
    startLocationUpdates();
  }

  Future<String> fetchPoints() async {
    try {
      final response = await pb.collection('users').getOne(pb.authStore.model['id'].toString());
      return response.data['points'].toString();
    } catch (error) {
      print('Error: $error');
      return 'Err';
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final jsonString = await pb.collection("users").getFirstListItem(
        "id=\"$_userID\""
      );
      final record = jsonDecode(jsonString.toString());
      setState(() {
        if (record["avatar"] != null) {
          _profilePicture = pb.files.getUrl(jsonString, record["avatar"]).toString();
        } else {
          _profilePicture = "";
        }
      });
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        _profilePicture = "";
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    handleSwitchCase(context, index);
  }

  void handleSwitchCase(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/homepage');
        break;
      case 1:
        Navigator.pushNamed(context, '/leaderboard');
        break;
      case 2:
        Navigator.pushNamed(context, '/friendspage', arguments: pb.authStore.model['id']);
        break;
      default:
        break;
    }
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
                backgroundImage: _profilePicture.startsWith("http")
                  ? NetworkImage(_profilePicture)
                  : AssetImage("assets/standardProfilePicture.png") as ImageProvider,
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
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: _currentLocationMarker != null ? {_currentLocationMarker!} : {},
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

  Future<void> requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      if (await Permission.locationWhenInUse.request().isGranted) {
        fetchLocation();
      } else {
        print('Location permission denied');
      }
    } else {
      fetchLocation();
    }
  }

void startLocationUpdates() {
  _timer = Timer.periodic(Duration(seconds: 60), (timer) {
    fetchLocationAndCheckProximity();
  });
}

  Future<void> fetchLocationAndCheckProximity() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      LatLng currentLatLng = LatLng(position.latitude, position.longitude);
      if (mapController != null) {
        mapController.animateCamera(CameraUpdate.newLatLng(currentLatLng));
        _currentLocationMarker = Marker(
          markerId: MarkerId('currentLocation'),
          position: currentLatLng,
        );
      } else {
        print('MapController is not initialized');
      }
    });
    print('Location: ${position.latitude}, ${position.longitude}');
    checkProximityToMajorPOI(position);
  }

Future<void> checkProximityToMajorPOI(Position position) async {
  for (String type in majorPlaceTypes) {
    final response = await _places.searchNearbyWithRadius(
      Location(lat: position.latitude,lng:  position.longitude),
      100,
      type: type,
    );

    if (response.isOkay) {
      for (var result in response.results) {
        double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          result.geometry!.location.lat,
          result.geometry!.location.lng,
        );
        print('Distance to ${result.name} ($type): $distance meters');
      }
    }
  }
}


  Future<void> fetchLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      LatLng currentLatLng = LatLng(position.latitude, position.longitude);
      mapController.animateCamera(CameraUpdate.newLatLng(currentLatLng));
      _currentLocationMarker = Marker(
        markerId: MarkerId('currentLocation'),
        position: currentLatLng,
      );
        });
    print('Location: ${position.latitude}, ${position.longitude}');
  }
}
