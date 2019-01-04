import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../public/badge.dart';
import '../auth/login.dart';

class Mine extends StatefulWidget{
  State<StatefulWidget> createState() => new MineState();
}

class MineState extends State{
  final bool _isLogin = false;
  @override
  Widget build(BuildContext context){
    Widget _body = new Container(
      child: new ListView(
        children: <Widget>[
          /**Avatar Box */
          new Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: ClipPath(
              clipper: BottomClipper(),
              child: new Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
                //头像/登录块
                child: new GestureDetector(
                  child: new Column(
                    children: <Widget>[
                      new CircleAvatar(backgroundImage: new AssetImage('assets/images/avatar.jpg'), radius: 50),
                      new Container(
                        child: Text('Johwen Chou', style: TextStyle(color: Colors.white, fontSize: 16),),
                        margin: EdgeInsets.only(top: 8),
                      )
                    ],
                  ),
                  onTap: (){
                    Navigator.of(super.context).push(
                      new MaterialPageRoute(
                          builder: (BuildContext context) => new Login()),
                    );
                  },
                ),
              ),
            ),
          ),
          /**Gold Box */
          new Padding(
            padding: EdgeInsets.only(bottom: 25),
            child: new Row(
              children: <Widget>[
                new GestureDetector(
                  child: new Column(
                    children: <Widget>[
                      Text('2', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      Text('普通奖励', style: TextStyle(color: Colors.green[300], height: 1.8),),
                    ],
                  ),
                ),
                new GestureDetector(
                  child: new Column(
                    children: <Widget>[
                      Text('26', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      Text('推广奖励', style: TextStyle(color: Colors.green[300], height: 1.8),),
                    ],
                  ),
                ),
                new GestureDetector(
                  child: new Column(
                    children: <Widget>[
                      Text('18', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      Text('冻结学分', style: TextStyle(color: Colors.green[300], height: 1.8),),
                    ],
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
          ),
          new ClipPath(
            clipper: TopClipper(),
            child: new Container(
              padding: EdgeInsets.only(top: 40, bottom: 30),
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new SizedBox(
                        width: 80,
                        height: 25,
                        child: new FlatButton(
                          child: Text('绑定账号', style: TextStyle(color: Colors.white, fontSize: 12),),
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          onPressed: (){},
                        ),
                      ),
                      Text('淘宝号', style:TextStyle(height:1.5, color: Colors.black54))
                    ],
                  ),
                  new Column(
                    children: <Widget>[
                      new SizedBox(
                        width: 80,
                        height: 25,
                        child: new FlatButton(
                          child: Text('绑定账号', style: TextStyle(color: Colors.white, fontSize: 12),),
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          onPressed: (){},
                        ),
                      ),
                      Text('京东号', style:TextStyle(height:1.5, color: Colors.black54))
                    ],
                  ),
                  new Column(
                    children: <Widget>[
                      new SizedBox(
                        width: 80,
                        height: 25,
                        child: new FlatButton(
                          child: Text('绑定账号', style: TextStyle(color: Colors.white, fontSize: 12),),
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          onPressed: (){},
                        ),
                      ),
                      Text('拼多多号', style:TextStyle(height:1.5, color: Colors.black54))
                    ],
                  ),
                ],
              ),
            ),
          ),
          new Container(
            child: new Column(
              children: <Widget>[
                new Container(
                  child: new Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.payment, size: 24, color: Colors.red,),
                          Text(' 收款银行卡', style: TextStyle(fontSize: 16),)
                        ],
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey,)
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  padding: EdgeInsets.only(top: 15, bottom: 15, left: 5, right: 8),
                ),
                new Divider(indent: 5, height: 0, color: Colors.grey[200]),
                new Container(
                  child: new Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(FontAwesomeIcons.idCard, size: 18, color: Colors.black45,),
                          Text('  真实性验证', style: TextStyle(fontSize: 16),)
                        ],
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey,)
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  padding: EdgeInsets.only(top: 15, bottom: 15, left: 5, right: 8),
                ),
                new Divider(indent: 5, height: 0, color: Colors.grey[200]),
                new Container(
                  child: new Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(FontAwesomeIcons.key, size: 18, color: Colors.black45,),
                          Text('  修改密码', style: TextStyle(fontSize: 16),)
                        ],
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey,)
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  padding: EdgeInsets.only(top: 15, bottom: 15, left: 5, right: 8),
                ),
                new Divider(indent: 5, height: 0, color: Colors.grey[200]),
                new Container(
                  child: new Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(FontAwesomeIcons.resolving, size: 18, color: Colors.black45,),
                          Text('  检查更新', style: TextStyle(fontSize: 16),)
                        ],
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey,)
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  padding: EdgeInsets.only(top: 15, bottom: 15, left: 5, right: 8),
                ),
                new Divider(indent: 5, height: 0, color: Colors.grey[200]),
                new Container(
                  child: new Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(FontAwesomeIcons.cog, size: 18, color: Colors.black45,),
                          Text('  设置', style: TextStyle(fontSize: 16),)
                        ],
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey,)
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  padding: EdgeInsets.only(top: 15, bottom: 15, left: 5, right: 8),
                ),
                new Divider(indent: 5, height: 0, color: Colors.grey[200]),
              ],
            ),
            padding: EdgeInsets.only(left: 12),
          )
        ],
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.message, color: Colors.white,),
              tooltip: '消息',
              onPressed: null,
            ),
            IconButton(
              icon: Icon(Icons.settings, color: Colors.white,),
              tooltip: '设置',
              onPressed: null,
            )
          ],
        ),
        body: _body,
      ),
    );
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 30);
    var firstControlPoint = Offset(size.width / 5, size.height);
    var firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 5), size.height);
    var secondPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, 6);

    int doble = 80;
    for(var i = 1; i <= (doble / 2); i++){
      path.lineTo(size.width / doble * ((4 * (i - 1)) + 1), 6);
      path.quadraticBezierTo(size.width / doble * (2 * (2 * i - 1)), 0, size.width / doble * (4 * i - 1), 6);
      path.lineTo(size.width / doble * (4 * i), 6);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}