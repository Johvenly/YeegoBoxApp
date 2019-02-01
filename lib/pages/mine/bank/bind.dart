import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../config/api.dart';
import '../../../common/http.dart';
import '../../../common/user.dart';
import '../../../common/loading.dart';

class BankBind extends StatefulWidget{
  State<StatefulWidget> createState() => new BankBindState();
}

class BankBindState extends State{
  //数据控制字段
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Map <String, dynamic>_data = {'memtruename': '', 'membankcard': '', 'membankname': '', 'membankaddress': ''};
  bool _loaded = false;
  String _token;
  String _truename;

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
    await User.isLogin().then((_) async{
      if(_){
        await User.getUserInfo().then((result) async{
          setState(() {
            _token = result[User.FIELD_TOKEN];
            _truename = result[User.FIELD_TRUENAME];
          });
        });
      }
    });
  }

  void _onSubmit() {
    final form = _formKey.currentState;
    form.save();
    _data['account_token'] = _token;
    Http.post(API.bindBank, data: _data).then((result){
      if(result['code'] == 1){
        Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER).then((_){
          Navigator.pop(context, result['data']);
        });
        return true;
      }else{
        Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER);
        return false;
      }
    });
  }

  @override
  Widget build(BuildContext context){
    Widget _body = !_loaded ? new LoadingView() : new ListView(
      padding: EdgeInsets.only(top: 15,),
      children: <Widget>[
        new Form(
            key: _formKey,
            child: new Column(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(top: 4, bottom: 4),
                padding: EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text('持卡人', style: TextStyle(color: Colors.green), textAlign: TextAlign.right,),
                    ),
                    Expanded(
                      flex: 4,
                      child: new TextFormField(
                        onSaved: (val)=> this._data['memtruename'] = val,
                        decoration: InputDecoration(
                          fillColor: Colors.black,
                          contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                          hintText: '请输入持卡人姓名',
                          hintStyle: TextStyle(color: Colors.grey[300]),
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        enabled: false,
                        initialValue: _truename,
                        cursorColor: Colors.green,
                      ),
                    ),
                  ],
                )
              ),
              new Container(
                margin: EdgeInsets.only(top: 4, bottom: 4),
                padding: EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text('银行卡号', style: TextStyle(color: Colors.green), textAlign: TextAlign.right,),
                    ),
                    Expanded(
                      flex: 4,
                      child: new TextFormField(
                        onSaved: (val)=> this._data['membankcard'] = val,
                        decoration: InputDecoration(
                          fillColor: Colors.black,
                          contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                          hintText: '请输入银行卡号',
                          hintStyle: TextStyle(color: Colors.grey[300]),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        cursorColor: Colors.green,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                )
              ),
              new Container(
                margin: EdgeInsets.only(top: 4, bottom: 4),
                padding: EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text('开户行', style: TextStyle(color: Colors.green), textAlign: TextAlign.right,),
                    ),
                    Expanded(
                      flex: 4,
                      child: new TextFormField(
                        onSaved: (val)=> this._data['membankname'] = val,
                        decoration: InputDecoration(
                          fillColor: Colors.black,
                          contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                          hintText: '请输入开户行名称',
                          hintStyle: TextStyle(color: Colors.grey[300]),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        cursorColor: Colors.green,
                      ),
                    ),
                  ],
                )
              ),
              new Container(
                margin: EdgeInsets.only(top: 4, bottom: 4),
                padding: EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text('支行', style: TextStyle(color: Colors.green), textAlign: TextAlign.right,),
                    ),
                    Expanded(
                      flex: 4,
                      child: new TextFormField(
                        onSaved: (val)=> this._data['membankaddress'] = val,
                        decoration: InputDecoration(
                          fillColor: Colors.black,
                          contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                          hintText: '请输入开户支行',
                          hintStyle: TextStyle(color: Colors.grey[300]),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        cursorColor: Colors.green,
                      ),
                    ),
                  ],
                )
              ),

              new Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 35),
                padding: EdgeInsets.only(left: 15, right: 15),
                child: new FlatButton(
                  color: Colors.green,
                  padding: EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  onPressed: _onSubmit,
                  child: Text('确定绑定', style: new TextStyle(color: Colors.white, fontSize: 16.0),)
                ),
              ),
            ],
        )),
      ],
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('绑定银行卡'),
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: (){
              Navigator.pop(super.context);
            },
          ),
        ),
        body: !_loaded ? new LoadingView() :_body,
      ),
    );
  }
}