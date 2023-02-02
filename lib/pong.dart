import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ponggame/main.dart';

enum Direction { up, down, left, right }

class pong extends StatefulWidget {
  const pong({Key? key}) : super(key: key);

  @override
  State<pong> createState() => _pongState();
}

class _pongState extends State<pong> with SingleTickerProviderStateMixin {
  double width = 0;
  double height = 0;
  double posy = 0;
  double posx = 0;
  double batwidth = 0;
  double batheight = 0;
  double batPosition = 0;
  late AnimationController controller;
  late Animation<double> animation;
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;
  double increment = 5;
  double randX = 1;
  double randY = 1;
  int score = 0;
  double randomNumber() {
    //this is a number between 0.5 and 1.5;
    var ran = new Random();
    int myNum = ran.nextInt(101);
    return (50 + myNum) / 100;
  }

  void checkBorders() {
    double diameter = 50;
    if (posx <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      randX = randomNumber();
    }
    if (posx >= width - diameter && hDir == Direction.right) {
      hDir = Direction.left;
      randX = randomNumber();
    }
    //check the bat position as well
    if (posy >= height - diameter - batheight && vDir == Direction.down) {
      //check if the bat is here, otherwise loose
      if (posx >= (batPosition - diameter) &&
          posx <= (batPosition + batwidth + diameter)) {
        vDir = Direction.up;
        randY = randomNumber();
        safeState(() {
          score++;
        });
      } else {
        controller.stop();
        showMessage(context);
      }
    }
    if (posy <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
      randY = randomNumber();
    }
  }

  void moveBat(DragUpdateDetails update) {
    safeState(() {
      batPosition += update.delta.dx;
    });
  }

  void safeState(Function function) {
    if (mounted && controller.isAnimating) {
      setState(() {
        function();
      });
    }
  }

  void showMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Game over noop'),
            actions: [
              FlatButton(
                  onPressed: () {
                    setState(() {
                      posx = 0;
                      posy = 0;
                      score = 0;
                    });
                    Navigator.pop(context);
                    controller.repeat();
                  },
                  child: Text('Playe Again')),
              FlatButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => false);
                    dispose();
                  },
                  child: Text('exit')),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    posx = 0;
    posy = 0;
    controller = AnimationController(
      duration: const Duration(minutes: 10000),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 100).animate(controller);
    animation.addListener(() {
      setState(() {
        hDir == Direction.right
            ? posx += ((increment * randX).round())
            : posx -= ((increment * randX).round());

        vDir == Direction.down
            ? posy += ((increment * randY).round())
            : posy -= ((increment * randY).round());
      });
      safeState(() {
        (hDir == Direction.right) ? posx += increment : posx -= increment;
        (vDir == Direction.down) ? posy += increment : posy -= increment;
      });
      checkBorders();
    });
    controller.forward();
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      height = constraints.maxHeight;
      width = constraints.maxWidth;
      batheight = height / 20;
      batwidth = width / 5;
      return Stack(
        children: [
          Positioned(
              top: 0, right: 25, child: Text('Score ${score.toString()}')),
          Positioned(
            child: Ball(),
            top: posy,
            left: posx,
          ),
          Positioned(
            child: GestureDetector(
                onHorizontalDragUpdate: (update) => moveBat(update),
                child: Bat(height: batheight, width: batwidth)),
            bottom: 0,
            left: batPosition,
          ),
        ],
      );
    });
  }
}
