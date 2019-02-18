import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../config/api.dart';
import '../../../common/http.dart';
import '../../../common/user.dart';
import '../../../common/loading.dart';
// import 'detail.dart';

class Bill extends StatefulWidget {
  final String type;
  Bill({Key key, this.type}) : super(key: key);
  @override
  _BillState createState() => new _BillState();
}

class _BillState extends State<Bill> with TickerProviderStateMixin {
  RefreshController _controller;

  // 数据控制字段
  bool _loaded = false;                                 //界面初始化数据加载控制
  String _token;
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
    await User.getUserInfo().then((result){
        setState(() {
          _token = result[User.FIELD_TOKEN];
        });
    });
    await _fetch(page: 1).then((_){
      setState(() {
        _loaded = true;
      });
    });
    print('Bill界面数据初始化...');
  }

  // 加载数据函数
  Future _fetch({page = 1}) async {
    return Http.post(API.billList, data: {'page': page, 'account_token': _token, 'account':widget.type}).then((result){
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
      return new Column(
        children: <Widget>[
          ListTile(
            title: new Row(
              children: <Widget>[
                new Expanded(
                  flex: 1,
                  child: Text(list[index]['remark'], maxLines: 1, overflow: TextOverflow.ellipsis,),
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text((list[index]['way'] == 2 ? '+': '-') + list[index]['price']),
                )
              ],
            ),
            subtitle: new Padding(
              padding: EdgeInsets.only(top: 15),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(list[index]['createtime']),
                  list[index]['status'] == 1 ? Text('已完成', style: TextStyle(color: Colors.green),) : Text('处理中', style: TextStyle(color: Colors.orange),),
                ],
              ),
            ),
            onTap: (){
              // Navigator.of(super.context).push(
              //   new MaterialPageRoute(
              //       builder: (BuildContext context) => new BillDetail(id: list[index]['id'])),
              // );
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
          title: Text('账单明细', style: TextStyle(color: Colors.white)),
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
          enablePullUp: list.length > 0 ? true : false,
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
