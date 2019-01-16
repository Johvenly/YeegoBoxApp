import 'package:flutter/material.dart';
import '../../../config/api.dart';
import '../../../common/http.dart';
import '../../../common/loading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class NoticeDetail extends StatefulWidget{
  final int id;
  NoticeDetail({Key key, this.id}): super(key: key);
  State<StatefulWidget> createState() => new NoticeDetailState();
}

class NoticeDetailState extends State<NoticeDetail>{
  //数据控制字段
  Map row = new Map();                  //记录数据
  bool _loaded = false;              //界面初始化数据加载控制
  Widget _assWidget = new LoadingView();          //主Body显示前的Widget

  @override
    void initState() {
      super.initState();
      initData().then((_){
        setState(() {
          if(row.length > 0){
            _loaded = true;
          }else{
            _assWidget = LoadingView.finished(title: '无有效数据', icon: new Icon(Icons.cloud_off, size: 80, color: Colors.grey,));
          }
        });
      });
    }

  Future<dynamic> initData() async{
    await Http.post(API.getNoticeDetail, data: {'id': widget.id}).then((result){
      if(result['code'] == 1){
        setState(() {
          row = result['data'];
        });
      }else{
        Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER);
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context){
    Widget _body = new Container(
      color: Colors.white,
      child: new ListView(
        padding: EdgeInsets.only(left: 15, right: 15),
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(top: 20, bottom: 15),
            child: new Text(row['name'] ?? '', style: TextStyle(fontSize: 18),),
          ),
          new Padding(
            padding: EdgeInsets.all(0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(row['classname'] ?? '', style: TextStyle(color: Colors.black87),),
                Text((row['createtime'] ?? '') + ' · ' + (row['raadnum'].toString() ?? '') + '人浏览', style: TextStyle(color: Colors.grey, fontSize: 12),),
                (!row.containsKey('content') || row['content'].isEmpty) ? LoadingView.finished(title: '内容为空') : Html(
                  data: row['content'] ?? '',
                  padding: EdgeInsets.only(top: 15),
                  // backgroundColor: Colors.blue,
                  customRender: (node, children) {
                    if(node is dom.Element) {
                      switch(node.localName) {
                        case "img": 
                          return new Center(
                            child: new FadeInImage.assetNetwork(
                              image: API.host + node.attributes['src'],
                              fit: BoxFit.cover,
                              fadeInDuration: Duration(seconds: 2),
                              placeholder: 'assets/images/placeholder.jpg',
                              placeholderScale: 3,
                            ),
                          );
                      }
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          title: Text('公告详情', style: TextStyle(color: Colors.black45)),
          backgroundColor: Colors.white,
          leading: IconButton(
            color: Colors.black54,
            icon: BackButtonIcon(),
            onPressed: (){
              Navigator.pop(super.context);
            },
          ),
          actions: <Widget>[
            IconButton(
              color: Colors.black54,
              icon: Icon(Icons.more_horiz),
              onPressed: (){},
            ),
          ],
        ),
        body: !_loaded ? _assWidget : _body,
      ),
    );
  }
}