import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../config/api.dart';
import '../../../common/http.dart';
import '../../../common/user.dart';
import '../../../common/loading.dart';
import 'bind.dart';

class BankList extends StatefulWidget{
  State<StatefulWidget> createState() => new BankListState();
}

class BankListState extends State with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  //数据控制字段
  bool _loaded = false;
  List list = new List();                               //列表数据
  String _token;
  Widget _emptyWight = new LoadingView();               //空的加载Widget

  @override
    void initState() {
      super.initState();
      initData().then((_){
        setState((){
          if(list.length > 0){
            _loaded = true;
          }else{
            _emptyWight = LoadingView.finished(title: '无有效银行卡');
          }
        });
      });
    }

  Future<dynamic> initData() async {
    await User.isLogin().then((_) async{
      if(_){
        await User.getAccountToken().then((token) async{
          setState(() {
            _token = token;
          });
        });
      }
    });
    await Http.post(API.getBankList, data:{'account_token': _token}).then((result){
      if(result['code'] == 1){
        setState(() {
          list = result['data'];
        });
        return true;
      }
    });
    print('BankList初始化');
  }

  @override
  Widget build(BuildContext context){
    Widget _body = !_loaded ? new LoadingView() : new ListView(
      padding: EdgeInsets.only(top: 15),
      children: list.map<Widget>((row){
        return new Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            new Container(
              width: MediaQuery.of(context).size.width - 30,
              alignment: AlignmentDirectional.centerStart,
              padding: EdgeInsets.all(25),
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(row['membankname'], style: TextStyle(fontSize: 20, color: Colors.white),),
                  Text(row['membankaddress'], style: TextStyle(color: Colors.white, height: 1.2),),
                  Text(row['membankcard'], style: TextStyle(fontSize: 24, color: Colors.white, height: 1.5),),
                ],
              ),
            ),
            new Positioned(
              width: 32,
              height: 32,
              top: 0,
              right: 23,
              child: IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.white70,),
                onPressed: (){
                  int index = list.indexOf(row);
                  Http.post(API.delBank, data:{'account_token': _token, 'id': row['id']}).then((result){
                    if(result['code'] == 1){
                      Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER).then((_){
                        setState(() {
                          list.removeAt(index);
                        });
                      });
                      return true;
                    }else{
                      Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER);
                      return false;
                    }
                  });
                },
              ),
            )
          ],
        );
      }).toList(),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('收款银行卡'),
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: BackButtonIcon(),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add, color: Colors.white,),
              onPressed: (){
                Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new BankBind(), fullscreenDialog: true),
                ).then((row){
                  if(row != null){
                    setState(() {
                      list.add(row);
                    });
                  }
                  print(list);
                });
              },
            )
          ],
        ),
        body: !_loaded ? _emptyWight :_body,
      ),
    );
  }
}