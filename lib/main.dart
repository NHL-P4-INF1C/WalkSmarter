import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'signup.dart';
import 'forgotpassword.dart';
import 'homepage.dart';
import 'leaderboard.dart';
import 'profilepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Inter'),
      initialRoute: '/',
      //Route map
      routes: {
        '/': (context) => LoginDemo(),
        '/signup': (context) => SignUp(),
        '/fpassword': (context) => ForgotPasswordDemo(),
        '/homepage': (context) => MyHomePage(),
        '/leaderboard': (context) => LeaderboardPage(),
        '/profilepage': (context) => ProfilePage(),
      },
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Home page",
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/login',
                );
              },
              child: Text('Go to log in page'),
            ),
          ],
        ),
      ),
    );
  }
}
