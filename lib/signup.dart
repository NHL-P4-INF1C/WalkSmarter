import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('https://inf1c-p4-pocketbase.bramsuurd.nl');

class SignUp extends StatefulWidget {
  const SignUp();

  static Future<void> show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return const SignUp();
        },
      ),
    );
  }

  @override
  State<SignUp> createState() => _SignUpDemo();
}

class _SignUpDemo extends State<SignUp> {
  String? username, email, password, passwordAgain;
  Future<void> signIn() async {
    try {
      if (username != null &&
          email != null &&
          password != null &&
          passwordAgain != null) {
        if (password == passwordAgain) {
          final body = <String, dynamic>{
            "username": username,
            "email": email,
            "emailVisibility": true,
            "password": password,
            "passwordConfirm": passwordAgain,
          };
          await pb.collection('users').create(body: body);
          await pb.collection('users').requestVerification(email!);

          Navigator.pushNamed(
            context,
            '/mappage',
          );
          print("New user created");
        }
      }
    } catch (e) {
      print('Error occurred during authentication: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _visible = true;
    //backgroundColor: _isDarkMode ? 1.0 : 0.0,
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Opacity(
          // ignore: dead_code
          opacity: _visible ? 1.0 : 0.0,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 100.0, bottom: 60.0),
                child: Center(
                  child: SizedBox(
                    width: 200,
                    height: 150,
                    //Verander hier de path naar de benodigde IMAGE PATH
                    child:
                        Image(image: AssetImage('assets/walksmarterlogo.png')),
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
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontSize: 15,
                      ),
                    ),
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
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your new Username',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-mail',
                      hintText: 'Enter your email'),
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
                    labelText: 'Enter your new password',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 15),
                child: TextField(
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      passwordAgain = value;
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Re-enter your password',
                      hintText: 'Password must be the same!'),
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
                    'Sign Up',
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1), fontSize: 25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
