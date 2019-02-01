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
            padding: EdgeInsets.all(0),
            child: new FlatButton(
              color: Colors.white,
              padding: EdgeInsets.all(12),
              shape: Border(top: BorderSide(color: Colors.grey[100]), bottom: BorderSide(color: Colors.grey[100])),
              child: Text('退出登录', style: TextStyle(color: Colors.red),),
              onPressed: (){
                User.isLogin().then((verify){
                  if(verify){
                    User.delAccountToken();
                    try{
                      UserEvent.eventBus.fire(new UserEvent());
                    }catch(e){}
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