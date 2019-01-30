import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../config/api.dart';
import '../../common/http.dart';
import '../../common/user.dart';

class Login extends StatefulWidget{
  State<StatefulWidget> createState() => new LoginState();
}

class LoginState extends State<Login>{

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  @override void dispose() {
      super.dispose();
      print('Login销毁了状态');
    }

  @override
  Widget build(BuildContext context){

    void _postLogin(){
      Http.post(API.login, data: {'username': _usernameController.text, 'password': _passwordController.text}).then((result){
        if(result['code'] == 1){
          User.saveUserInfo(result['data']);
          try{
            UserEvent.eventBus.fire(new UserEvent());
          }catch(e){}
          Fluttertoast.showToast(msg: '登录成功', gravity: ToastGravity.CENTER).then((e){
            Navigator.of(super.context).pop();
          });
        }else{
          Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER);
          return;
        }
      });
    }

    Widget _body = new Container(
      child: new Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Stack(
            children: <Widget>[
              //头部背景
              new ClipPath(
                clipper: BottomClipper(),
                child: new Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    image: DecorationImage(
                      image: AssetImage('assets/images/bg_login.png',),
                      fit: BoxFit.cover,
                      alignment: AlignmentDirectional.topCenter,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: new Center(
                    child: Text('掌上易购，赚钱指间', style:TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,),
                  ),
                ),
              ),
              new AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),

          //表单列表
          new Padding(
            padding: EdgeInsets.only(top:45, left: 45, right: 45),
            child: new TextField(
              controller: _usernameController,
              decoration: new InputDecoration(
                hintText: "请输入用户名",
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
              ),
              cursorColor: Colors.green,
              obscureText: false,
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 25, left: 45, right: 45),
            child: new TextField(
              controller: _passwordController,
              decoration: new InputDecoration(
                hintText: "请输入用户密码",
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
              ),
              cursorColor: Colors.green,
              obscureText: true,
            ),
          ),
          new GestureDetector(
            child: new Padding(
              padding: EdgeInsets.only(top:25, left: 45, right: 45),
              child: Text('没有账号？马上注册', textAlign: TextAlign.end,),
            ),
            onTap: null,
          ),
          new Container(
            margin: EdgeInsets.only(top: 45),
            padding: EdgeInsets.only(left: 45, right: 45),
            child: new FlatButton(
              color: Colors.green,
              padding: EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              onPressed: () {
                _postLogin();
              },
              child: Text('马上登录', style: new TextStyle(color: Colors.white, fontSize: 16.0),)
            ),
          ),

          //第三方登录列表
          new Padding(
            padding: EdgeInsets.only(left: 45, right: 45, top: 60),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new GestureDetector(
                  child: new CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.black54,
                    child: Icon(FontAwesomeIcons.qq, color: Colors.white, size: 26,),
                  ),
                ),
                new GestureDetector(
                  child: new CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.black54,
                    child: Icon(FontAwesomeIcons.weixin, color: Colors.white, size: 26,),
                  ),
                ),
                new GestureDetector(
                  child: new CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.black54,
                    child: Icon(FontAwesomeIcons.facebookF, color: Colors.white, size: 26,),
                  ),
                ),
                new GestureDetector(
                  child: new CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.black54,
                    child: Icon(FontAwesomeIcons.twitter, color: Colors.white, size: 26,),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: _body,
      ),
    );
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 20);

    int doble = 12; int cdy = 40;
    for(var i = 1; i <= (doble / 2); i++){
      if(i.isOdd){
        path.quadraticBezierTo(size.width / doble * (2 * i - 1) - (size.width / (doble *3)), size.height - cdy, size.width / doble * 2 * i, size.height - 20);
      }else{
        path.quadraticBezierTo(size.width / doble * (2 * i - 1) + (size.width / (doble *3)), size.height, size.width / doble * 2 * i, size.height - 20);
      }
    }

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}