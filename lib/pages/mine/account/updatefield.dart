import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../config/api.dart';
import '../../../common/http.dart';
import '../../../common/user.dart';
import '../../../common/loading.dart';

class UpdateField extends StatefulWidget{
  final String filedname;
  UpdateField({Key key, this.filedname}): super(key: key);
  State<StatefulWidget> createState() => new UpdateFieldState();
}

class UpdateFieldState extends State<UpdateField> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  //数据控制字段
  bool _loaded = false;
  String _token;
  TextEditingController _valueController = new TextEditingController();
  Map _authfields = {'username': '用户名'};

  @override
  void initState() {
    super.initState();
    User.getUserInfo().then((result){
        setState(() {
          _token = result[User.FIELD_TOKEN];
        });
    });
  }

  @override
  Widget build(BuildContext context){
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
              controller: _valueController,
              decoration: InputDecoration(
                fillColor: Colors.black,
                contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                hintText: '输入您的' + (_authfields[widget.filedname] ?? '字段名'),
                hintStyle: TextStyle(color: Colors.grey[300]),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              cursorColor: Colors.green,
            ),
          ),
        ]
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(_authfields[widget.filedname] ?? '字段名', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: BackButtonIcon(),
            onPressed: (){
              Navigator.pop(super.context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Text('完成'),
              onPressed: (){
                if(_valueController.text == ''){
                  Fluttertoast.showToast(msg: (_authfields[widget.filedname] ?? '字段名') + '不能为空', gravity: ToastGravity.CENTER);
                  return;
                }
                Http.post(API.updateField, data: {'account_token': _token, 'field':widget.filedname, 'value':_valueController.text, 'unqiue': 1}).then((result){
                  if(result['code'] == 1){
                    Fluttertoast.showToast(msg: '修改' + (_authfields[widget.filedname] ?? '字段名') + '成功', gravity: ToastGravity.CENTER).then((_){
                      Navigator.pop(super.context, _valueController.text);
                    });
                  }else{
                    Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER);
                  }
                });
              },
            ),
          ],
        ),
        body: _body,
      ),
    );
  }
}