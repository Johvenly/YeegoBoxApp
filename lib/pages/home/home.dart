import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/api.dart';
import '../../common/user.dart';
import '../../common/http.dart';
import '../../common/loading.dart';
import 'notice/notice.dart';
import 'notice/detail.dart';
import '../auth/login.dart';
import '../release/detail.dart';
import '../browse/detail.dart';
import 'apply/apply.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new HomeState();
}

class HomeState extends State with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

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
    int _browseCount = 0;
    Map _userinfo = new Map();              //用户信息
    String _token;                          //登录Token
    TextEditingController _priceController = new TextEditingController();
    RefreshController _controller = new RefreshController();

  //初始化控件状态
  @override
    void initState() {
      super.initState();
      initData().then((_){
        setState(() {
          _loaded = true;
        });
      });
      UserEvent.eventBus.on<UserEvent>().listen((_){
        initData();
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
    await Http.post(API.getSlideShow, data: {'pageach': 5}).then((result){
      if(result['code'] == 1){
        _slides.clear();
        setState(() {
          _slides = result['data'].map<Widget>((row){
            return CachedNetworkImage(
              imageUrl: API.host + row['img'],
              fit: BoxFit.cover,
              placeholder: Image.asset('assets/images/placeholder.jpg', fit: BoxFit.cover,),
              errorWidget: Image.asset('assets/images/placeholder.jpg', fit: BoxFit.cover,),
            );
          }).toList();
        });
      }
    });
    await initLoginData();
    print('Home界面数据初始化...');
  }

  Future<dynamic> initLoginData() async{
    await User.isLogin().then((_) async{
      if(_){
        await User.getAccountToken().then((token) async{
          setState(() {   
            _token = token;
          });
          // 查询会员附加信息
          await Http.post(API.subUser, data: {'account_token': token}).then((result){
            if(result['code'] == 1){
              setState(() {
                _userinfo = result['data'];
              });
            }
          });
          // 加载试用任务统计数据
          await Http.post(API.getReleaseCount, data: {'account_token': token}).then((result){
            if(result['code'] == 1){
              setState((){
                _releaseList.forEach((row){
                  int index = _releaseList.indexOf(row);
                  _releaseList[index]['stock'] = result['data'][row['classid'].toString()] ?? 0 ;
                });
              });
            }
          });
          // 加载浏览任务统计数据
          await Http.post(API.getBrowseCount, data: {'account_token': token}).then((result){
            if(result['code'] == 1){
              setState((){
                _browseCount = result['data'];
              });
            }
          });
        });
      }else{
        setState(() {   
          _token = null;
        });
      }
    });
  }

  // 头部指示器构造
  Widget _headerCreate(BuildContext context, int mode) {
    return new Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]))
      ),
      child: ClassicIndicator(
        mode: mode,
        height: 50,
        spacing: 8,
        refreshingIcon: SpinKitRing(color: Colors.green, size: 20, lineWidth: 2.0,),
        refreshingText: '刷新页面数据...',
        idleText: '下拉刷新列表...',
        releaseText: '放开开始刷新...',
        failedText: '刷新数据失败',
        completeText: '完成数据更新',
      ),
    );
  }

  void _onRefresh(bool up) {
    if (up){
      _controller.sendBack(false, RefreshStatus.canRefresh);
      new Future.delayed(const Duration(milliseconds: 2009)).then((val) {
        initLoginData().then((_){
          _controller.sendBack(true, RefreshStatus.completed);
        });
      });
    }
  }
  
  @override
  Widget build(BuildContext context){
    ScrollView _body = new ListView(
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
        new Container(
          padding: EdgeInsets.only(top: 15, bottom: 15),
          color: Colors.white,
          child: new ButtonBar(
            alignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _token != null ?
                  Text(_userinfo['release'].toString() ?? '0', style: TextStyle(fontSize: 20,),) :
                  Icon(Icons.insert_drive_file, color: Colors.black54,),
                  Text('试用报告', style: TextStyle(height: 1.5),),
                ],
              ),
              new GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Column(
                  children: <Widget>[
                    _token != null ?
                    Text(_userinfo['apply'].toString() ?? '0', style: TextStyle(fontSize: 20,),) :
                    Icon(Icons.group, color: Colors.black54,),
                    Text('邀请好友', style: TextStyle(height: 1.5),),
                  ],
                ),
                onTap: (){
                  if(_token ==null){
                    return;
                  }
                  Navigator.of(super.context).push(
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new Apply()),
                  );
                },
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
        new Container(
          color: Colors.white,
          child: new Row(
            children: <Widget>[
              Icon(Icons.track_changes, color: Colors.green, size: 16,),
              Text(' 试客任务'),
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          padding: EdgeInsets.only(top: 15, bottom: 15, left: 8, right: 8),
        ),
        new Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          color: Colors.white,
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
        new Container(
          color: Colors.white,
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
                if(_releaseSelectClassID == 5){
                  // 提交任务申请
                  Http.post(API.getRelease, data: {'account_token': _token, 'type': _releaseSelectClassID}).then((result){
                    if(result['code'] == 1){
                      Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER).then((_) async{
                        await Navigator.of(super.context).push(
                          new MaterialPageRoute(
                              builder: (BuildContext context) => new RDetail(id: int.parse(result['data']))),
                        ).then((_){
                            initLoginData();
                          });
                      });
                    }else{
                      Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER);
                    }
                  });
                  return;
                }
                showDialog<Null>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return new SimpleDialog(
                        title: new Text('接受垫付的最大金额', style: TextStyle(fontWeight: FontWeight.w100, color: Colors.green, fontSize: 16),),
                        titlePadding: EdgeInsets.all(8),
                        contentPadding: EdgeInsets.all(0),
                        children: <Widget>[
                          new Container(
                            margin: EdgeInsets.all(15),
                            child: new TextField(
                                controller: _priceController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 8, right: 15),
                                  hintText: '输入您能垫付的最大金额',
                                  hintStyle: TextStyle(color: Colors.grey[300]),
                                  suffixText: '元',
                                  suffixStyle: TextStyle(color: Colors.black),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[300])),
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green),),
                                ),
                                enabled: true,
                                cursorColor: Colors.green,
                                autofocus: true,
                                keyboardType: TextInputType.number,
                            ),
                          ),
                          new Container(
                            margin: EdgeInsets.only(top: 3),
                            color: Colors.grey[200],
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                new Expanded(
                                  flex: 1,
                                  child: new GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    child: new Container(
                                      padding: EdgeInsets.all(15),
                                      child: new Text('取消', textAlign: TextAlign.center,),
                                    ),
                                    onTap: (){
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                new Expanded(
                                  flex: 1,
                                  child: new GestureDetector(
                                    child: new Container(
                                      padding: EdgeInsets.all(15),
                                      color: Colors.green,
                                      child: Text('确定', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
                                    ),
                                    onTap: (){
                                      double price;
                                      if((_priceController.text == '' || double.parse(_priceController.text) <= 0)){
                                        price = 0.00;
                                      }else{
                                        price = double.parse(_priceController.text);
                                      }
                                      // 提交任务申请
                                      Http.post(API.getRelease, data: {'account_token': _token, 'type': _releaseSelectClassID, 'price': price}).then((result){
                                        if(result['code'] == 1){
                                          Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER).then((_) async{
                                            await Navigator.of(super.context).push(
                                              new MaterialPageRoute(
                                                  builder: (BuildContext context) => new RDetail(id: int.parse(result['data']))),
                                            ).then((_){
                                              initLoginData();
                                            });
                                          });
                                        }else{
                                          Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER);
                                        }
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                );
              },
              child: Text('接受任务', style: new TextStyle(color: Colors.white, fontSize: 16.0),
            )
          ),
        ),
        new Container(
          padding: EdgeInsets.only(bottom: 15),
          color: Colors.white,
          child: Text('试用返利下单直接封号，上门要钱后果自负', style: TextStyle(fontSize: 14, color: Colors.grey), textAlign: TextAlign.center,),
        ),
        new Container(
          padding: EdgeInsets.only(top: 8),
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
                Text('（机会：'+ _browseCount.toString() +'）', style: TextStyle(color: Colors.grey),),
              ],
            ),
          ),
        ),
        new Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 25, bottom: 25, left: 25, right: 25),
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
                // 提交任务申请
                Http.post(API.getBrowse, data: {'account_token': _token}).then((result){
                  if(result['code'] == 1){
                    Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER).then((_) async{
                      await Navigator.of(super.context).push(
                        new MaterialPageRoute(
                            builder: (BuildContext context) => new BDetail(id: int.parse(result['data']))),
                      );
                    });
                  }else{
                    Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER);
                  }
                });
              },
              child: Text('接受任务', style: new TextStyle(color: Colors.white, fontSize: 16.0),
            )
          ),
        ),
      ],
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
        body: !_loaded ? new LoadingView() : new SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          controller: _controller,
          onRefresh: _onRefresh,
          headerBuilder: _headerCreate,
          child: _body,
        ),
      ),
    );
  }
}