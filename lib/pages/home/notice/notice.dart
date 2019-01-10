import 'package:flutter/material.dart';
import '../../../config/api.dart';
import '../../../common/http.dart';
import '../../../common/loading.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Notice extends StatefulWidget{
  State<StatefulWidget> createState() => new NoticeState();
}

class NoticeState extends State{
  //数据控制字段
  bool _loaded = false;              //界面初始化数据加载控制

  //列表要展示的数据
  List list = new List();
  ScrollController _scrollController = ScrollController(); //listview的控制器
  int _page = 1; //加载的页数
  bool isLoading = false; //是否正在加载数据
  bool isStop = false; //是否已停止加载数据（无更多数据）

  @override
    void initState() {
      super.initState();
      initData().then((_){
        setState(() {
          _loaded = true;
        });
      });

      // 上拉动作监听
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
           _scrollController.position.maxScrollExtent) {
          print('滑动到了最底部');
          _getMore();
        }
      });
    }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  //初始化界面数据
  Future<dynamic> initData() async{
    _getData(page: 1);
    print('Notice界面数据初始化...');
  }

  // 下拉刷新数据
  Future<dynamic> _onRefresh() async{
    if (!isLoading) {
      setState(() {
        isStop = false;
        isLoading = true;
      });
      _getData(page: 1).then((_){
        Fluttertoast.showToast(msg: '已重新刷新数据', gravity: ToastGravity.CENTER, backgroundColor: Colors.black54);
      });
    }
    print('Notice正在刷新数据...');
  }

  // 上拉获取/加载数据
  Future _getMore() async {
    if (!isLoading && !isStop) {
      setState(() {
        isLoading = true;
      });
      _getData(page: _page);
    }
    print('Notice正在加载更多数据...');
  }

  // 获取/加载远程数据
  Future _getData({page = 1}) async {
    Http.post(API.getNoticeList, data: {'page': page}).then((result){
      if(result['code'] == 1){
        setState(() {
          _page = page + 1;
          isLoading = false;
          if(page == 1){
            list = result['data'];
          }else{
            list.addAll(result['data']);
          }
        });
        if(result['data'].length < result['pageach']){
          setState(() {
            isStop = true;
          });
        }
      }else{
        setState(() {
          isStop = true;
        });
      }
    });
  }


  // 列表单条记录Widget
  Widget _renderRow(BuildContext context, int index) {
    if (index < list.length) {
      return new Column(
        children: <Widget>[
          ListTile(
            title: Text(list[index]['name'] , maxLines: 1, overflow: TextOverflow.ellipsis,),
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
              print('点击了$index个列表');
            },
          ),
          new Divider(indent: 15, color: Colors.grey[300],),
        ],
      );
    }
    return isStop ? LoadingView.finished(title: '我也是有底线的') : LoadingView.more();
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
        body: !_loaded ? new LoadingView() : RefreshIndicator(
          color: Colors.white,
          backgroundColor: Colors.green,
          onRefresh: _onRefresh,
          child: ListView.builder(
            padding: EdgeInsets.only(top: 8),
            itemBuilder: _renderRow,
            itemCount: list.length + 1,
            controller: _scrollController,
          ),
        ),
      ),
    );
  }
}