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
          Text(title, style: TextStyle(height: 3, color: Colors.black54, fontSize: 16.0),)
        ],
      ),
    );
  }

  static Widget finished({title = '数据已加载完成'}){
    return new Center(
      child: Padding(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        child: Text(title, style: TextStyle(color: Colors.black54, fontSize: 16.0),),
      ),
    );
  }

  // 加载更多时显示的组件,给用户提示
  static Widget more({title = '拼命加载中...'}) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 12, right: 12), child: SpinKitFadingCube(color: Colors.green, size: 18,),),
            Text(title, style: TextStyle(fontSize: 16.0, color: Colors.black54),),
          ],
        ),
      ),
    );
  }
}