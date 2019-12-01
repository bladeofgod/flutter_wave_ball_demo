import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';





class PathAnimation extends StatefulWidget {
  @override
  _PathAnimationState createState() => _PathAnimationState();
}

class _PathAnimationState extends State<PathAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  double _fraction = 0.0;
  int _seconds = 6;
  Path _path;
  GlobalKey _canvasKey = GlobalKey();
  GlobalKey _endKey = GlobalKey();

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: _seconds));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Path Animation'),
      ),
      body: Container(
        color: Colors.grey,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: RaisedButton(
                onPressed: (){
                  _controller.reverse();
                },
                key: _canvasKey,
                child: Text("start"),
              ),
            ),
            CustomPaint(
              painter: PathPainter(_path, _fraction),
//              child: Container(
//                key: _canvasKey,
//                height: 500.0,
//              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 400,left: 300),
              child: RaisedButton(
                key: _endKey,
                onPressed: _startAnimation,
                child: Text('end'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Path _getPath(Size size) {
    RenderBox renderBox = _canvasKey.currentContext.findRenderObject();
    Offset offset = renderBox.localToGlobal(Offset.zero);
    print("start offset :${offset.toString()}");
    Path path = Path();
    path.moveTo(offset.dx,offset.dy);
     path.quadraticBezierTo(
         size.width / 2, offset.dy, size.width, size.height);
    //path.cubicTo(size.width / 4, 3 * size.height / 4, 3 * size.width / 4, size.height / 4, size.width, size.height);

    return path;
  }

  _startAnimation() {
//    RenderBox renderBox = _canvasKey.currentContext.findRenderObject();
//    Size s = renderBox.size;
    RenderBox renderBox = _endKey.currentContext.findRenderObject();
    Offset offset = renderBox.localToGlobal(Offset.zero);
    Size s = new Size(offset.dx, offset.dy);
    print("s size (start) : ${s.toString()}");

    _path = _getPath(s);
    PathMetrics pms = _path.computeMetrics();
    PathMetric pm = pms.elementAt(0);
    double len = pm.length;

    _animation = Tween(begin: 0.0, end: len).animate(_controller)
      ..addListener(() {
        setState(() {
          _fraction = _animation.value;
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

class PathPainter extends CustomPainter {
  double _fraction;
  Path _path;
  List<Offset> _points = List<Offset>();

  PathPainter(this._path, this._fraction);

  Paint _paint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4.0;

  Paint _paint2 = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4.0;

  @override
  void paint(Canvas canvas, Size size) {

    if (_path == null) {
      return;
    }
    PathMetrics pms = _path.computeMetrics();
    PathMetric pm = pms.elementAt(0);
    double len = pm.length; //蓝线路径总长度
    double linelen = len / 20;//移动的红线长度
    //_fraction = len的长度。
    double tmpStart = _fraction;//移动更新值                     //20
    double end = (_fraction + linelen) > len ? len : (_fraction + linelen);
    if (end >= len) {
      tmpStart = len - linelen;
    }
    //通过fraction  + linelen 得到一个固定长度的list points (这里fraction虽然是变动的，但是tmpStart
    // 也是变动的，总体长度不变)
    for (; tmpStart < end; tmpStart++) {
      Tangent t = pm.getTangentForOffset(tmpStart);
      _points.add(t.position);
    }

    canvas.drawPath(_path, _paint);//画出蓝色路径
    canvas.drawPoints(PointMode.points, _points, _paint2);//画出红色移动线段
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}