import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'main.dart';
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

          Navigator.pushNamed(
            context,
            '/home',
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: SizedBox(
          child: Center(child: Text("Sign Up!")),
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
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
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
              //Email veld
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'email',
                    hintText: 'Enter your email'),
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
                    hintText: 'Enter your new password'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 15),
              //Email veld
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    passwordAgain = value;
                  });
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password again',
                    hintText: 'Enter your password again'),
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
                  'Sign Up',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            RichText(
                text: TextSpan(children: <TextSpan>[
              TextSpan(text: "Hoi"),
            ]))
          ],
        ),
      ),
    );
  }
}
