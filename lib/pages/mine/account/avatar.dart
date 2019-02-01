import 'package:flutter/material.dart';
import 'dart:io';
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

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
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
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_horiz, color: Colors.white),
              onPressed: (){
                getImage();
              },
            ),
          ],
        ),
        body: new Center(
          child: new FractionallySizedBox(
            widthFactor: 0.9,
            child: new ClipOval(
              child: (_avatar != null) ? new CachedNetworkImage(imageUrl: API.host + _avatar, fit: BoxFit.cover) : Image.asset('assets/images/avatar.jpg', fit: BoxFit.cover),
            ),
            // child: new CircleAvatar(backgroundColor: Colors.green ,backgroundImage: (_avatar != null) ? new CachedNetworkImageProvider(API.host + _avatar)
            //       : new AssetImage('assets/images/avatar.jpg')),
          )
        ),
      ),
    );
  }
}