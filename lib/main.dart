import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'signup.dart';

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
        '/home': (context) => MyHomePage(),
        '/signup': (context) => SignUp(),
        //Voeg op de zelfde manier een route toe
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
                //Navigeer naar het inlog pagina wanneer je op de Button klikt
                Navigator.pushNamed(
                  context,
                  '/',
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
