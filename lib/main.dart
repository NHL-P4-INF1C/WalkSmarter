import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:walk_smarter/friendprofilepage.dart';
import 'package:walk_smarter/loginpage.dart';
import 'changeusername.dart';
import 'profileappsettings.dart';
import 'profilesettings.dart';
import 'profileusersettings.dart';
import 'signup.dart';
import 'forgotpassword.dart';
import 'homepage.dart';
import 'leaderboard.dart';
import 'profilepage.dart';
import 'questionpage.dart';
import 'friendspage.dart';
import 'informationpage.dart';
import 'pocketbase.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MyNavigatorObserver extends NavigatorObserver {
  @override
  Future<void> didPush(Route route, Route? previousRoute) async {
    try {
      var pb = PocketBaseSingleton().instance;
      await pb.collection('users').authRefresh();
      super.didPush(route, previousRoute);
    } catch (error) {
      print('Error during navigation: $error');
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  
  // Load environment variables
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    print('Failed to load .env file: $e');
  }
  
  PocketBaseSingleton().instance;
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      navigatorObservers: [MyNavigatorObserver()],
      themeMode: themeProvider.themeMode,
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
      darkTheme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => ProfilePage(),
        '/signup': (context) => SignUp(),
        '/fpassword': (context) => ForgotPasswordDemo(),
        '/homepage': (context) => MyHomePage(),
        '/leaderboard': (context) => LeaderboardPage(),
        '/profilepage': (context) => ProfilePage(),
        '/profilepagesettings': (context) => ProfilePageSettings(),
        '/profileusersettings': (context) => ProfileUserSettings(),
        '/profileappsettings': (context) => ProfileAppSettings(),
        '/changeusername': (context) => ChangeUsernamePage(),
        '/questionpage': (context) => QuestionPage(),
        '/informationpage': (context) => InformationPage(),
        '/friendspage': (context) => MyFriendsPage(),
        '/friendprofilepage': (context) => FriendProfilePage(),
        '/loginpage': (context) => LoginDemo(),
      },
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode =
        (_themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
