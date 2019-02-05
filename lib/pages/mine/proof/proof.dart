import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_picker/flutter_picker.dart';
import '../../../config/api.dart';
import '../../../common/http.dart';
import '../../../common/user.dart';
import '../../../common/loading.dart';
import 'explain.dart';

class Proof extends StatefulWidget{
  final int type;
  Proof({Key key, this.type}) : super(key: key);
  State<StatefulWidget> createState() => new ProofState();
}

class ProofState extends State<Proof>{
  //数据控制字段
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loaded = false;
  String _token;
  Map _class;
  Map _fielddatas = new Map();
  List _fields = new List();
  Map _imgdatas = new Map();
  List _imgs = new List();

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
    await User.getAccountToken().then((token){
      setState(() {
        _token = token;
      });
    });
    await Http.post(API.proofFields, data: {'type': widget.type}).then((result){
      if(result['code'] == 1){
        setState(() {
          _class = result['class'];
          if(result['fields'] != null){
            result['fields'].forEach((key, value){
              Map item = value;
              item['key'] = key;
              if(item['type'] == 'text'){
                item['hit'] = '请输入' + item['name'];
              }else if(item['type'] == 'select'){
                item['hit'] = '请选择' + item['name'];
              }else{
                item['hit'] = item['name'];
              }
              _fields.add(item);
              _fielddatas[key] = null;
            });
          }
          if(result['imgs'] != null){
            result['imgs'].forEach((key,value){
              Map row = new Map();
              row['key'] = key;
              row['name'] = value;
              row['file'] = null;
              _imgs.add(row);
              _imgdatas[key] = null;
            });
          }
        });
      }
    });
  }

  Future getImage(int index, String divide) async {
    var image;
    if(divide == 'gallery'){
      image = await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: MediaQuery.of(context).size.width * 2);
    }else{
      image = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: MediaQuery.of(context).size.width * 2);
    }

    if(image != null){
      FormData data = new FormData.from({
        'account_token': _token,
        'image': new UploadFileInfo(image, "image.jpg")
      });
      await Http.post(API.uploadProofImage, data: data).then((result){
        if(result['code'] == 1){
          setState(() {
            _imgs[index]['file'] = image;
            _imgdatas[_imgs[index]['key']] = result['fileid'];
          });
        }
        Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER);
      });
    }
  }

  void _onSubmit() {
    final form = _formKey.currentState;
    form.save();
    Http.post(API.proofBind, data: {'account_token': _token, 'type': widget.type, 'fields': _fielddatas, 'imgs': _imgdatas}).then((result){
      if(result['code'] == 1){
        Navigator.pop(context, _fielddatas['name']);
      }
      Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER);
    });
    print(_fielddatas);
    print(_imgdatas);
  }

  @override
  Widget build(BuildContext context){
    Widget _li(Map row){
      int index = _fields.indexOf(row);
      if(row['type'] == 'text'){
        return new TextFormField(
          onSaved: (val)=> _fielddatas[row['key']] = val,
          decoration: InputDecoration(
            fillColor: Colors.black,
            contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
            hintText: row['hit'],
            hintStyle: TextStyle(color: Colors.grey[300]),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          cursorColor: Colors.green,
          keyboardType: TextInputType.number,
        );
      }else if(row['type'] == 'select'){
        return new GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: new Padding(
            padding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(row['hit'], style: TextStyle(color: _fielddatas[row['key']] == null ? Colors.grey[300] : Colors.black87, fontSize: 16),),
                Icon(Icons.arrow_drop_down, color: Colors.grey,)
              ],
            ),
          ),
          onTap: (){
            List _pickerdata = row['data'].values.toList();
            List _pickerkey = row['data'].keys.toList();
            new Picker(
              adapter: PickerDataAdapter<String>(pickerdata: _pickerdata),
              changeToFirst: true,
              textAlign: TextAlign.center,
              selecteds: [_fielddatas[row['key']] !=null ? _pickerkey.indexOf(_fielddatas[row['key']]) : 0],
              columnPadding: const EdgeInsets.all(8.0),
              cancelText: '取消',
              cancelTextStyle: TextStyle(color: Colors.green, fontSize: 16,),
              confirmText: '完成',
              confirmTextStyle: TextStyle(color: Colors.green, fontSize: 16,),
              onConfirm: (Picker picker, List value) {
                setState(() {
                  _fields[index]['hit'] = '已选择: ' + picker.getSelectedValues()[0];
                  _fielddatas[row['key']] = _pickerkey[value[0]];
                });
              }
            ).show(_scaffoldKey.currentState);
          },
        );
      }else{
        return new Container();
      }
    };
    Widget _body = !_loaded ? new LoadingView() : new ListView(
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.all(15),
          child: Text('注意事项', style: TextStyle(color: Colors.grey),),
        ),
        new Container(
          color: Colors.white,
          padding: EdgeInsets.all(15),
          child: new Column(
            children: <Widget>[
              Text('账号审核时间<i>周一至周五9:30-18:00</i>，账号提交后5个工作日内完成审核，如遇周末或节假日顺延，审核工作人工进行，用户请耐心等待，新手务必查看下方<i>审核要求'),
              new Padding(
                padding: EdgeInsets.only(top: 15),
                child: new FractionallySizedBox(
                  widthFactor: 1,
                  child: new FlatButton(
                    color: Colors.orange,
                    padding: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      side: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Text('点击查看审核要求', style: new TextStyle(color: Colors.white, fontSize: 16.0),),
                    onPressed: (){
                      Navigator.of(super.context).push(
                        new MaterialPageRoute(
                            builder: (BuildContext context) => new Explain(row: _class,), fullscreenDialog: true),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        new Container(
          margin: EdgeInsets.only(top: 8),
          padding: EdgeInsets.only(top:15, bottom: 15),
          color: Colors.white,
          child: new Column(
            children: <Widget>[
              new Form(
                key: _formKey,
                child: new Column(
                children: _fields.map<Widget>((row){
                  return new Container(
                    margin: EdgeInsets.only(top: 4, bottom: 4),
                    padding: EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[100]
                    ),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(row['name'], style: TextStyle(color: Colors.green), textAlign: TextAlign.right,),
                        ),
                        Expanded(
                          flex: 4,
                          child: _li(row),
                        ),
                      ],
                    )
                  );
                }).toList(),
            )),
            new Divider(),
            (_imgs.length > 0) ?
            new GridView.count(
              shrinkWrap: true, 
              primary: false,
              padding: const EdgeInsets.all(15.0),
              mainAxisSpacing: 15.0,//竖向间距
              crossAxisCount: 4,//横向Item的个数
              crossAxisSpacing: 8.0,//横向间距
              childAspectRatio: 0.8,
              children: _imgs.map<Widget>((row){
                int index = _imgs.indexOf(row);
                return new Column(
                  children: <Widget>[
                    new GestureDetector(
                      child: new Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.green[100])
                        ),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: row['file'] == null ? Icon(Icons.add, color: Colors.grey[300],) : Image.file(row['file']),
                        ),
                      ),
                      onTap: (){
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context){
                            return new GestureDetector(
                              onTap: (){return false;},
                              child: Container(
                                color: Colors.transparent,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 15, bottom: 10),
                                        child: Text('拍照', style: TextStyle(fontSize: 18),),
                                      ),
                                      onTap: (){
                                        getImage(index, 'camera');
                                        Navigator.pop(context);
                                      },
                                    ),
                                    new Divider(),
                                    new GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 10, bottom: 15),
                                        child: new FractionallySizedBox(
                                          widthFactor: 1,
                                          child: Text('从手机相册选择', style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),
                                        ),
                                      ),
                                      onTap: (){
                                        getImage(index, 'gallery');
                                        Navigator.pop(context);
                                      },
                                    ),
                                    new FractionallySizedBox(
                                      widthFactor: 1,
                                      child: Container(
                                        color: Colors.grey[300],
                                        padding: EdgeInsets.only(top: 8),
                                        child: new GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          child: Container(
                                            color: Colors.white,
                                            padding: EdgeInsets.only(top: 15, bottom: 8),
                                            child: Text('取消', style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),
                                          ),
                                          onTap: (){
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                      },
                    ),
                    SizedBox(
                      height: 20,
                      child: Text(row['name'], style: TextStyle(height: 1.5, color: Colors.black54),),
                    )
                  ],
                );
              }).toList(),
            ) : new Container(),
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
                child: Text('提交审核', style: new TextStyle(color: Colors.white, fontSize: 16.0),)
              ),
            ),
            ],
          ),
        )
      ],
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          title: Text('绑定'+(_class != null && _class['name'] != null ? _class['name'] : '')+'账号'),
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: BackButtonIcon(),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
        body: !_loaded ? new LoadingView() :_body,
      ),
    );
  }
}