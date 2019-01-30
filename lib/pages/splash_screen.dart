import 'package:flutter/material.dart';
import 'dart:async';
import 'index.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  int _seconds = 3;
  Timer _time;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _time = Timer.periodic(Duration(seconds: 1),(timer) {
          if(_seconds <= 0){
            timer.cancel();
            Navigator.pushReplacement( context, MaterialPageRoute(builder: (BuildContext context) => new Index()));
          }else{
            setState(() {
              _seconds --;
            });
          }
        });
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.blue,
          child: new FadeTransition(
            opacity: _animation,
            child: new Image.asset(
              'assets/images/splash.jpg',
              scale: 2.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
        new Positioned(
          width: 80,
          height: 30,
          top: 45,
          right: 25,
          child: new GestureDetector(
            child: Container(
              alignment: AlignmentDirectional.center,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: Text('跳过 ' + _seconds.toString() + 's', style: TextStyle(color: Colors.white, fontSize: 14, decoration: TextDecoration.none, fontWeight: FontWeight.normal)),
            ),
            onTap: (){
              _time.cancel();
              Navigator.pushReplacement( context, MaterialPageRoute(builder: (BuildContext context) => new Index()));
            },
          ),
        ),
      ],
    );
  }
}
