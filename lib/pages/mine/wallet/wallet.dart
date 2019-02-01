import 'package:flutter/material.dart';
import '../../../common/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'withdraw.dart';

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
                Icon(Icons.account_balance_wallet, color: Colors.red, size: 80,),
                Text(_title[widget.type], style: TextStyle(height: 2, fontSize: 18),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text('¥', style: TextStyle(height:1.8, fontSize: 35),),
                    Text(_money.toString(), style: TextStyle(height:1, fontSize: 55, fontWeight: FontWeight.bold),),
                  ],
                )
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
                new FractionallySizedBox(
                  widthFactor: 0.5,
                  child: new FlatButton(
                    color: Colors.green,
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    shape: RoundedRectangleBorder(
                      side: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Text('提现', style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      if(_money < 100){
                        Fluttertoast.showToast(msg: '无可提现余额', gravity: ToastGravity.CENTER);
                        return;
                      }
                      Navigator.of(super.context).push(
                        new MaterialPageRoute(
                            builder: (BuildContext context) => new Withdraw(type: widget.type,), fullscreenDialog: true),
                      ).then((_){
                        if(_ != null){
                          setState(() {
                            _money = _;
                          });
                        }
                      });
                    },
                  ),
                ) : new Container(),
                Text('请注意资金安全', style: TextStyle(color: Colors.grey, height: 3),),
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
              Navigator.pop(super.context, _money);
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