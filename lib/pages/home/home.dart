import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../config/api.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new HomeState();
}

class HomeState extends State{
  // @override
  // bool get wantKeepAlive => true;

  //初始化控件状态
  @override
    void initState() {
      super.initState();
      initData().then((e){
        
      });
    }

  //初始化界面数据
  @override
  Future<dynamic> initData() async{
    await print('Home界面数据初始化...');
  }
  
  @override
  Widget build(BuildContext context){
    List _slides = <Widget>[
      Image.asset('assets/images/slide01.jpg', fit: BoxFit.cover,),
      Image.asset('assets/images/slide03.jpg', fit: BoxFit.cover,),
      Image.asset('assets/images/slide04.jpg', fit: BoxFit.cover,),
    ];
    List <Map>_notices = <Map>[
      {'id':1, 'title': '测试消息1', 'time': '2018.12.28'},
      {'id':2, 'title': '测试消息2', 'time': '2018.12.29'},
      {'id':3, 'title': '测试消息3', 'time': '2018.12.30'},
    ];
    Widget _body = new Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: new ListView(
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
          new Padding(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: new ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('12', style: TextStyle(fontSize: 20,),),
                    Text('试用报告', style: TextStyle(height: 1.5),),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('15', style: TextStyle(fontSize: 20,),),
                    Text('邀请好友', style: TextStyle(height: 1.5),),
                  ],
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
                      children: _notices.map<Widget>((Map row){
                        return new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(row['title']),
                            ),
                            Text(row['time'], style: TextStyle(color: Colors.grey),),
                          ],
                        );
                      }).toList(),
                      scrollDirection: Axis.vertical,
                      autoplay: true,
                      onTap: (index) => print('点击了第$index个'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          new Padding(
            child: new Row(
              children: <Widget>[
                Icon(Icons.track_changes, color: Colors.green, size: 16,),
                Text(' 试客任务'),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
            padding: EdgeInsets.only(top: 15, bottom: 15, left: 8, right: 8),
          ),
          new Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: new ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: IconButton(
                        icon: Image.asset('assets/images/logo_tb.jpg', fit: BoxFit.cover,),
                        iconSize:80, 
                        padding: EdgeInsets.all(0),
                      ),
                    ),
                    Text('机会：8', style: TextStyle(height: 2),),
                  ],
                ),
                Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: IconButton(
                        icon: Image.asset('assets/images/logo_jd.jpg', fit: BoxFit.cover,),
                        iconSize:80, 
                        padding: EdgeInsets.all(0),
                      ),
                    ),
                    Text('机会：10', style: TextStyle(height: 2),),
                  ],
                ),
                Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: IconButton(
                        icon: Image.asset('assets/images/logo_pdd.jpg', fit: BoxFit.cover,),
                        iconSize:80, 
                        padding: EdgeInsets.all(0),
                      ),
                    ),
                    Text('机会：5', style: TextStyle(height: 2),),
                  ],
                ),
              ],
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(left: 25, right: 25, bottom: 8),
            child: new TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                hintText: '输入您能垫付的最大金额',
                hintStyle: TextStyle(color: Colors.grey[300]),
                suffixText: '元',
                suffixStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[300])),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green),),
              ),
              cursorColor: Colors.green,
              // autofocus: true,
              focusNode: FocusNode(),
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 15, bottom: 15, left: 25, right: 25),
              child: new FlatButton(
                color: Colors.green,
                padding: EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                onPressed: () {
                  // _postLogin(
                  //     _userNameController.text, _userPassController.text);
                },
                child: Text('接受任务', style: new TextStyle(color: Colors.white, fontSize: 16.0),
              )
            ),
          ),
          Text('试用返利下单直接封号，上门要钱后果自负', style: TextStyle(fontSize: 14, color: Colors.grey), textAlign: TextAlign.center,),
          new Container(
            padding: EdgeInsets.only(top: 8),
            margin: EdgeInsets.only(top: 15),
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
                  Text('（机会：0）', style: TextStyle(color: Colors.grey),),
                ],
              ),
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 25, bottom: 25, left: 25, right: 25),
              child: new FlatButton(
                color: Colors.green,
                padding: EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                onPressed: () {
                  // _postLogin(
                  //     _userNameController.text, _userPassController.text);
                },
                child: Text('接受任务', style: new TextStyle(color: Colors.white, fontSize: 16.0),
              )
            ),
          ),
        ],
      ),
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

              },
            ),
          ],
        ),
        body: _body,
      ),
    );
  }
}