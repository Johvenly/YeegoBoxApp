import 'package:flutter/material.dart';

class BTask extends StatefulWidget{
  State<StatefulWidget> createState() => new BTaskState();
}

class BTaskState extends State with SingleTickerProviderStateMixin{
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
  
  @override
  Widget build(BuildContext context){
    Widget _body = new Container(
      child: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          new Center(
            child: Text('无数据'),
          ),
          new Center(
            child: Text('无数据2'),
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
          title: Text('浏览任务'),
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