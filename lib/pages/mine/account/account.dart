import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../config/api.dart';
import '../../../common/http.dart';
import '../../../common/user.dart';
import '../../../common/loading.dart';
import 'avatar.dart';

class Account extends StatefulWidget{
  State<StatefulWidget> createState() => new AccountState();
}

class AccountState extends State with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  //数据控制字段
  bool _loaded = false;
  Map _userInfo;

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
    await User.getAccountToken().then((token) async{
      // 认证并初始化会员信息
      await Http.post(API.initUser, data: {'account_token': token}).then((result){
        if(result['code'] == 1){
          setState(() {
            _userInfo = result['data'];
          });
        }
      });
    });
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
                          new CircleAvatar(backgroundColor: Colors.green ,backgroundImage: (_userInfo[User.FIELD_AVATAR] != '' && _userInfo[User.FIELD_AVATAR] != null) ? new CachedNetworkImageProvider(API.host + _userInfo[User.FIELD_AVATAR])
                           : new AssetImage('assets/images/avatar.jpg'), radius: 35),
                          Icon(Icons.chevron_right, color: Colors.grey,),
                        ],
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                ),
                onTap: (){
                  Navigator.of(super.context).push(
                        new MaterialPageRoute(
                            builder: (BuildContext context) => new UserAvatar()),
                      ).then((_){
                        if(_ != null){
                          setState((){
                            _userInfo[User.FIELD_AVATAR] = _;
                          });
                          User.saveFieldForString(User.FIELD_AVATAR, _);
                        }
                      });
                }
              ),
              new Divider(),
              new GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: new Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8, right: 8),
                  child: new Row(
                    children: <Widget>[
                      Text('用户名', style: TextStyle(fontSize: 16),),
                      _userInfo['username'] == null ? Row(
                        children: <Widget>[
                          Text('未设置', style: TextStyle(color: Colors.grey),),
                          Icon(Icons.chevron_right, color: Colors.grey,),
                        ],
                      ) : Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Text(_userInfo['username'].toString()),
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
                  padding: EdgeInsets.only(top: 8, bottom: 8, right: 20),
                  child: new Row(
                    children: <Widget>[
                      Text('手机号', style: TextStyle(fontSize: 16),),
                      Text(_userInfo[User.FIELD_MOBILE]),
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
        new Container(
          padding: EdgeInsets.only(top:8, bottom:8, left: 15),
          margin: EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey[200]), bottom: BorderSide(color: Colors.grey[200]))
          ),
          child: new Column(
            children: <Widget>[
              new GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: new Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8, right: 20),
                  child: new Row(
                    children: <Widget>[
                      Text('QQ', style: TextStyle(fontSize: 16),),
                      Text(_userInfo['qq'].toString()),
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
                  padding: EdgeInsets.only(top: 8, bottom: 8, right: 20),
                  child: new Row(
                    children: <Widget>[
                      Text('生日', style: TextStyle(fontSize: 16),),
                      Text(_userInfo['birthday'].toString()),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                ),
                onTap: (){
                  
                }
              ),
            ]
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