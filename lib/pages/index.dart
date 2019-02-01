import 'package:flutter/material.dart';
import 'home/home.dart';
import 'browse/task.dart';
import 'release/task.dart';
import 'mine/mine.dart';
import '../config/api.dart';
import '../common/user.dart';
import '../common/http.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Index extends StatefulWidget {
  @override
  IndexState createState()  => new IndexState();
}

class IndexState extends State<Index>{
  int _currentIndex = 0;            //当前页面索引
  PageController _pageController = new PageController(initialPage: 0);
  var _pageList = <StatefulWidget>[
    new Home(),
    new RTask(),
    new BTask(),
    new Mine(),
  ];

  //初始化控件状态
  @override
    void initState(){
      super.initState();
      initData();
    }
  
  //初始化界面数据
  Future<dynamic> initData() async{
    User.isLogin().then((_){
      if(_){
        User.getAccountToken().then((token){
          // 认证并初始化会员信息
          Http.post(API.initUser, data: {'account_token': token}).then((result){
            if(result['code'] == 1){
              User.saveUserInfo(result['data']);
            }else{
              Fluttertoast.showToast(msg: '您已在其他地方登录或账号已过期', gravity: ToastGravity.CENTER);
              User.delAccountToken();
            }
          });
        });
      }
    });
  }

  Widget build(BuildContext context) {
    /*-----bottom nav start-------*/
    BottomNavigationBarItem _bottomNavigationBarItem(IconData icon, IconData activeIcon, String title, int itemIndex){
      var _bottomNavigationBarColor = Color.fromARGB(255, 166, 166, 166);
      if(_currentIndex == itemIndex){
        _bottomNavigationBarColor = Colors.green;
      }
      return BottomNavigationBarItem(icon: Icon(icon, color: _bottomNavigationBarColor), activeIcon: Icon(activeIcon, color: _bottomNavigationBarColor), title: Text(title, style: TextStyle(color: _bottomNavigationBarColor)));
    }
    BottomNavigationBar _bottomNavigationBar = BottomNavigationBar(
      items: [
        _bottomNavigationBarItem(Icons.home, Icons.home, '首页', 0),
        _bottomNavigationBarItem(Icons.view_list, Icons.filter_list, '试客任务', 1),
        _bottomNavigationBarItem(Icons.camera, Icons.camera, '浏览任务', 2),
        _bottomNavigationBarItem(Icons.person_outline, Icons.person, '我的', 3)
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      fixedColor: Colors.green,
      onTap: (index){
        setState(() {
          _currentIndex = index;      //修改当前页面索引  
          // _pageController.jumpToPage(index);
          // _pageController.animateToPage(index,
          //   duration: const Duration(milliseconds: 300), curve: Curves.ease);
        });
      },
    );
    /*-----bottom nav end-------*/
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        // body: _pageList[_currentIndex],
        // body: new PageView(
        //   children: _pageList,
        //   controller: _pageController,
        //   onPageChanged: (int index){
        //     setState(() {
        //       _currentIndex = index;      //修改当前页面索引 
        //     });
        //   }
        // ),
        body: new IndexedStack(
          index: _currentIndex,
          children: _pageList,
        ),
        bottomNavigationBar: _bottomNavigationBar,
        resizeToAvoidBottomPadding: false,
      ),
    );
    // return new MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: new Scaffold(
    //     appBar: AppBar(
    //       title: Text('sdfs'),
    //     ),
    //     bottomNavigationBar: _bottomNavigationBar,
    //     body: new IndexedStack(
    //     index: _currentIndex,
    //     children: <Widget>[
    //       new Home(),
    //       new Empty(),
    //       new Empty(),
    //       new Container(
    //         child: new TextField(
    //           decoration: InputDecoration(
    //             hintText: '这是第四个文本框'
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    //   ),
    // );
  }
}
