import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../config/api.dart';
import '../../../common/http.dart';
import '../../../common/loading.dart';
import 'detail.dart';

class Notice extends StatefulWidget {
  @override
  _NoticeState createState() => new _NoticeState();
}

class _NoticeState extends State<Notice> with TickerProviderStateMixin {
  RefreshController _controller;

  // 数据控制字段
  bool _loaded = false;                                 //界面初始化数据加载控制
  List list = new List();                               //列表数据
  int _page = 2;                                        //加载的页数
  bool _noMore = false;                                 //是否已停止加载数据（无更多数据）

  @override
  void initState() {
    super.initState();
    initData();
    _controller = new RefreshController();
  }

  //初始化界面数据
  Future<dynamic> initData() async{
    _fetch(page: 1).then((_){
      setState(() {
        _loaded = true;
      });
    });
    print('Notice界面数据初始化...');
  }

  // 加载数据函数
  Future _fetch({page = 1}) async {
    return Http.post(API.getNoticeList, data: {'page': page}).then((result){
      if(result['code'] == 1){
        setState(() {
          _page = page + 1;                                 //有数据时增加页数
          list.addAll(result['data']);

          // 判断是否无更多数据
          if(result['data'].length < result['pageach']){
            _noMore = true;
          }
        });
        return true;
      }else{
        Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER);
        return false;
      }
    });
  }

  //刷新加载数据
  void _onRefresh(bool up) {
    if (up){
      list.clear();
      _noMore = false;
      _controller.sendBack(false, RefreshStatus.canRefresh);

      new Future.delayed(const Duration(milliseconds: 2009)).then((val) {
        _fetch(page: 1).then((_){
          if(_){
            _controller.sendBack(true, RefreshStatus.completed);
          }else{
            _controller.sendBack(true, RefreshStatus.failed);
          }
        });
      });
      print("下拉刷新列表...");
    }else {
      if(_noMore){
        _controller.sendBack(false, RefreshStatus.noMore);
        return;
      }

      new Future.delayed(const Duration(milliseconds: 1000)).then((val) {
        _fetch(page: _page).then((_){
          if(_){
            _controller.sendBack(false, RefreshStatus.completed);
          }else{
            _controller.sendBack(false, RefreshStatus.failed);
          }
        });
      });
      print("上拉加载更多...");
    }
  }

  // 头部指示器构造
  Widget _headerCreate(BuildContext context, int mode) {
    return new Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]))
      ),
      child: ClassicIndicator(
        mode: mode,
        refreshingIcon: SpinKitFadingCube(color: Colors.green, size: 30,),
        refreshingText: '一大波数据正在赶来...',
        idleText: '下拉刷新列表...',
        releaseText: '放开开始刷新...',
        failedText: '刷新数据失败',
        completeText: '完成更新列表',
      ),
    );
  }

  // 尾部指示器构造
  Widget _footerCreate(BuildContext context, int mode) {
    return new ClassicIndicator(
      mode: mode,
      refreshingIcon: SpinKitFadingCube(color: Colors.green, size: 30,),
      refreshingText: '一大波数据正在赶来...',
      idleIcon: const Icon(Icons.arrow_upward),
      idleText: '上拉加载更多...',
      releaseIcon: Icon(Icons.arrow_downward),
      releaseText: '放开开始加载...',
      completeText: '完成加载列表',
      failedText: '加载数据失败',
      noDataText: '----- 我也是有底线的 -----',
      noMoreIcon: new Container()
    );
  }

  // 列表单条记录Widget
  Widget _renderRow(BuildContext context, int index) {
    if (index < list.length) {
      return new Column(
        children: <Widget>[
          ListTile(
            title: Text(list[index]['name'], maxLines: 1, overflow: TextOverflow.ellipsis,),
            subtitle: new Padding(
              padding: EdgeInsets.only(top: 15),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(list[index]['createtime']),
                  Text(list[index]['raadnum'].toString() + '人浏览', style: TextStyle(color: Colors.grey),),
                ],
              ),
            ),
            onTap: (){
              Navigator.of(super.context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new NoticeDetail(id: list[index]['id'])),
              );
            },
          ),
          new Divider(indent: 15, color: Colors.grey[300],),
        ],
      );
    }
  }

  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('消息公告', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: BackButtonIcon(),
            onPressed: (){
              Navigator.pop(super.context);
            },
          ),
        ),
        body: !_loaded ? new LoadingView() : new SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          controller: _controller,
          onRefresh: _onRefresh,
          headerBuilder: _headerCreate,
          footerBuilder: _footerCreate,
          footerConfig: new RefreshConfig(),
          child: new ListView.builder(
            padding: EdgeInsets.only(top: 8),
            itemBuilder: _renderRow,
            itemCount: list.length,
          ),
      ),
      ),
    );
  }
}
