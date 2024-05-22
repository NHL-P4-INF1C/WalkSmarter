import 'package:flutter/material.dart';

class InformationPage extends StatefulWidget {
  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/homepage');
                    },
                    child: Text(
                      '< Ga Terug',
                      style: TextStyle(
                        color: Color.fromARGB(255, 11, 91, 14),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Walk Smarter',
              style: TextStyle(fontSize: 14),
            ),
            Image(
              image: AssetImage('assets/walksmarterlogo.png'),
              height: 40,
              width: 40,
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '{Monument naam}',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // placeholder banner afbeelding monument
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Center(
                      child: Text(
                        "{Banner afbeelding van monument}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/questionpage');
                      },
                      child: Text('Ga naar vraag'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
