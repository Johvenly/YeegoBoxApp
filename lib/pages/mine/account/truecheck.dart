import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import '../../../config/api.dart';
import '../../../common/http.dart';
import '../../../common/user.dart';
import '../../../common/loading.dart';

class Truecheck extends StatefulWidget{
  State<StatefulWidget> createState() => new TruecheckState();
}

class TruecheckState extends State with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  //数据控制字段
  bool _loaded = false;
  Map _userInfo = new Map();

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

  Future getImage(String type, String divide) async {
    var image;
    if(divide == 'gallery'){
      image = await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: MediaQuery.of(context).size.width * 1.5);
    }else{
      image = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: MediaQuery.of(context).size.width * 1.5);
    }

    if(image != null){
      FormData data = new FormData.from({
        'account_token': _userInfo['token'],
        'type': type,
        'photo': new UploadFileInfo(image, "photo.jpg")
      });
      await Http.post(API.truecheck, data: data).then((result){
        if(result['code'] == 1){
          setState(() {
            _userInfo[type] = result['url'];
          });
        }
        Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER);
      });
    }
  }

  void showSelect(String type){
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
                    getImage(type, 'camera');
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
                    getImage(type, 'gallery');
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
      }
    );
  }

  @override
  Widget build(BuildContext context){
    Widget _body = !_loaded ? new LoadingView() : new ListView(
      padding: EdgeInsets.only(bottom: 25),
      children: <Widget>[
        new Container(
          padding: EdgeInsets.only(top:8, bottom:8, left: 15),
          margin: EdgeInsets.only(top: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey[200]))
          ),
          child: new Column(
            children: <Widget>[
              new Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8, right: 15),
                  child: new Row(
                    children: <Widget>[
                      Text('真实姓名', style: TextStyle(fontSize: 16),),
                      Text(_userInfo['truename'].toString()),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
              ),
              new Divider(),
              new Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8, right: 15),
                  child: new Row(
                    children: <Widget>[
                      Text('身份证号码', style: TextStyle(fontSize: 16),),
                      Text(_userInfo['idcard'].toString()),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
              ),
            ]
          ),
        ),
        new Container(
          margin: EdgeInsets.only(top: 35, left: 15, right: 15),
          child: AspectRatio(
            aspectRatio: 85.6/54,
            child: new GestureDetector(
              child: new Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: (_userInfo['idcardfront'] == null || _userInfo['idcardfront'] == '') ? AssetImage('assets/images/idcard01.jpg') : CachedNetworkImageProvider(API.host + _userInfo['idcardfront']),
                    fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Icon((_userInfo['idcardfront'] == null || _userInfo['idcardfront'] == '') ? Icons.add_a_photo : Icons.check, color: Colors.white, size: 45,),
              ),
              onTap: (){
                if(_userInfo['idcardfront'] == null || _userInfo['idcardfront'] == ''){
                  showSelect('idcardfront');
                }
              },
            ),
          ),
        ),
        Text('身份证正面照片', textAlign: TextAlign.center, style: TextStyle(height: 2, color: Colors.grey),),
        new Container(
          margin: EdgeInsets.only(top: 20, left: 15, right: 15),
          child: AspectRatio(
            aspectRatio: 85.6/54,
            child: new GestureDetector(
              child: new Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: (_userInfo['idcardreverse'] == null || _userInfo['idcardreverse'] == '') ? AssetImage('assets/images/idcard02.jpg') : CachedNetworkImageProvider(API.host + _userInfo['idcardreverse']),
                    fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Icon((_userInfo['idcardreverse'] == null || _userInfo['idcardreverse'] == '') ? Icons.add_a_photo : Icons.check, color: Colors.white, size: 45,),
              ),
              onTap: (){
                if(_userInfo['idcardreverse'] == null || _userInfo['idcardreverse'] == ''){
                  showSelect('idcardreverse');
                }
              },
            ),
          ),
        ),
        Text('身份证反面照片', textAlign: TextAlign.center, style: TextStyle(height: 2, color: Colors.grey),),
      ],
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('实名信息', style: TextStyle(color: Colors.white)),
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