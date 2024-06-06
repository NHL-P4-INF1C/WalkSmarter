import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pocketbase.dart';

var pb = PocketBaseSingleton().instance;

class LoginDemo extends StatefulWidget {
  const LoginDemo();
  static Future<void> show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return const LoginDemo();
        },
      ),
    );
  }

  @override
  State<LoginDemo> createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  String? username, password;

  Future<void> signIn() async {
    if(dotenv.env["DEV_ENV"] != null)
    {
      Navigator.pushNamed(
        context,
        '/homepage',
      );
    }
    try {
      if (username != null && password != null) {
        await pb.collection('users').authWithPassword(username!, password!);

        if (!mounted) return;

        Navigator.pushNamed(
          context,
          '/homepage',
        );
        print("Ingelogd!!");
      }
    } catch (e) {
      _showErrorDialog(context, 'Invalid username or password. Try again.');
      print('Error occurred during authentication: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Failed'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 150, bottom: 60.0),
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 150,
                  // Verander hier de path naar de benodigde IMAGE PATH voor de juiste image
                  child: Image(image: AssetImage('assets/walksmarterlogo.png')),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                  child: Text('Login',
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    username = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  hintText: 'Enter your Username',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 9, 106, 46),
                  ),
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 9, 106, 46),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter password',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 9, 106, 46),
                  ),
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 9, 106, 46),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/fpassword');
                },
                child: Text(
                  'Forgot Password',
                  style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1), fontSize: 15),
                ),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(9, 106, 46, 1),
                  borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  signIn();
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
