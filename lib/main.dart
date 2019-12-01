import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_wave_ball/path_animation.dart';

import 'bezier_circle_progress.dart';
import 'bezier_one.dart';
import 'custome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Size size = MediaQuery.of(context).size;
      Screen.screenWidthDp = size.width;
      Screen.screenHeightDp = size.height;
    });

  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
        body: PathAnimation(),
        //body: WidgetCircleProgressWidget(),
//      body:Center(
//        child: CustomBezierWidget1(),
//      ),

    );
  }
}



























