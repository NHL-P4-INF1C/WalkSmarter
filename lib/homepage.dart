import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'utils/pocketbase.dart';
import 'components/bottombar.dart';
import 'components/navbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

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
  String _userID = pb.authStore.isValid ? pb.authStore.model['id'] : 'ErrToken';

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
      final response = await pb
          .collection('users')
          .getOne(pb.authStore.model['id'].toString());
      return response.data['points'].toString();
    } catch (error) {
      print('Error: $error');
      return 'Err';
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final jsonString =
          await pb.collection("users").getFirstListItem("id=\"$_userID\"");
      final record = jsonDecode(jsonString.toString());
      setState(() {
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

  void _showQuestionDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Point of interest found!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  }

  void handleSwitchCase(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/homepage');
        return;
      case 1:
        Navigator.pushNamed(context, '/leaderboard');
        return;
      case 2:
        Navigator.pushNamed(context, '/friendspage',
            arguments: pb.authStore.model['id']);
      default:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(profilePicture: _profilePicture),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            minMaxZoomPreference: MinMaxZoomPreference(15, 30),
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: _currentLocationMarker != null ? {_currentLocationMarker!} : {},
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.81,
              decoration: BoxDecoration(),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/informationpage');
                        },
                        child: Text('Question'),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          BottomNavBar(
            selectedIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ],
      ),
    );
  }

  Future<void> getPOIThroughHttp() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    String key = '&key=${dotenv.env['GOOGLE_API_KEY']}';
    String radius = '&radius=100';
    String location = '?location=${position.latitude}%2C${position.longitude}';
    String link = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    String request = link + location + radius + key;

    print(request);

    var response = await http.get(Uri.parse(request));
    var decodedResponse = json.decode(response.body);

    var closestPOI = decodedResponse['results'][0];
    double closestPOIDistance = 100.0;

    for(var test in decodedResponse['results'])
    {
      double lat = test['geometry']['location']['lat'] as double;
      double lng = test['geometry']['location']['lng'] as double;
      
      var distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          lat,
          lng
          );

      if(distance < closestPOIDistance){
        closestPOI = test;
        closestPOIDistance = distance;
      }
    }

    if(closestPOIDistance < 25)
    {
    _showQuestionDialog(context, 'Do you want to navigate to the information page?');
    }

    print('Distance to ${closestPOI['name']} (${closestPOI['types'][0]}): $closestPOIDistance meters');
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
    fetchLocationAndCheckProximity();
    getPOIThroughHttp();
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
      25,
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
