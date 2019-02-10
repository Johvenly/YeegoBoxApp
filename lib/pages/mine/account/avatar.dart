import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../config/api.dart';
import '../../../common/http.dart';
import '../../../common/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

class UserAvatar extends StatefulWidget{
  State<StatefulWidget> createState() => new UserAvatarState();
}

class UserAvatarState extends State<UserAvatar>{
  String _avatar;
  String _token;

  Future getImage(String divide) async {
    var image;
    if(divide == 'gallery'){
      image = await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: MediaQuery.of(context).size.width * 1.5);
    }else{
      image = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: MediaQuery.of(context).size.width * 1.5);
    }

    if(image != null){
      FormData data = new FormData.from({
        'account_token': _token,
        'avatar': new UploadFileInfo(image, "avatar.jpg")
      });
      await Http.post(API.uploadAvatar, data: data).then((result){
        if(result['code'] == 1){
          setState(() {
            _avatar = result['url'];
          });
        }
        Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER);
      });
    }
  }

  @override
    void initState() {
      super.initState();
      User.getUserInfo().then((result){
          setState(() {
            _avatar = result[User.FIELD_AVATAR];
            _token = result[User.FIELD_TOKEN];
          });
      });
    }
  
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          title: Text('个人头像', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            color: Colors.white,
            icon: BackButtonIcon(),
            onPressed: (){
              Navigator.pop(context, _avatar);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_horiz, color: Colors.white),
              onPressed: (){
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
                                getImage('camera');
                                Navigator.pop(context);
                              },
                            ),
                            new Divider(),
                            new GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: new FractionallySizedBox(
                                  widthFactor: 1,
                                  child: Text('从手机相册选择', style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),
                                ),
                              ),
                              onTap: (){
                                getImage('gallery');
                                Navigator.pop(context);
                              },
                            ),
                            new Divider(),
                            new GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 15),
                                child: Text('保存图片', style: TextStyle(fontSize: 18),),
                              ),
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
              },
            ),
          ],
        ),
        body: new Center(
          child: new FractionallySizedBox(
            widthFactor: 0.95,
            child: new ClipOval(
              child: new AspectRatio(
                aspectRatio: 1,
                child: (_avatar != null && _avatar != '') ? new CachedNetworkImage(imageUrl: API.host + _avatar, fit: BoxFit.cover) : Image.asset('assets/images/avatar.jpg', fit: BoxFit.cover),
              ),
            ),
          )
        ),
      ),
    );
  }
}