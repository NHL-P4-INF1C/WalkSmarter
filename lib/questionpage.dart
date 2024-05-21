import 'package:flutter/material.dart';
import 'profilepage.dart';

class QuestionPage extends StatefulWidget {
  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int? _selectedOption; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/walksmarterlogo.png'),
              height: 40,
              width: 40,
            ),
            SizedBox(width: 8),
            Text(
              'Walk Smarter',
              style: TextStyle(fontSize: 14),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Text(
                    '1000 Points',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            iconSize: 40,
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ));
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.black,
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/homepage',
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Color.fromARGB(255, 130, 130, 130)),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  child: Text(
                    "Ga terug",
                    style: TextStyle(fontSize: 18),
                    ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    color: Colors.grey[300], // placeholder voor foto
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'monument naam placeholder',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis id aliquet ipsum, nec posuere risus. Phasellus egestas sollicitudin nunc interdum hendrerit. Phasellus nec sollicitudin felis. Aenean convallis enim in tempus iaculis. Quisque mattis accumsan turpis, ut viverra velit euismod vitae. Aenean semper, risus ac pretium rhoncus, lectus lectus sollicitudin velit, et dictum leo nibh porta augue. Morbi condimentum est quis risus aliquam, in ullamcorper diam dapibus. Praesent fermentum ullamcorper justo, eu laoreet ex venenatis ac. Vestibulum dapibus, mauris eu malesuada varius, arcu ligula faucibus enim, pellentesque ornare eros lectus sed ligula. Nunc tincidunt aliquet congue. Pellentesque placerat a ligula at eleifend. Sed ipsum velit, ullamcorper vitae neque eu, finibus volutpat est.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              Text(
                'vraag',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Column(
                children: List.generate(3, (index) {
                  return RadioListTile<int>(
                    title: Text('antwoord ${index + 1}'),
                    value: index,
                    groupValue: _selectedOption,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedOption = value;
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // logica om vraag te controleren mist nog
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 23, 113, 26)),
                    foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                    // test
                  ),
                  child: Text('Vraag controleren'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Friends',
          ),
        ],

        selectedItemColor: Color(int.parse('0xFF096A2E')),
        onTap: (index) {
        },
      ),
      bottomSheet: PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Container(
          color: Colors.black,
          height: 1.0,
        ),
      ),
    );
  }
}
