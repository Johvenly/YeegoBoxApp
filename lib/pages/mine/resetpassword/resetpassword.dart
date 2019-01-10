import 'package:flutter/material.dart';
import '../../../config/api.dart';
import '../../../common/http.dart';
import '../../../common/user.dart';
import '../../auth/login.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPassword extends StatefulWidget{
  State<StatefulWidget> createState() => new ResetPasswordState();
}

class ResetPasswordState extends State{
  //数据控制字段
  String _token;
  bool _status = false;
  TextEditingController _oldPasswordController = new TextEditingController();
  TextEditingController _newPasswordController = new TextEditingController();
  TextEditingController _confirmPasswordController = new TextEditingController();

  @override
    void initState() {
      super.initState();
      initData().then((_){
        setState((){
          _status = true;
        });
      });
    }

  //初始化界面数据
  Future<dynamic> initData() async{
    User.getAccountToken().then((result){
      setState(() {
        _token = result;
      });
    });
  }

  @override
  Widget build(BuildContext context){
    void _postSubmit(){
      Http.post(API.updatePassword, data: {'account_token': _token, 'bepassword': _oldPasswordController.text, 'password': _newPasswordController.text, 'password_confirm': _confirmPasswordController.text}).then((result){
        if(result['code'] == 1){
          Fluttertoast.showToast(msg: '修改成功', gravity: ToastGravity.CENTER).then((e){
            User.delAccountToken();
            UserEvent.eventBus.fire(new UserEvent());
            Navigator.pushAndRemoveUntil(context,
                new MaterialPageRoute(
              builder: (BuildContext context) => new Login(), fullscreenDialog: true,
            ), ModalRoute.withName('/'));
          });
        }else{
          Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER);
          return;
        }
      });
    }

    Widget _body = new Container(
      child: new ListView(
        padding: EdgeInsets.only(top: 15),
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(top: 4, bottom: 4),
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: new TextField(
              controller: _oldPasswordController,
              decoration: InputDecoration(
                fillColor: Colors.black,
                contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                hintText: '输入您的原密码',
                hintStyle: TextStyle(color: Colors.grey[300]),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              cursorColor: Colors.green,
            ),
          ),
          new Container(
            margin: EdgeInsets.only(top: 4, bottom: 4),
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: new TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                fillColor: Colors.black,
                contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                hintText: '输入您的新密码',
                hintStyle: TextStyle(color: Colors.grey[300]),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              cursorColor: Colors.green,
              obscureText: true,
            ),
          ),
          new Container(
            margin: EdgeInsets.only(top: 4, bottom: 4),
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: new TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                fillColor: Colors.black,
                contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                hintText: '确认您的新密码',
                hintStyle: TextStyle(color: Colors.grey[300]),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              cursorColor: Colors.green,
              obscureText: true,
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top:25, left: 25, right: 25),
            child: new FlatButton(
              color: _status ? Colors.green : Colors.greenAccent,
              padding: EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              child: Text('提 交', style: TextStyle(color: Colors.white),),
              onPressed: (){
                if(_status){
                  _postSubmit();
                }
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
          title: Text('修改密码', style: TextStyle(color: Colors.white)),
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