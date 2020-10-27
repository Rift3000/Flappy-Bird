import 'package:flutter/material.dart';

import 'package:flappybird/barriers.dart';
import 'package:flappybird/bird.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static double birdYAxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = birdYAxis;
  bool gameHasStarted = false;
  static double barrierXOne = 1;
  double barrierXTwo = barrierXOne + 1.5;
  int score = 0;
  int highscore = 0;

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYAxis;
      print(barrierXOne);
      print(score);
    });
    keepScore();
  }

  void restart() {
    barrierXOne = 1;
    barrierXTwo = barrierXOne + 1.5;
    time = 0;
    birdYAxis = 0;
    height = 0;
    score = 0;
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      time += 0.04;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        birdYAxis = initialHeight - height;

        barrierXOne -= 0.05;
        barrierXTwo -= 0.05;
      });

      setState(() {
        if (barrierXOne < -2) {
          barrierXOne += 3.5;
        } else {
          barrierXOne -= 0.04;
        }
      });

      setState(() {
        if (barrierXTwo < -2) {
          barrierXTwo += 3.5;
        } else {
          barrierXTwo -= 0.04;
        }
      });

      if (birdYAxis > 1.2) {
        timer.cancel();
        gameHasStarted = false;
        _showDialog();
      }
    });
  }

  void keepScore() {
    setState(() {
      if (barrierXOne > 0.04) {
        score += 1;
      } else if (barrierXOne < 0.04) {
        score += 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  AnimatedContainer(
                    alignment: Alignment(0, birdYAxis),
                    duration: Duration(milliseconds: 100),
                    color: Colors.blue,
                    child: MyBird(),
                  ),
                  Container(
                    alignment: Alignment(0, -0.3),
                    child: gameHasStarted
                        ? Text(" ")
                        : Text(" T A P  T O  P L A Y",
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXOne, 1.4),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: 150.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXOne, -1.4),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: 150.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXTwo, 1.2),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: 100.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXTwo, -1.2),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: 220.0,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "SCORE",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(score.toString(),
                            style:
                                TextStyle(color: Colors.white, fontSize: 35)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "BEST",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(highscore.toString(),
                            style:
                                TextStyle(color: Colors.white, fontSize: 35)),
//                        FloatingActionButton(
//                          child: Icon(
//                            Icons.add,
//                          ),
//                          onPressed: _showDialog,
//                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "GAME OVER",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "SCORE:  ${score.toString()}",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            actions: [
              FlatButton(
                child:
                    Text("PLAY AGAIN", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  if (score > highscore) {
                    highscore = score;
                  }
                  setState(() {
                    gameHasStarted = false;
                  });
                  restart();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
