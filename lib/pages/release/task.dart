import 'package:flutter/material.dart';
import 'detail.dart';

class RTask extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new RTaskState();
}

class RTaskState extends State with AutomaticKeepAliveClientMixin,SingleTickerProviderStateMixin{
  @override
  bool get wantKeepAlive => true;

  TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  // 任务列表
  List _taskList = <Map>[
    {'id': 1, 'score': 8, 'time': '2018.10.12 16:18', 'status': '进行中', 'class': '拼多多', 'number': '201812134538732987'},
    {'id': 2, 'score': 5, 'time': '2018.10.02 05:34', 'status': '待审核', 'class': '京东', 'number': '201810024438473672'},
    {'id': 3, 'score': 6, 'time': '2018.09.12 23:21', 'status': '待审核', 'class': '淘宝', 'number': '201809124837584943'},
    {'id': 4, 'score': 12, 'time': '2018.08.09 14:56', 'status': '待审核', 'class': '淘宝', 'number': '201809124837584943'},
    {'id': 5, 'score': 3, 'time': '2018.08.01 09:13', 'status': '待审核', 'class': '淘宝', 'number': '201809124837584943'},
    {'id': 6, 'score': 6, 'time': '2018.07.30 23:21', 'status': '待审核', 'class': '淘宝', 'number': '201809124837584943'},
  ];

  List _rowList = <Map>[
    {'id': 8, 'score': 12, 'time': '2018.12.10 16:18', 'status': '已完成', 'class': '拼多多', 'number': '201812223838284432'},
    {'id': 9, 'score': 20, 'time': '2018.10.02 05:34', 'status': '已完成', 'class': '京东', 'number': '201810024438473672'},
    {'id': 11, 'score': 14, 'time': '2018.09.12 23:21', 'status': '已完成', 'class': '淘宝', 'number': '201809124837584943'},
    {'id': 12, 'score': 15, 'time': '2018.08.09 14:56', 'status': '已完成', 'class': '淘宝', 'number': '201809124837584943'},
    {'id': 13, 'score': 3, 'time': '2018.08.01 09:13', 'status': '已完成', 'class': '淘宝', 'number': '201809124837584943'},
    {'id': 18, 'score': 9, 'time': '2018.07.30 23:21', 'status': '已完成', 'class': '淘宝', 'number': '201809124837584943'},
  ];
  
  @override
  Widget build(BuildContext context){
    Widget _li(Map row){
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
                    Text('学分' + row['score'].toString()),
                    Text(row['time'], style: TextStyle(color: Colors.grey),),
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
                          Text(row['status'], style: TextStyle(color: row['status'] == '已完成' ? Colors.green : Colors.orange),),
                        ],
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('试用平台'),
                          Text(row['class'], style: TextStyle(color: Colors.grey),),
                        ],
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('任务编号'),
                          Text(row['number'], style: TextStyle(color: Colors.grey),),
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
                builder: (BuildContext context) => new Detail(id: row['id'])),
          );
        },
      );
    }
    Widget _body = new Container(
      child: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          // 任务列表View
          new ListView.builder(
            padding: EdgeInsets.only(top: 8),
            itemCount: _taskList.length,
            itemBuilder: (BuildContext context, int index){
              return _li(_taskList[index]);
            },
          ),
          new ListView.builder(
            padding: EdgeInsets.only(top: 8),
            itemCount: _taskList.length,
            itemBuilder: (BuildContext context, int index){
              return _li(_rowList[index]);
            },
          ),
        ],
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.green,
          title: Text('试客任务'),
          bottom: new TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(text: '任务',),
              Tab(text: '记录',),
            ],
          ),
        ),
        body: _body,
      ),
    );
  }
}