import 'package:flutter/material.dart';
import 'package:walk_smarter/loginpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello, World!',
      home: MyHomePage(),
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
            ElevatedButton(
          onPressed: () {
            // Navigate to the second page when the button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginDemo()),
            );
          },
          child: Text('Go to Second Page'),
        ),
          ],
          
        ),
        
      ),
    );
  }
}
