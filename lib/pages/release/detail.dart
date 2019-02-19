import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../../config/api.dart';
import '../../common/http.dart';
import '../../common/user.dart';
import '../../common/loading.dart';

class RDetail extends StatefulWidget{
  final int id;
  RDetail({Key key, this.id}) : super(key: key);

  State<StatefulWidget> createState() => new RDetailState();
}

class RDetailState extends State<RDetail> with TickerProviderStateMixin {
  //初始化页面数据
  Map pageRowData;
  //数据控制字段
  bool _loaded = false;
  String _token;                                        //登录Token
  TextEditingController _shopnameController = new TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    initData().then((_){
      setState(() {
        _loaded = true;
      });
    });
  }

  Future<dynamic> initData() async {
    await User.isLogin().then((_) async{
      if(_){
        await User.getAccountToken().then((token) async{
          setState(() {
            _token = token;
          });
        });
      }
    });
    await Http.post(API.getReleaseDetail, data: {'account_token': _token, 'id': widget.id}).then((result) async{
      if(result['code'] == 1){
        setState(() {
          pageRowData = result['data'];
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
    List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
      return <Widget>[
        SliverAppBar(
          //标题居中
          centerTitle: true,
          //展开高度250
          expandedHeight: 250.0,
          //不随着滑动隐藏标题
          floating: true,
          //固定在顶部
          pinned: true,
          forceElevated: true,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            // title: Text('我是一个FlexibleSpaceBar',),
            background: pageRowData['thumbnail'] == null ? new Image.asset('assets/images/placeholder.jpg', fit: BoxFit.cover,) :  Swiper.children(
              children: pageRowData['thumbnail'].map<Widget>((src){
                return src != null ? 
                new FadeInImage.assetNetwork(
                  image: API.host + src,
                  fit: BoxFit.cover,
                  placeholder: 'assets/images/placeholder.jpg',
                  placeholderScale: 2,
                ):
                 new Container();
              }).toList(),
              pagination: new SwiperPagination(
                builder: DotSwiperPaginationBuilder(
                  color: Colors.black54,
                  activeColor: Colors.red,
                )
              ),
              control: null,
              autoplay: true,
              onTap: (index) => print('点击了第$index个'),
            ),
          ),
          leading: IconButton(
            icon: BackButtonIcon(),
            onPressed: (){
              Navigator.pop(super.context);
            },
          ),
          backgroundColor: Colors.green,
          // title: Text('产品详情'),
        ),
      ];
    }

    Widget _body = !_loaded ? new Container(): new Container(
      color: Colors.grey[100],
      child: new ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          //标题等内容
          new Container(
            color: Colors.white,
            padding: EdgeInsets.only(top:8, bottom: 8, left: 15, ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('关键词', style: TextStyle(color: Colors.grey,),),
                      Text(pageRowData['keywordname'] ?? ''),
                    ],
                  ),
                ),
                new Divider(),
                new Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('任务编号', style: TextStyle(color: Colors.grey,),),
                      Text(pageRowData['orderno'] ?? ''),
                    ],
                  ),
                ),
                new Divider(),
                new Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('任务类型', style: TextStyle(color: Colors.grey,),),
                      Text((pageRowData['classname'] ?? '') + '自然搜索'),
                    ],
                  ),
                ),
                new Divider(),
                new Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('商家QQ', style: TextStyle(color: Colors.grey,),),
                      Text(pageRowData['qq'] ?? ''),
                    ],
                  ),
                ),
                new Divider(),
                new Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('商家电话', style: TextStyle(color: Colors.grey,),),
                      Text(pageRowData['phone'] ?? ''),
                    ],
                  ),
                ),
              ],
            ),
          ),

          //商家备注
          new Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.only(left: 15, top: 8, bottom: 15),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: Text('商家备注', style:TextStyle(color: Colors.orange)),
                ),
                new Divider(),
                Text(pageRowData['requirement'] ?? '', style: TextStyle(height: 1.2,), maxLines: 5, overflow: TextOverflow.ellipsis,),
              ],
            ),
          ),

          //确认店铺名称
          new Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.only(left: 15, top: 8, bottom: 15),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: Text('店铺名称：' + ((pageRowData != null) ? (pageRowData['status'] == 1 ? pageRowData['shopname'] : pageRowData['shopstarname']) : ''), style:TextStyle(color: Colors.red)),
                ),
                new Divider(),
                pageRowData['status'] == 0 ? 
                new Padding(
                  padding: EdgeInsets.only(right: 15, bottom: 8, top: 8),
                  child: new TextField(
                    controller: _shopnameController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                      hintText: '注意店铺名称可能有空格或大写',
                      hintStyle: TextStyle(color: Colors.grey[300]),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[300])),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green),),
                    ),
                    cursorColor: Colors.green,
                  ),
                ) : new Container(),
              ],
            ),
          ),

          //温馨提示
          new Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.only(left: 15, top: 8, bottom: 15),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('温馨提示', style:TextStyle(color: Colors.red)),
                      FlatButton(
                        color: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        child: Text('点击这里联系商家', style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final String url = 'mqqwpa://im/chat?chat_type=wpa&uin=' + pageRowData['qq'] + '&version=1&src_type=web&web_src=oicqzone.com';
                          // if (await canLaunch(url)) {
                          //   await launch(url);
                          // } else {
                          //   throw 'Could not launch $url';
                          // }
                          // Navigator.push(context, new MaterialPageRoute<void>(
                          //   builder: (BuildContext context) {
                          //     return new WebviewScaffold(
                          //       url: url,
                          //       appBar: new AppBar(
                          //         title: const Text('打开QQ聊天'),
                          //         backgroundColor: Colors.green,
                          //         leading: new IconButton(
                          //           icon: BackButtonIcon(),
                          //           onPressed: (){
                          //             Navigator.pop(context);
                          //           }
                          //         )
                          //       ),
                          //       withZoom: true,
                          //       withLocalStorage: true,
                          //     );
                          //   },
                          // ));
                        },
                      ),
                    ],
                  ),
                ),
                new Divider(),
                Text('''接单提醒一:\r\n接单提醒二:\r\n接单提醒三:''', style: TextStyle(height: 1.2, color: Colors.grey),),
              ],
            ),
          ),

          new Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(25),
            child: new Offstage(
              offstage: pageRowData['status'] == 0 ? false : true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Expanded(
                    child: new FlatButton(
                      color: Colors.green,
                      padding: EdgeInsets.only(top: 12, bottom: 12, left: 25, right: 25),
                      shape: RoundedRectangleBorder(
                        side: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      onPressed: () {
                        if(pageRowData['status'] != 0){
                          Fluttertoast.showToast(msg: '只能审核进行中的任务', gravity: ToastGravity.CENTER);
                          return;
                        }
                        if(_shopnameController.text == ''){
                          Fluttertoast.showToast(msg: '请输入店铺名称', gravity: ToastGravity.CENTER);
                          return;
                        }
                        Http.post(API.checkRelease, data: {'account_token': _token, 'id': widget.id, 'shopname': _shopnameController.text}).then((result){
                            if(result['code'] == 1){
                              Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER).then((_) async{
                                setState(() {
                                  pageRowData['status'] = 2;
                                });
                              });
                            }else{
                              Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER);
                            }
                        });
                      },
                      child: Text('提交审核', style: new TextStyle(color: Colors.white, fontSize: 16.0),)
                    ),
                  ),
                  new Container(
                    width: 20,
                  ),
                  new Expanded(
                    child: new FlatButton(
                      color: Colors.red,
                      padding: EdgeInsets.only(top: 12, bottom: 12, left: 25, right: 25),
                      shape: RoundedRectangleBorder(
                        side: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      onPressed: () {
                        if(pageRowData['status'] != 0){
                          Fluttertoast.showToast(msg: '只能取消进行中的任务', gravity: ToastGravity.CENTER);
                          return;
                        }
                        Http.post(API.cancelRelease, data: {'account_token': _token, 'id': widget.id}).then((result){
                            if(result['code'] == 1){
                              Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER).then((_) async{
                                setState(() {
                                  pageRowData['status'] = -1;
                                });
                              });
                            }else{
                              Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER);
                            }
                        });
                      },
                      child: Text('取消任务', style: new TextStyle(color: Colors.white, fontSize: 16.0),)
                    ),
                  )
                ],
              ),
            ),
          ),
          //按钮组
          
        ],
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: !_loaded ? new LoadingView(): NestedScrollView(
          headerSliverBuilder: _sliverBuilder,
          body: _body,
        ),
      ),
    );
  }
}