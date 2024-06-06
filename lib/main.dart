import 'package:flutter/material.dart';
import 'changeusername.dart';
import 'profilesettings.dart';
import 'profileusersettings.dart';
import 'loginpage.dart';
import 'signup.dart';
import 'forgotpassword.dart';
import 'homepage.dart';
import 'leaderboard.dart';
import 'profilepage.dart';
import 'questionpage.dart';
import 'informationpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Inter',
        primaryColor: Color.fromARGB(255, 9, 106, 46),
        colorScheme: ColorScheme.light(
        primary: Color.fromARGB(255, 9, 106, 46),
        secondary: Color.fromARGB(255, 9, 106, 46),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color.fromARGB(255, 9, 106, 46),
          selectionColor: Color.fromARGB(255, 9, 106, 46).withOpacity(0.5),
          selectionHandleColor: Color.fromARGB(255, 9, 106, 46),
        ),
      ),
      initialRoute: '/',
      //Route map
      routes: {
        '/': (context) => ProfilePage(),
        '/signup': (context) => SignUp(),
        '/fpassword': (context) => ForgotPasswordDemo(),
        '/homepage': (context) => MyHomePage(),
        '/leaderboard': (context) => LeaderboardPage(),
        '/profilepage': (context) => ProfilePage(),
        '/profilepagesettings': (context) => ProfilePageSettings(),
        '/profileusersettings': (context) => ProfileUserSettings(),
        '/changeusername': (context) => ChangeUsernamePage(userId: 'l9vygx1ssoio1ny', currentUsername: 'lars',),
        '/questionpage': (context) => QuestionPage(),
        '/informationpage': (context) => InformationPage(),
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
