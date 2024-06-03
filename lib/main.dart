import 'package:flutter/material.dart';
import 'changeusername.dart';
import 'profileappsettings.dart';
import 'profilesettings.dart';
import 'profileusersettings.dart';
import 'loginpage.dart';
import 'signup.dart';
import 'forgotpassword.dart';
import 'homepage.dart';
import 'leaderboard.dart';
import 'profilepage.dart';
import 'questionpage.dart';
import 'friendspage.dart';
import 'informationpage.dart';
import 'pocketbase.dart';

class MyNavigatorObserver extends NavigatorObserver {
  @override
  Future<void> didPush(Route route, Route? previousRoute) async {
    try {
      print('Navigating to ${route.settings.name}');
      var pb = PocketBaseSingleton().instance;
      var authData = await pb.collection('users').authRefresh();
      print("Valid status: ${pb.authStore.isValid}");
      print("Token: ${pb.authStore.token}");
      print("Total auth data: $authData");

      super.didPush(route, previousRoute);
    } catch (error) {
      print('Error during navigation: $error');
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [MyNavigatorObserver()],
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
      // Route map
      routes: {
        '/': (context) => LoginDemo(),
        '/signup': (context) => SignUp(),
        '/fpassword': (context) => ForgotPasswordDemo(),
        '/homepage': (context) => MyHomePage(),
        '/leaderboard': (context) => LeaderboardPage(),
        '/profilepage': (context) => ProfilePage(),
        '/profilepagesettings': (context) => ProfilePageSettings(),
        '/profileusersettings': (context) => ProfileUserSettings(),
        '/profileappsettings': (context) => ProfileAppSettings(),
        '/changeusername': (context) => ChangeUsernamePage(
          userId: '5iwzvti4kqaf2zb', 
          currentUsername: 'lars',
        ),
        '/questionpage': (context) => QuestionPage(),
        '/informationpage': (context) => InformationPage(),
        '/friendspage': (context) => MyFriendsPage(),
      },
    );
  }
}
