

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custome_screen.dart';

class CustomBezierWidget2 extends StatefulWidget {
  final double progress;

  CustomBezierWidget2(this.progress);

  @override
  _CustomBezierWidget2State createState() => _CustomBezierWidget2State();
}

class _CustomBezierWidget2State extends State<CustomBezierWidget2>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  Animation<double> _animationTranslate;

  double _moveX; //移动的X,此处变化一个波长
  double _r; //半径
  double waveLength; //波长

  double _waveCount = 2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _r = Screen.screenWidthDp / 3;
    waveLength = 2 * _r / _waveCount;
    _animationController =
    new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationTranslate =
    Tween<double>(begin: 0, end: waveLength).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animationController.repeat();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    _animationController.stop();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BezierPainter2(
          progress: this.widget.progress,
          waveHeight: 15,
          moveX: _animationTranslate.value,
          r: _r,
          waveLength: waveLength),
    );
  }
}

class BezierPainter2 extends CustomPainter {
  final double progress; //进度
  final double waveHeight; //波浪高
  final double moveX; //移动的X,此处变化一个波长
  final double r; //半径
  final double waveLength; //一个波浪的长度
  final waveCount = 2; //波浪个数

  double _progressY; //移动中Y的坐标

  Paint _pointPaint; //点画笔
  Paint _pathPaint; //线画笔
  Paint _whitePaint; //空白画笔

  Path _path = Path(); //路径

  Offset centerOffset; //圆心

  BezierPainter2(
      {this.progress, this.waveHeight, this.moveX, this.r, this.waveLength}) {
    _pointPaint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 4
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;
    _pathPaint = Paint()
      ..color = Colors.deepOrange
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..strokeWidth = 1;
    _whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = 1;
    centerOffset = Offset(Screen.screenWidthDp / 2, Screen.screenHeightDp / 2);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    //centerOffset圆心
    _path.addArc(Rect.fromCircle(center: centerOffset, radius: r), 0, 360);
    canvas.clipPath(_path); //把画布裁剪成一个圆形,这样怎么画都是圆。
    canvas.drawCircle(centerOffset, r, _pointPaint); //画圆
    _path.reset(); //重置路径
    //this.progress的范围是0-100。
    _progressY = centerOffset.dy + (r - r / 50 * this.progress); //算出Y点的坐标
    //将画笔移动至屏幕外
    _path.moveTo(-waveLength + moveX, _progressY);
    //这里的波峰波谷稍微多点,所以waveCount*2
    for (int i = 0; i < waveCount * 2; i++) {
      canvas.save();
      canvas.restore();
      //绘制波谷,同上
      _path.quadraticBezierTo(
          -waveLength / 4 * 3 + (waveLength * i) + moveX,
          _progressY + waveHeight,
          -waveLength / 2 + (waveLength * i) + moveX,
          _progressY);
      //绘制波峰,同上
      _path.quadraticBezierTo(-waveLength / 4 + (waveLength * i) + moveX,
          _progressY - waveHeight, 0 + waveLength * i + moveX, _progressY);
    }
    print("_moveX=${moveX.toString()}");
    //封闭圆
    _path.moveTo(centerOffset.dx + r, _progressY);
    _path.lineTo(centerOffset.dx + r, centerOffset.dy + r);
    _path.lineTo(centerOffset.dx - r, centerOffset.dy + r);
    _path.lineTo(centerOffset.dx - r, _progressY);
    _path.close();
    canvas.drawPath(_path, _pathPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}


