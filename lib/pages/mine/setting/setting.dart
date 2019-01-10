import 'package:flutter/material.dart';
import '../../../common/user.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Setting extends StatefulWidget{
  State<StatefulWidget> createState() => new SettingState();
}

class SettingState extends State{
  @override
  Widget build(BuildContext context){
    Widget _body = new Container(
      child: new ListView(
        padding: EdgeInsets.only(top: 15),
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: new FlatButton(
              color: Colors.red,
              padding: EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              child: Text('退出登录', style: TextStyle(color: Colors.white),),
              onPressed: (){
                User.isLogin().then((verify){
                  if(verify){
                    User.delAccountToken();
                    UserEvent.eventBus.fire(new UserEvent());
                    Fluttertoast.showToast(msg: '已退出登录！', gravity: ToastGravity.CENTER).then((e){
                      Navigator.of(super.context).pop();
                    });
                  }else{
                    Fluttertoast.showToast(msg: '您尚未登录！', gravity: ToastGravity.CENTER);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('设置', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: BackButtonIcon(),
            onPressed: (){
              Navigator.pop(super.context);
            },
          ),
        ),
        body: _body,
      ),
    );
  }
}