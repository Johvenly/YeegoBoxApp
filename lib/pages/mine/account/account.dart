import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../config/api.dart';
import '../../../common/http.dart';
import '../../../common/user.dart';
import '../../../common/loading.dart';

class Account extends StatefulWidget{
  State<StatefulWidget> createState() => new AccountState();
}

class AccountState extends State with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  //数据控制字段
  bool _loaded = false;
  List list = new List();                               //列表数据

  @override
    void initState() {
      super.initState();
      initData().then((_){
        setState((){
          _loaded = true;
        });
      });
    }

  Future<dynamic> initData() async {

  }

  @override
  Widget build(BuildContext context){
    Widget _body = !_loaded ? new LoadingView() : new ListView(
      children: <Widget>[
        new Container(
          padding: EdgeInsets.only(top:8, bottom:8, left: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey[200]))
          ),
          child: new Column(
            children: <Widget>[
              new GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: new Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8, right: 8),
                  child: new Row(
                    children: <Widget>[
                      Text('头像', style: TextStyle(fontSize: 16),),
                      Row(
                        children: <Widget>[
                          new CircleAvatar(backgroundImage: new AssetImage('assets/images/avatar.jpg'), radius: 35,),
                          Icon(Icons.chevron_right, color: Colors.grey,),
                        ],
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                ),
                onTap: (){
                  
                }
              ),
              new Divider(),
              new GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: new Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8, right: 8),
                  child: new Row(
                    children: <Widget>[
                      Text('手机号', style: TextStyle(fontSize: 16),),
                      Row(
                        children: <Widget>[
                          Text('15820331917'),
                          Icon(Icons.chevron_right, color: Colors.grey,),
                        ],
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                ),
                onTap: (){
                  
                }
              ),
            ],
          ),
        ),
      ],
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('账户设置', style: TextStyle(color: Colors.white)),
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