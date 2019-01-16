import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'detail.dart';
import '../../config/api.dart';
import '../../common/http.dart';
import '../../common/user.dart';
import '../../common/loading.dart';

class RTask extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new RTaskState();
}

class RTaskState extends State<RTask> with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  //数据控制字段
  bool _loaded = false;
  String _token;                                        //登录Token

  TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
    print('RTask回收了状态');
  }

  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    UserEvent.eventBus.on<UserEvent>().listen((_){
      // try{
      //   initData();
      // }catch(e){}
    });

    initData().then((_){
      setState(() {
        _loaded = true;
      });
    });
    print('RTask初始化状态');
  }

  //初始化界面数据
  Future<dynamic> initData() async{
    await User.isLogin().then((_) async{
      if(_){
        await User.getAccountToken().then((token) async{
          setState(() {
            _token = token;
          });
        });
      }
    });
    print('RTask界面数据初始化...');
  }
  
  @override
  Widget build(BuildContext context){
    Widget _body = new Container(
      child: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          // 任务列表View
          new TaskListView(type: 0, token: _token,),
          new TaskListView(type: 1, token: _token,),
        ],
      ),
    );

    return !_loaded ? new LoadingView() : Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        title: Text('试客任务'),
        bottom: _token != null ? new TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(text: '任务',),
            Tab(text: '记录',),
          ],
        ) : null,
      ),
      body: _token != null ? _body : LoadingView.finished(title: '您当前未登录！'),
    );
  }
}


//任务列表显示控件
class TaskListView extends StatefulWidget{
  final int type;
  final String token;
  TaskListView({Key key, this.type, this.token}): super(key: key);

  @override
  State<StatefulWidget> createState() => new TaskListViewState();
}

class TaskListViewState extends State<TaskListView> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  RefreshController _controller;

  // 数据控制字段
  bool _loaded = false;                                 //界面初始化数据加载控制
  List list = new List();                               //列表数据
  int _page = 2;                                        //加载的页数
  bool _noMore = false;                                 //是否已停止加载数据（无更多数据）
  Widget _emptyWight = new LoadingView();               //空的加载Widget

  @override
  void initState() {
    super.initState();
    initData().then((_){
      setState(() {
        if(list.length > 0){
          _loaded = true;
        }else{
          _emptyWight = LoadingView.finished(title: '暂无数据');
        }
      });
    });
    _controller = new RefreshController();
  }

  //初始化界面数据
  Future<dynamic> initData() async{
    await _fetch(page: 1);
    print('tab1数据初始化...');
  }

  // 加载数据函数
  Future _fetch({page = 1}) async {
    return await Http.post(API.getReleaseList, data: {'page': page, 'type': widget.type, 'account_token': widget.token}).then((result){
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
        border: Border(bottom: BorderSide(color: Colors.grey[100]))
      ),
      child: ClassicIndicator(
        mode: mode,
        height: 50,
        spacing: 8,
        refreshingIcon: SpinKitRing(color: Colors.green, size: 20, lineWidth: 2.0,),
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
      height: 50,
      spacing: 8,
      refreshingIcon: SpinKitRing(color: Colors.green, size: 20, lineWidth: 2.0,),
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
      return new GestureDetector(
        child: new Container(
          padding: EdgeInsets.only(top: 15, bottom: 15),
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green[100]),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Text('积分 ' + list[index]['businessconsum'].toString(), style: TextStyle(color: Colors.green[100]),),
                    ),
                    Text(list[index]['createtime'], style: TextStyle(color: Colors.grey),),
                  ],
                ),
              ),
              new Divider(indent: 20,),
              new Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
                child: new Column(
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('任务状态'),
                          Text(list[index]['statusValue'], style: TextStyle(color: list[index]['status'] == 1 ? Colors.green : Colors.orange),),
                        ],
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('试用平台'),
                          Text(list[index]['classname'], style: TextStyle(color: Colors.grey),),
                        ],
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('任务编号'),
                          Text(list[index]['orderno'], style: TextStyle(color: Colors.grey),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: (){
          Navigator.of(super.context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) => new RDetail(id: list[index]['id'])),
          );
        },
      );
    }
  }

  Widget build(BuildContext context){
    return  !_loaded ? _emptyWight : new SmartRefresher(
      enablePullDown: true,
      enablePullUp: (widget.type == 0) ? false : true,
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
    );
  }
}