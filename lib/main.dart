import 'package:flutter/material.dart';
import 'package:ponggame/pong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pong Game'),
        ),
        body: SafeArea(child: pong(),),
      ),
    );
  }
}

class Ball extends StatelessWidget {
  const Ball({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
    );
  }
}

class Bat extends StatelessWidget {
  double width, height;
  Bat({required this.height,required this.width});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: Color.fromARGB(255, 110, 67, 3),
    );
  }
}
