import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../config/api.dart';
import '../../common/user.dart';
import '../../common/http.dart';
import '../../common/loading.dart';
import 'notice/notice.dart';
import 'notice/detail.dart';
import '../auth/login.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new HomeState();
}

class HomeState extends State{

    // 定义数据控制字段
    bool _loaded = false; 
    List _slides = <Widget>[
      Image.asset('assets/images/slide01.jpg', fit: BoxFit.cover,),
      Image.asset('assets/images/slide03.jpg', fit: BoxFit.cover,),
      Image.asset('assets/images/slide04.jpg', fit: BoxFit.cover,),
    ];
    List _notices = new List();             //公告列表数据
    List _releaseList = [
      {'classid': 1, 'pic': 'assets/images/logo_tb.jpg', 'stock': 0},
      {'classid': 2, 'pic': 'assets/images/logo_jd.jpg', 'stock': 0},
      {'classid': 5, 'pic': 'assets/images/logo_pdd.jpg', 'stock': 0},
    ];
    int _releaseSelectClassID = 1;          //当前选择使用任务平台ID
    Map _userinfo = new Map();              //用户信息
    String _token;                          //登录Token
    TextEditingController _priceController = new TextEditingController();

  //初始化控件状态
  @override
    void initState() {
      super.initState();
      initData().then((_){
        setState(() {
          _loaded = true;
        });
      });
    }

  //初始化界面数据
  Future<dynamic> initData() async{
    await Http.post(API.getNoticeList, data: {'pageach': 3}).then((result){
      if(result['code'] == 1){
        setState(() {
          _notices = result['data'];
        });
      }
    });
    await User.isLogin().then((_){
      if(_){
        User.getAccountToken().then((token) async{
          await Http.post(API.initUser, data: {'account_token': token}).then((result){
            if(result['code'] == 1){
              setState(() {
                _userinfo = result['data'];
                _token = result['data']['token'];
              });
            }else{
              Fluttertoast.showToast(msg: '您已在其他地方登录或账号已过期', gravity: ToastGravity.CENTER);
              User.delAccountToken();
            }
          });
          Http.post(API.getReleaseCount, data: {'account_token': token}).then((result){
            if(result['code'] == 1){
              setState(() {
                _releaseList.map((row){
                  int index = _releaseList.indexOf(row);
                  _releaseList[index]['stock'] = row[_releaseList[index]['classid']];
                });
              });
              print(result);
            }
          });
        });
      }
    });
    print('Home界面数据初始化...');
  }
  
  @override
  Widget build(BuildContext context){
    Widget _body = new Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: new ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          new Container(
            width: MediaQuery.of(context).size.width,
            height: 200.0,
            child: Swiper.children(
              children: _slides,
              pagination: new SwiperPagination(
                builder: DotSwiperPaginationBuilder(
                  color: Colors.black54,
                  activeColor: Colors.red,
                )
              ),
              control: null,
              autoplay: true,
              onTap: (index) => print('点击了第$index个'),
            )
          ),
          new Padding(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: new ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _token != null ?
                    Text(_userinfo['release'].toString(), style: TextStyle(fontSize: 20,),) :
                    Icon(Icons.insert_drive_file, color: Colors.black54,),
                    Text('试用报告', style: TextStyle(height: 1.5),),
                  ],
                ),
                Column(
                  children: <Widget>[
                    _token != null ?
                    Text(_userinfo['apply'].toString(), style: TextStyle(fontSize: 20,),) :
                    Icon(Icons.group, color: Colors.black54,),
                    Text('邀请好友', style: TextStyle(height: 1.5),),
                  ],
                ),
              ],
            ),
          ),
          new Container(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            color: Colors.grey[100],
            child: new Container(
              color: Colors.white,
              child: new Row(
                children: <Widget>[
                  new SizedBox(
                    width: 60,
                    child: Text('消息', textAlign: TextAlign.center, style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),),
                  ),
                  new Container(
                    width: MediaQuery.of(context).size.width - 70,
                    height: 50,
                    child: Swiper.children(
                      children: _notices.map<Widget>((row){
                        return new GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text(row['name'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,),
                              ),
                              Text(row['createtime'] ?? '', style: TextStyle(color: Colors.grey),),
                            ],
                          ),
                          onTap: (){
                            Navigator.of(context).push(
                              new MaterialPageRoute(
                                  builder: (BuildContext context) => new NoticeDetail(id: row['id'])),
                            );
                          },
                        );
                      }).toList(),
                      scrollDirection: Axis.vertical,
                      control: null,
                      autoplay: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          new Padding(
            child: new Row(
              children: <Widget>[
                Icon(Icons.track_changes, color: Colors.green, size: 16,),
                Text(' 试客任务'),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
            padding: EdgeInsets.only(top: 15, bottom: 15, left: 8, right: 8),
          ),
          new Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: new ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: _releaseList.map<Widget>((row){
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: new Opacity(
                        opacity: (_releaseSelectClassID == row['classid']) ? 1 : .2,
                        child: IconButton(
                          icon: Image.asset(row['pic'], fit: BoxFit.cover,),
                          iconSize:80, 
                          padding: EdgeInsets.all(0),
                          onPressed: (){
                            setState(() {
                              _releaseSelectClassID = row['classid'];                          
                            });
                          },
                        ),
                      ),
                    ),
                    Text('机会：'+row['stock'].toString(), style: TextStyle(height: 2),),
                  ],
                );
              }).toList(),
            ),
          ),
          (_releaseSelectClassID != 5) ?
          new Padding(
            padding: EdgeInsets.only(left: 25, right: 25, bottom: 8),
            child: new TextField(
              controller: _priceController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                hintText: '输入您能垫付的最大金额',
                hintStyle: TextStyle(color: Colors.grey[300]),
                suffixText: '元',
                suffixStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[300])),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green),),
              ),
              cursorColor: Colors.green,
              // autofocus: true,
              focusNode: FocusNode(),
            ),
          ) : new Container(),
          new Padding(
            padding: EdgeInsets.only(top: 15, bottom: 15, left: 25, right: 25),
              child: new FlatButton(
                color: Colors.green,
                padding: EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                onPressed: () {
                  if(_token == null){
                    Navigator.of(super.context).push(
                      new MaterialPageRoute(
                          builder: (BuildContext context) => new Login(), fullscreenDialog: true),
                    );
                    return;
                  }
                  if((_priceController.text == '' || double.parse(_priceController.text) <= 0) && _releaseSelectClassID != 5){
                    return;
                  }
                  print(_priceController.text + '-' + _releaseSelectClassID.toString());
                },
                child: Text('接受任务', style: new TextStyle(color: Colors.white, fontSize: 16.0),
              )
            ),
          ),
          Text('试用返利下单直接封号，上门要钱后果自负', style: TextStyle(fontSize: 14, color: Colors.grey), textAlign: TextAlign.center,),
          new Container(
            padding: EdgeInsets.only(top: 8),
            margin: EdgeInsets.only(top: 15),
            color: Colors.grey[100],
            child: new Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 8, top: 15, right: 8,),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      Icon(Icons.track_changes, color: Colors.green, size: 16,),
                      Text(' 浏览任务'),
                    ],
                  ),
                  Text('（机会：0）', style: TextStyle(color: Colors.grey),),
                ],
              ),
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 25, bottom: 25, left: 25, right: 25),
              child: new FlatButton(
                color: Colors.green,
                padding: EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                onPressed: () {
                  // _postLogin(
                  //     _userNameController.text, _userPassController.text);
                },
                child: Text('接受任务', style: new TextStyle(color: Colors.white, fontSize: 16.0),
              )
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
          centerTitle: true,
          backgroundColor: Colors.green,
          title: Text('易购宝盒'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.message, color: Colors.white, size: 25),
              onPressed: (){
                Navigator.of(super.context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new Notice()),
                );
              },
            ),
          ],
        ),
        body: !_loaded ? new LoadingView() : _body,
      ),
    );
  }
}