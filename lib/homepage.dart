import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pocketbase.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

var pb = PocketBaseSingleton().instance;
// final places = GoogleMapsPlaces(apiKey: 'AIzaSyAOpBXEXbEuNuqD-1EujOj4TmF-4M9Evmg');

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  late GoogleMapController mapController;
  late Position _currentPosition;
  late Timer _timer;
  Marker? _currentLocationMarker;

  final LatLng _center = const LatLng(52.2691, 4.63729);

  String mapStyle = '';

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.json').then((string) {
      setState(() {
        mapStyle = string;
      });
    });
    requestLocationPermission();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (mapStyle.isNotEmpty) {
      mapController.setMapStyle(mapStyle);
    }
    startLocationUpdates();
  }

  Future<String> fetchPoints() async {
    try {
      final response = await pb.collection('users').getOne(pb.authStore.model['id']);
      return response.data['points'].toString();
    } catch (error) {
      print('Error: $error');
    }
    return 'Err';
  }

  // Future<List<PlacesSearchResult>> searchPlaces(String query, LatLng location) async {
  //   final result = await places.searchNearbyWithRadius(
  //     Location(lat: location.latitude, lng: location.longitude),
  //     500,
  //     keyword: query,
  //   );
  //   if (result.status == "OK") {
  //     return result.results;
  //   } else {
  //     throw Exception(result.errorMessage);
  //   }
  // }

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
        Navigator.pushNamed(context, '/friendspage');
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
          IconButton(
            iconSize: 40,
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, '/profilepage');
            },
          ),
        ],
        backgroundColor: Colors.white,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: GoogleMap(
              zoomControlsEnabled: false,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              markers: _currentLocationMarker != null ? {_currentLocationMarker!} : {},
            ),
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
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchLocation();
    });
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
