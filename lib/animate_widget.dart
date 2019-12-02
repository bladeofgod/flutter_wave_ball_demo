


import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimateWidgetCustom extends StatefulWidget{

  final double len;
  final PathMetric pm;

  AnimateWidgetCustom(this.len,this.pm);


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AnimateWidgetState(len,pm);
  }

}

class AnimateWidgetState extends State<AnimateWidgetCustom> with SingleTickerProviderStateMixin {
  final double len;
  final PathMetric pm;
  AnimateWidgetState(this.len,this.pm);

  AnimationController _controller;
  Animation _animation;

  int _seconds = 6;

  double circleLeft = 0.0;
  double circleTop = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this,duration: Duration(seconds:
    _seconds));
    WidgetsBinding.instance.addPostFrameCallback((_){
      _startAnimation(len, pm);
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    return Positioned(
      top: circleTop,
      left: circleLeft,
      child: Icon(Icons.access_alarms,color: Colors.red,),
    );
  }

  _startAnimation(double len,PathMetric pm) {
//    RenderBox renderBox = _canvasKey.currentContext.findRenderObject();
//    Size s = renderBox.size;
    print("animation len  $len");
    print("animation pm  ${pm.toString()}");
    if(pm == null) return;


    _animation = Tween(begin: 0.0, end: len).animate(_controller)
      ..addListener(() {
        //print("animation len  $len");
        //print("animation  widget start  ${_animation.value}");

        double tmpStart = _animation.value;
        double end = _animation.value > len ? len : _animation.value;
        Tangent t = pm.getTangentForOffset(tmpStart);
        setState(() {
          circleLeft = t.position.dx;
          circleTop = t.position.dy;
          print("position    : $circleLeft ___  $circleTop");
          //fraction = _animation.value;
        });
      })
      ..addStatusListener((status){
        if (status == AnimationStatus.completed) {
          _controller.stop();
        }
      });

    _controller.forward();

  }

}
















