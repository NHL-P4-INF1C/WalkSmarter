import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'signup.dart';
import 'forgotpassword.dart';
import 'mappage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      //Route map
      routes: {
        '/': (context) => LoginDemo(),
        // '/home': (context) => MyHomePage(),
        '/signup': (context) => SignUp(),
        '/fpassword': (context) => ForgotPasswordDemo(),
        '/mappage': (context) => MyHomePage(), 
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
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
