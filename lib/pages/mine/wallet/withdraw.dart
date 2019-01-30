import 'package:flutter/material.dart';
import '../../../config/api.dart';
import '../../../common/http.dart';
import '../../../common/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../common/loading.dart';

class Withdraw extends StatefulWidget{
  final String type;
  Withdraw({Key key, this.type}) : super(key: key);
  State<StatefulWidget> createState() => new WithdrawState();
}

class WithdrawState extends State<Withdraw>{
  Map _title = {'averagereward': '普通奖励', 'promotionreward': '推广奖励', 'frozencredit': '冻结学分',};
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
          _loaded = true;
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
      }else{
        Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER);
        return false;
      }
    });
  }

  @override
  Widget build(BuildContext context){
    Widget _body = new Container(
      margin: EdgeInsets.only(top: 25, left: 15, right: 15),
      child: new ListView(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.grey[50],
            ),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('招商银行（1218）', style: TextStyle(fontSize: 18),),
                    Text('2小时内到账'),
                  ],
                ),
                Icon(Icons.chevron_right, color: Colors.grey, size: 25,),
              ],
            ),
          ),
          new Container(
            padding: EdgeInsets.all(25),
            color: Colors.white,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('提现金额', style: TextStyle(fontSize: 18)),
                new Container(
                  padding: EdgeInsets.only(top: 25, bottom: 20),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey[200]))
                  ),
                  child: new Row(
                    children: <Widget>[
                      Text('¥', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),

                    ],
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(top:25, bottom: 25,),
                  child: new Row(
                    children: <Widget>[
                      Text('零钱余额¥2.00，', style: TextStyle(color: Colors.black45),),
                      new GestureDetector(
                        child: Text('全部提现', style: TextStyle(color: Colors.blue),),
                      )
                    ],
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.all(0),
                  child: FlatButton(
                    color: Colors.green,
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    child: Text('提现', style: TextStyle(color: Colors.white, fontSize: 18),),
                    shape: RoundedRectangleBorder(
                      side: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    onPressed: (){},
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          title: Text('余额提现', style: TextStyle(color: Colors.black87)),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            color: Colors.black87,
            icon: BackButtonIcon(),
            onPressed: (){
              Navigator.pop(super.context);
            },
          ),
        ),
        body: _body,
      ),
    );
  }
}