import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/api.dart';
import '../../common/http.dart';

class Register extends StatefulWidget{
  State<StatefulWidget> createState() => new RegisterState();
}

class RegisterState extends State<Register>{
  //数据控制字段
  int _step = 0;
  GlobalKey<FormState> _formFristKey = new GlobalKey<FormState>();
  Map <String, dynamic> _postFristData = new Map();
  GlobalKey<FormState> _formSecondKey = new GlobalKey<FormState>();
  Map <String, dynamic> _postSecondData = new Map();
  TextEditingController _mobileController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map _hits = new Map();
  Map _provinces = new Map();
  /// 倒计时的计时器。
  Timer _timer;

  @override
  void initState() {
    super.initState();
    Http.post(API.getProvinces).then((result){
      if(result['code'] == 1){
        setState(() {
          _provinces = result['data'];
        });
      }
    });
  }

  void _postStepFrist(){
    _formFristKey.currentState.save();
    _postFristData['step'] = 1;
    Http.post(API.register, data: _postFristData).then((result){
      if(result['code'] == 1){
        setState(() {
          _step = 1;
        });
      }else{
        Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER);
      }
    });
  }

  void _postStepSecond(){
    _formSecondKey.currentState.save();
    _postSecondData['step'] = 2;
    _postSecondData['mobile'] = _postFristData['mobile'];
    print(_postSecondData);
    Http.post(API.register, data: _postSecondData).then((result){
      print(result);
      if(result['code'] == 1){
        setState(() {
          _step = 2;
        });
      }else{
        Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER);
      }
    });
  }

  @override
  Widget build(BuildContext context){
    Widget _body = new Container(
      child: new Column(
        children: <Widget>[
          new Stack(
            children: <Widget>[
              //头部背景
              new ClipPath(
                clipper: BottomClipper(),
                child: new Container(
                  padding: EdgeInsets.only(top: 60, left: 15, right: 15),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    image: DecorationImage(
                      image: AssetImage('assets/images/bg_login.png',),
                      fit: BoxFit.cover,
                      alignment: AlignmentDirectional.topCenter,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('加入我们，从这里开始', style:TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,),
                      new Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(width: 32,height: 32, margin: EdgeInsets.all(8), decoration: BoxDecoration(color: _step == 0 ? Colors.green : Colors.white, borderRadius: BorderRadius.all(Radius.circular(80))), child: Center(child: Text('1', style: TextStyle(color: _step == 0 ? Colors.white : Colors.green, fontSize: 18),),),),
                                new Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Text('第一步', style: TextStyle(color: Colors.white),),
                                )
                              ],
                            ),
                            Expanded(flex:1, child: new Divider(color: Colors.white,),),
                            Row(
                              children: <Widget>[
                                Container(width: 32,height: 32, margin: EdgeInsets.all(8), decoration: BoxDecoration(color: _step == 1 ? Colors.green : Colors.white, borderRadius: BorderRadius.all(Radius.circular(80))), child: Center(child: Text('2', style: TextStyle(color: _step == 1 ? Colors.white : Colors.green, fontSize: 18),),),),
                                new Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Text('第二步', style: TextStyle(color: Colors.white),),
                                )
                              ],
                            ),
                            Expanded(flex:1, child: new Divider(color: Colors.white,),),
                            Row(
                              children: <Widget>[
                                Container(width: 32,height: 32, margin: EdgeInsets.all(8), decoration: BoxDecoration(color: _step == 2 ? Colors.green : Colors.white, borderRadius: BorderRadius.all(Radius.circular(80))), child: Center(child: Text('3', style: TextStyle(color: _step == 2 ? Colors.white : Colors.green, fontSize: 18),),),),
                                new Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Text('完成', style: TextStyle(color: Colors.white),),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              new AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: BackButtonIcon(),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          Expanded(
            flex: 1,
            child: new IndexedStack(
              index: _step,
              children: <Widget>[
                //第一步内容
                new Form(
                  key: _formFristKey,
                  child: new ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0),
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.only(top:15, left: 45, right: 45),
                        child: new TextFormField(
                          onSaved: (val)=> this._postFristData['qq'] = val,
                          decoration: new InputDecoration(
                            hintText: "请输入QQ号码",
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                          ),
                          cursorColor: Colors.green,
                          obscureText: false,
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(top:20, left: 45, right: 45),
                        child: new TextFormField(
                          onSaved: (val)=> this._postFristData['password'] = val,
                          decoration: new InputDecoration(
                            hintText: "请设置8-16位的登录密码",
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                          ),
                          cursorColor: Colors.green,
                          obscureText: true,
                          maxLength: 16,
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(top:0, left: 45, right: 45),
                        child: new TextFormField(
                          onSaved: (val)=> this._postFristData['password_confirm'] = val,
                          decoration: new InputDecoration(
                            hintText: "请确认输入的登录密码",
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                          ),
                          cursorColor: Colors.green,
                          obscureText: true,
                          maxLength: 16,
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(top:0, left: 45, right: 45),
                        child: new TextFormField(
                          onSaved: (val)=> this._postFristData['mobile'] = val,
                          controller: _mobileController,
                          decoration: new InputDecoration(
                            hintText: "请输入您的手机号码",
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                          ),
                          cursorColor: Colors.green,
                        ),
                      ),
                      new Container(
                        margin: EdgeInsets.only(top:20, left: 45, right: 45),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.black54))
                        ),
                        child: new Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: new TextFormField(
                                onSaved: (val)=> this._postFristData['code'] = val,
                                decoration: new InputDecoration(
                                  hintText: "请输入短信验证码",
                                  focusedBorder: InputBorder.none,
                                  border: InputBorder.none
                                ),
                                cursorColor: Colors.green,
                              ),
                            ),
                            FlatButton(
                              child: Text(_hits['code'] ?? '获取验证码', style: TextStyle(color: _hits['code'] == null ? Colors.green: Colors.grey),),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: _hits['code'] == null ? Colors.green : Colors.grey),
                              ),
                              onPressed: (){
                                if(_mobileController.text == ''){
                                  Fluttertoast.showToast(msg: '请先输入手机号码', gravity: ToastGravity.CENTER);
                                  return;
                                }
                                if(_hits['code'] != null){
                                  return;
                                }
                                Http.post(API.sendMessage, data: {'mobile': _mobileController.text}).then((result){
                                  if(result['code'] == 1){
                                    setState(() {
                                      _hits['code'] = '60s后重发';
                                    });
                                    _timer = Timer.periodic(
                                      Duration(seconds: 1),
                                      (timer){
                                        if(timer.tick >= 60){
                                          _timer.cancel();
                                          setState(() {
                                            _hits['code'] = null;
                                          });
                                          return;
                                        }
                                        print(timer.tick);
                                        setState(() {
                                          _hits['code'] = (60 - timer.tick).toString() + 's后重发';
                                        });
                                      }
                                    );
                                  }
                                  Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(top:20, left: 45, right: 45),
                        child: new TextFormField(
                          onSaved: (val)=> this._postFristData['pmobile'] = val,
                          decoration: new InputDecoration(
                            hintText: "请输入邀请人手机号码",
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                          ),
                          cursorColor: Colors.green,
                        ),
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
                            _postStepFrist();
                          },
                          child: Text('下一步', style: new TextStyle(color: Colors.white, fontSize: 16.0),)
                        ),
                      ),
                    ],
                  ),
                ),

                //第二步内容
                new Form(
                  key: _formSecondKey,
                  child: new ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0),
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.only(top:15, left: 45, right: 45),
                        child: new TextFormField(
                          onSaved: (val)=> this._postSecondData['truename'] = val,
                          decoration: new InputDecoration(
                            hintText: "请输入真实姓名",
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                          ),
                          cursorColor: Colors.green,
                          obscureText: false,
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(top:15, left: 45, right: 45),
                        child: new TextFormField(
                          onSaved: (val)=> this._postSecondData['idcard'] = val,
                          decoration: new InputDecoration(
                            hintText: "请输入您的身份证号码",
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                          ),
                          cursorColor: Colors.green,
                          obscureText: false,
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(top:20, left: 45, right: 45),
                        child: new TextFormField(
                          onSaved: (val)=> this._postSecondData['tbname'] = val,
                          decoration: new InputDecoration(
                            hintText: "请输入淘宝会员名称",
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                          ),
                          cursorColor: Colors.green,
                        ),
                      ),
                      new GestureDetector(
                        child: new Container(
                          margin: EdgeInsets.only(top:20, left: 45, right: 45),
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.black54))
                          ),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text(_hits['province'] != null ? _hits['province'] : '请选择注册区域', style: TextStyle(color: _hits['province'] != null ? Colors.black87 : Colors.black54, fontSize: 16),),
                              ),
                              Icon(Icons.arrow_drop_down, color: Colors.black54,),
                            ],
                          ),
                        ),
                        onTap: (){
                          List _pickerdata = _provinces.values.toList();
                          List _pickerkey = _provinces.keys.toList();
                          new Picker(
                            adapter: PickerDataAdapter<String>(pickerdata: _pickerdata),
                            title: Text('注册区域', style: TextStyle(fontSize: 16, color: Colors.grey),),
                            changeToFirst: true,
                            textAlign: TextAlign.center,
                            selecteds: [_postSecondData['province'] !=null ? _pickerkey.indexOf(_postSecondData['province']) : 0],
                            columnPadding: const EdgeInsets.all(8.0),
                            cancelText: '取消',
                            cancelTextStyle: TextStyle(color: Colors.green, fontSize: 16,),
                            confirmText: '完成',
                            confirmTextStyle: TextStyle(color: Colors.green, fontSize: 16,),
                            onConfirm: (Picker picker, List value) {
                              setState(() {
                                _hits['province'] = '已选择: ' + picker.getSelectedValues()[0];
                                _postSecondData['province'] = _pickerkey[value[0]];
                              });
                              print(_pickerkey[value[0]]);
                            }
                          ).show(_scaffoldKey.currentState);
                        },
                      ),
                      new Padding(
                        padding: EdgeInsets.only(top:15, left: 45, right: 45),
                        child: new TextFormField(
                          onSaved: (val)=> this._postSecondData['ecname'] = val,
                          decoration: new InputDecoration(
                            hintText: "请输入紧急联系人",
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                          ),
                          cursorColor: Colors.green,
                          obscureText: false,
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(top:15, left: 45, right: 45),
                        child: new TextFormField(
                          onSaved: (val)=> this._postSecondData['ecphone'] = val,
                          decoration: new InputDecoration(
                            hintText: "请输入紧急联系人手机号码",
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                          ),
                          cursorColor: Colors.green,
                          obscureText: false,
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text('：您的身份信息仅用于实名认证，不做其他任何用途', style: TextStyle(height: 1.5, color: Colors.red), textAlign: TextAlign.center,),
                      ),
                      new Container(
                        margin: EdgeInsets.only(top: 35),
                        padding: EdgeInsets.only(left: 45, right: 45),
                        child: new FlatButton(
                          color: Colors.green,
                          padding: EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                          ),
                          onPressed: () {
                            _postStepSecond();
                          },
                          child: Text('提交注册', style: new TextStyle(color: Colors.white, fontSize: 16.0),)
                        ),
                      ),
                    ],
                  ),
                ),

                // 第三步（完成）内容
                new ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Icon(Icons.check, color: Colors.green, size: 85,),
                    Text('恭喜您！成功加入我们！', style: TextStyle(color: Colors.green, fontSize: 20, height: 1.5), textAlign: TextAlign.center,),
                    Text('请勿重复注册，耐心等待管理员审核！', style: TextStyle(color: Colors.red, height: 1.5), textAlign: TextAlign.center,),
                  ],
                )
              ],
            ),
          )
        ],
      )
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
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
    path.lineTo(0.0, size.height - 30);
    path.lineTo(size.width, size.height);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}