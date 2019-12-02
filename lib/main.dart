import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_wave_ball/animate_widget.dart';
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

  GlobalKey floatBtnKey = GlobalKey();
  FloatingActionButton floatButton ;




  @override
  Widget build(BuildContext context) {

    floatButton = FloatingActionButton(
      key: floatBtnKey,
      tooltip: 'Increment',
      child: Icon(Icons.add),
    );

    
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
        body:ListPage(floatBtnKey),
        //body: WidgetCircleProgressWidget(),
//      body:Center(
//        child: CustomBezierWidget1(),
//      ),
    floatingActionButton: floatButton,

    );
  }
}


class ListPage extends StatefulWidget{

  GlobalKey floatKey = GlobalKey();

  ListPage(this.floatKey);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ListPageState();
  }

}

class ListPageState extends State<ListPage> with SingleTickerProviderStateMixin {

  AnimationController _animationController;
  Animation _animation;

  Size floatSize;
  Offset floatOffset;
  GlobalKey rootKey = GlobalKey();

  double fraction = 0.0;
  int _seconds = 6;

  Offset itemOffset;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: _seconds));
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_){
      floatOffset = new Offset(300, 600);
//      RenderBox renderBox = widget.floatKey.currentContext.findRenderObject();
//      floatOffset = renderBox.localToGlobal(Offset.zero,ancestor: rootKey
//          .currentContext.findRenderObject());
//      floatSize = renderBox.size;
//
//      print("float offset   ${floatOffset.toString()}");
//      print("float size    ${floatSize.toString()}");
    });


    return Container(
      key: rootKey,
      color: Colors.grey,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: <Widget>[
          ListView(
            children: List.generate(40, (index){
              return itemWidget(index);
            }).toList(),
          ),

          Positioned(
            left: circleLeft,
            top: circleTop,
            child: Icon(Icons.access_alarms,color: Colors.red,),
          ),

        ],
      ),
    );
  }

  double circleLeft = 0.0;
  double circleTop = 0.0;


  CustomPaint customPaint;

  Widget itemWidget(index){

    GlobalKey itemKey = GlobalKey();
    Text text = Text("item $index",key: itemKey,style: TextStyle(fontSize:
    25),);


    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          onPanDown: (DragDownDetails details){
//            clickPx = details.globalPosition.dx;
//            clickPy = details.globalPosition.dy;
          },
          onTap: (){
            RenderBox textRB = itemKey.currentContext.findRenderObject();
            itemOffset = textRB.localToGlobal(Offset.zero,ancestor: rootKey
                .currentContext.findRenderObject());

            print("item offset    ${itemOffset.toString()}");

            Path path = getPath(Size(floatOffset.dx,floatOffset.dy));

            PathMetrics pms = path.computeMetrics();
            PathMetric pm = pms.elementAt(0);
            double len = pm.length;

            //generateAnimation(len,pm);
//            customPaint = CustomPaint(
//              painter: PathPainter(path, fraction),
//            );

            setState(() {
//              isOffstage = ! isOffstage;
              OverlayEntry o = OverlayEntry(builder: (ctx){
                return AnimateWidgetCustom(len,pm);
              });
              Overlay.of(rootKey.currentContext).insert(o);
            });
            //startAnimation(len,pm);
          },
          child: text,
        ),

        RaisedButton(
          onPressed: (){},
          color: Colors.blue,
          child: Text("item $index"),
        ),
      ],
    );
  }

  generateAnimation(double len,PathMetric pm){
    double pCircleTop = 0.0;
    double pCircleLeft = 0.0;


    Animation animation = Tween(begin: 0.0,end: len).animate(_animationController);
        animation.addListener((){
          print("animation controller value ${animation.value}");
          double tempStart = animation.value;
          Tangent t = pm.getTangentForOffset(tempStart);
          setState(() {
            pCircleTop = t.position.dy;
            pCircleLeft = t.position.dx;
          });

        });
        animation.addStatusListener((status){
          if(status == AnimationStatus.completed){
            _animationController.stop();
            _animationController.reset();
          }
        });
    Positioned p = Positioned(
      left: pCircleLeft,
      top: pCircleTop,
      child: Icon(Icons.access_alarms,color: Colors.red,),
    );

    setState(() {
      OverlayEntry o = OverlayEntry(
          builder: (ctx){
            return p;
          }
      );

      Overlay.of(rootKey.currentContext).insert(o);
    });
    _animationController.forward();
  }
//  startAnimation(double len,PathMetric pm) {
////    RenderBox renderBox = _canvasKey.currentContext.findRenderObject();
////    Size s = renderBox.size;
//
//
//
//    _animation = Tween(begin: 0.0, end: len).animate(_animationController)
//      ..addListener(() {
//        //print("animation   start  ${_animation.value}");
//        double tmpStart = _animation.value;
//        double end = _animation.value > len ? len : _animation.value;
//        Tangent t = pm.getTangentForOffset(tmpStart);
//        setState(() {
//          circleLeft = t.position.dx;
//          circleTop = t.position.dy;
//          //fraction = _animation.value;
//        });
//      })
//      ..addStatusListener((status){
//        if (status == AnimationStatus.completed) {
//          _animationController.stop();
//        }
//      });
//
//    _animationController.forward();
//
//  }

  Path getPath(Size size) {
//    RenderBox renderBox = _canvasKey.currentContext.findRenderObject();
//    Offset offset = renderBox.localToGlobal(Offset.zero);
    Offset offset = itemOffset;
    print("start offset :${offset.toString()}");
    Path path = Path();
    path.moveTo(offset.dx,offset.dy);
    path.quadraticBezierTo(
        size.width / 2, offset.dy, size.width, size.height);
    //path.cubicTo(size.width / 4, 3 * size.height / 4, 3 * size.width / 4, size.height / 4, size.width, size.height);

    return path;
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



























