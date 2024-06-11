import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase(dotenv.env['POCKETBASE_URL']!);

class ForgotPasswordDemo extends StatefulWidget {
  const ForgotPasswordDemo();

  static Future<void> show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return const ForgotPasswordDemo();
        },
      ),
    );
  }

  @override
  State<ForgotPasswordDemo> createState() => _ForgotPasswordDemoState();
}

class _ForgotPasswordDemoState extends State<ForgotPasswordDemo> {
  String? email;
  Future<void> signIn() async {
    try {
      if (email != null) {
        await pb.collection('users').requestPasswordReset(email!);

        Navigator.pushNamed(
          context,
          '/home',
        );
        print("Request sent");
      }
    } catch (e) {
      print('Error occurred during resetting password: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: SizedBox(
          child: Center(child: Text("Forgot Password")),
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
                  //Verander hier de path naar de benodigde IMAGE PATH voor de juiste image
                  child: Image(image: AssetImage('assets/walksmarterlogo.png')),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 25),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter your Email'),
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
                  'Reset Password!',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1), fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 90,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: Text(
                'Already have an account?',
                style:
                    TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
