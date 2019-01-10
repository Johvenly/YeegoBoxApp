import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class LoadingView extends StatelessWidget{
  final String title;
  LoadingView({Key key, this.title = '数据拼命加载中...'});

  @override
  Widget build(BuildContext context){
    return new Container(
      color: Colors.white,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitFadingCube(color: Colors.green, size: 38,),
          Text(title, style: TextStyle(height: 3, color: Colors.black54),)
        ],
      ),
    );
  }

  @override
  static Widget finished({title = '数据已加载完成'}){
    return new Center(
      child: Text(title, style: TextStyle(color: Colors.black54),),
    );
  }
}