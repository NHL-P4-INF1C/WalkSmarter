import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'components/bottombar.dart';
import "utils/pocketbase.dart";

var pb = PocketBaseSingleton().instance;

class TimerPainter extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor;
  final Color color;

  TimerPainter({
    required this.animation,
    required this.backgroundColor,
    required this.color,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);

    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2),
      -math.pi / 2,
      -progress,
      false,
      paint,
    );

    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: '${(animation.value * 60).ceil()}',
        style: TextStyle(
          color: Color.fromARGB(255, 9, 106, 46),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(size.width / 2 - textPainter.width / 2,
            size.height / 2 - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value ||
        color != oldDelegate.color ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}

class QuestionPage extends StatefulWidget {
  final Map<String, dynamic> payload;
  QuestionPage({required this.payload});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int duration = 60;
  int? selectedOption;
  String question = "loading...";
  List<String> answers = ["answer1", "answer2", "answer3"];
  int currentIndex = 0;
  late Map<String, dynamic> payload;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: duration),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        _showTimerDialog();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTimer();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments;

    if (args != null && args is Map<String, dynamic>) {
      payload = args;
      if (payload['statusCode'] == 200) {
        setState(() {
          question = payload['response']['question'];
          answers[0] = payload['response']['correct_answer'];
          answers[1] = payload['response']['wrong_answer'][0];
          answers[2] = payload['response']['wrong_answer'][1];
          answers.shuffle();
        });
      } else {
        setState(() {
          question =
              "Error: ${payload['response']}. Status code: ${payload['statusCode']}";
        });
      }
    } else {
      print(
          'Mate this thing is empty mate you gotta check widget.payload mate it contains nothing mate mate, mate');
    }
  }

  void _startTimer() {
    if (mounted) {
      _controller.reverse(from: 1.0);
    }
  }

  void _stopTimer() {
    _controller.stop();
  }

  void _showTimerDialog() {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Time's up!"),
            content: Text("You ran out of time."),
            actions: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 9, 106, 46),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text("Go back"),
                  onPressed: () {
                    Navigator.pushNamed(context, "/homepage");
                  },
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showCorrectAnswerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Correct Answer!"),
          content: Text("You've earned a point!"),
          actions: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 9, 106, 46),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text("OK"),
                onPressed: () {
                  Navigator.pushNamed(context, "/homepage");
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showWrongAnswerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Wrong answer!"),
          content: Text("Better luck next time!"),
          actions: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 9, 106, 46),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text("OK"),
                onPressed: () {
                  Navigator.pushNamed(context, "/homepage");
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _darnNoToast(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Answered correctly, but failed to update points'),
      action: SnackBarAction(
        label: 'Go back',
        onPressed: () {
          Navigator.pushNamed(context, "/homepage");
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    void onItemTapped(int index) {
      setState(() {
        currentIndex = index;
      });

      switch (index) {
        case 0:
          Navigator.pushNamed(context, "/homepage");
          return;
        case 1:
          Navigator.pushNamed(context, "/leaderboard");
          return;
        case 2:
          Navigator.pushNamed(context, "/friendspage");
          return;
        default:
          return;
      }
    }

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
                      Navigator.pushNamed(context, "/homepage");
                    },
                    child: Text(
                      "< Go back",
                      style: TextStyle(
                        color: Color.fromARGB(255, 9, 106, 46),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(
              "Walk Smarter",
              style: TextStyle(fontSize: 14),
            ),
            Image(
              image: AssetImage("assets/walksmarterlogo.png"),
              height: 40,
              width: 40,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 80),
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Center(
                            child: Text(
                              question,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -70,
                          left: (MediaQuery.of(context).size.width / 2) - 70,
                          child: CustomPaint(
                            size: Size(100, 100),
                            painter: TimerPainter(
                              animation: _controller,
                              backgroundColor: Color.fromARGB(255, 9, 106, 46),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Column(
                      children: List.generate(answers.length, (index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.all(4),
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: selectedOption == index
                                            ? Color.fromARGB(155, 9, 106, 46)
                                            : Color.fromARGB(
                                                255, 245, 245, 245),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              answers[index],
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          Radio<int>(
                                            value: index,
                                            groupValue: selectedOption,
                                            onChanged: (int? value) {
                                              setState(() {
                                                selectedOption = value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (selectedOption == index)
                                Positioned.fill(
                                  child: Container(
                                    margin: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color: Color.fromARGB(0, 171, 209, 198),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (selectedOption == null) return;

                          bool isCorrect = answers[selectedOption!] ==
                              payload['response']['correct_answer'];
                          if (isCorrect) {
                            try {
                              final userId = pb.authStore.model['id'];
                              final userRecord =
                                  await pb.collection('users').getOne(userId);

                              final currentPoints =
                                  userRecord.data['points'] ?? 0;
                              await pb
                                  .collection('users')
                                  .update(userId, body: {
                                "points": currentPoints + 1,
                              });

                              print("Points updated successfully");
                              _showCorrectAnswerDialog();
                            } catch (e) {
                              print(
                                  "Failed to update points in Pocketbase: $e");
                              // ignore: use_build_context_synchronously
                              _darnNoToast(context);
                            }
                          } else {
                            _showWrongAnswerDialog();
                          }
                          _stopTimer();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 9, 106, 46)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        child: Text(
                          "Submit answer",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: currentIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
