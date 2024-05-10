import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('https://inf1c-p4-pocketbase.bramsuurd.nl');

void main() {
  runApp(MyApp());
}

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
    try {
      if (username != null && password != null) {
        await pb.collection('users').authWithPassword(username!, password!);

        Navigator.pushNamed(
          context,
          '/home',
        );
        print("Ingelogd!!");
      }
    } catch (e) {
      print('Error occurred during authentication: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: SizedBox(
          child: Center(child: Text("Login Page")),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0, bottom: 60.0),
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 150,
                  //Verander hier de path naar de benodigde IMAGE PATH
                  child: Image(image: AssetImage('assets/logocolor.png')),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              //Email veld
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    username = value;
                  });
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter your Username'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //Password veld
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
                    hintText: 'Enter password'),
              ),
            ),
            //Password vergeten
            TextButton(
              onPressed: () {
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(160, 32, 240, 1),
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
            SizedBox(
              height: 130,
            ),
            RichText(
                text: TextSpan(
                    style: TextStyle(color: Colors.blue, fontSize: 20.0),
                    children: <TextSpan>[
                  TextSpan(
                      text: 'SignUp!',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, '/signup');
                        }),
                ]))
          ],
        ),
      ),
    );
  }
}
