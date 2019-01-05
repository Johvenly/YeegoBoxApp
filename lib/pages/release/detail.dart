import 'package:flutter/material.dart';

class Detail extends StatefulWidget{
  final int id;
  Detail({Key key, this.id}) : super(key: key);

  State<StatefulWidget> createState() => new DetailState();
}

class DetailState extends State<Detail> with TickerProviderStateMixin {
  //初始化页面数据
  Map pageRowData = new Map();

  @override
  void initState() {
    super.initState();
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
            background: Image.asset('assets/images/slide04.jpg', fit: BoxFit.cover,),
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

    Widget _body = new Container(
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
                      Text('关键词'.toString(), style: TextStyle(color: Colors.grey,),),
                      Text('官方正品保证，支持七天无理由退换'),
                    ],
                  ),
                ),
                new Divider(),
                new Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('任务编号'.toString(), style: TextStyle(color: Colors.grey,),),
                      Text('201886522679642578'),
                    ],
                  ),
                ),
                new Divider(),
                new Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('任务类型'.toString(), style: TextStyle(color: Colors.grey,),),
                      Text('淘宝自然搜索'),
                    ],
                  ),
                ),
                new Divider(),
                new Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('商家QQ'.toString(), style: TextStyle(color: Colors.grey,),),
                      Text('1973509397'),
                    ],
                  ),
                ),
                new Divider(),
                new Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('商家电话'.toString(), style: TextStyle(color: Colors.grey,),),
                      Text('18218830556'),
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
                Text('历史记录及我诶离开手机打开手机陆金所了解睡懒觉历史记录及时的了解善良的加拉加斯老家的了解了无诶收到了减少了空间的离开手机来看及时的空间上课记得老师讲老司机老司机', style: TextStyle(height: 1.2,), maxLines: 5, overflow: TextOverflow.ellipsis,),
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
                  child: Text('店铺名称：谢****店', style:TextStyle(color: Colors.red)),
                ),
                new Divider(),
                new Padding(
                  padding: EdgeInsets.only(right: 15, bottom: 8, top: 8),
                  child: new TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                      hintText: '注意店铺名称可能有空格或大写',
                      hintStyle: TextStyle(color: Colors.grey[300]),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[300])),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green),),
                    ),
                    cursorColor: Colors.green,
                  ),
                ),
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
                        onPressed: (){},
                      ),
                    ],
                  ),
                ),
                new Divider(),
                Text('''接单提醒一:\r\n接单提醒二:\r\n接单提醒三:''', style: TextStyle(height: 1.2, color: Colors.grey),),
              ],
            ),
          ),

          //按钮组
          new Padding(
            padding: EdgeInsets.only(top: 25, left: 15, right: 15),
            child: new FlatButton(
              color: Colors.green,
              padding: EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              onPressed: () {

              },
              child: Text('提交审核', style: new TextStyle(color: Colors.white, fontSize: 16.0),)
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 8, left: 15, right: 15),
            child: new FlatButton(
              color: Colors.red,
              padding: EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              onPressed: () {

              },
              child: Text('取消任务', style: new TextStyle(color: Colors.white, fontSize: 16.0),)
            ),
          ),
        ],
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: _sliverBuilder,
          body: _body,
        ),
      ),
    );
  }
}