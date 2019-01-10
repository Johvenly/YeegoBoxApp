import 'package:flutter/material.dart';
import '../../../common/user.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Wallet extends StatefulWidget{
  final String type;
  Wallet({Key key, this.type}) : super(key: key);
  State<StatefulWidget> createState() => new WalletState();
}

class WalletState extends State<Wallet>{
  Map _title = {'averagereward': '普通奖励', 'promotionreward': '推广奖励', 'frozencredit': '冻结学分',};
  double _money = 0.00;

  @override
    void initState() {
      super.initState();
      User.getUserInfo().then((result){
          setState(() {
            _money = result[widget.type];
          });
        });
    }
  @override
  Widget build(BuildContext context){
    Widget _body = new Container(
      width: MediaQuery.of(context).size.width,
      child: new Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.attach_money, color: Colors.orangeAccent, size: 80,),
                Text(_title[widget.type], style: TextStyle(height: 2, fontSize: 18),),
                Text('¥' + _money.toString(), style: TextStyle(height:1, fontSize: 45, fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                (widget.type != 'frozencredit') ?
                new FlatButton(
                  color: Colors.green,
                  padding: EdgeInsets.only(left: 35, right: 35),
                  child: Text('提现', style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    if(_money <= 0){
                      Fluttertoast.showToast(msg: '无可提现余额', gravity: ToastGravity.CENTER);
                    }
                  },
                ) : new Container(),
                Text('提现底部提示信息', style: TextStyle(color: Colors.grey),),
              ],
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
          title: Text('钱包', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: BackButtonIcon(),
            onPressed: (){
              Navigator.pop(super.context);
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('明细', style: TextStyle(color: Colors.white, fontSize: 18),),
            ),
          ],
        ),
        body: _body,
      ),
    );
  }
}