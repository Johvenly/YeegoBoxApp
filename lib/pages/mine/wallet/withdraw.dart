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
  double _money = 0.00;
  TextEditingController _moneyController = new TextEditingController();
  int bankIndex;

  @override
    void initState() {
      super.initState();
      initData().then((_){
        setState((){
          _loaded = true;
          if(list.length > 0){
            bankIndex = 0;
          }
        });
      });
    }

  Future<dynamic> initData() async {
    await User.getUserInfo().then((result){
      setState(() {
        _token = result[User.FIELD_TOKEN];
        _money = result[widget.type];
      });
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
          new GestureDetector(
            child: new Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.grey[50],
              ),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  bankIndex != null ?
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(list[bankIndex]['membankname'] + '（'+ list[bankIndex]['tailnumber'] +'）', style: TextStyle(fontSize: 18),),
                      Text('2小时内到账'),
                    ],
                  ) : Text('请选择提现银行卡', style: TextStyle(fontSize: 18),),
                  Icon(Icons.chevron_right, color: Colors.grey, size: 25,),
                ],
              ),
            ),
            onTap: (){
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context){
                  return new GestureDetector(
                    onTap: (){return false;},
                    child: Container(
                      color: Colors.white,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new FractionallySizedBox(
                            widthFactor: 1,
                            child: new Stack(
                              alignment: AlignmentDirectional.center,
                              children: <Widget>[
                                new Column(children: <Widget>[
                                  Text('选择到账银行卡', style: TextStyle(color: Colors.black, fontSize: 22, height: 1.8),),
                                  Text('请留意各银行到账时间', style: TextStyle(fontSize: 14, color: Colors.grey),)
                                ],),
                                new Positioned(
                                  width: 32,
                                  height: 32,
                                  left: 8,
                                  top: 15,
                                  child: IconButton(
                                    icon: Icon(Icons.close, color: Colors.grey,),
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                  )
                                ),
                              ],
                            ),
                          ),
                          new Divider(height: 35,),
                          new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: list.map<Widget>((row){
                              return new Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new FractionallySizedBox(
                                      widthFactor: 1,
                                      child: new GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        child: new Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(row['membankname'] + ' 储蓄卡 （'+ row['tailnumber'] +'）', style: TextStyle(fontSize: 20),),
                                            Text('明天24点前到账', style: TextStyle(fontSize: 14, color: Colors.grey),)
                                          ],
                                        ),
                                        onTap: (){
                                          Navigator.pop(context, list.indexOf(row));
                                          print('点击了');
                                        },
                                      ),
                                    ),
                                    new Divider(height: 35,)
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          new GestureDetector(
                            child: new Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text('使用新卡提现', style: TextStyle(fontSize: 20,),),
                            ),
                          ),
                          new Divider(height: 35,)
                        ],
                      ),
                    ),
                  );
                },
              ).then((index){
                if(index != null){
                  setState(() {
                    bankIndex = index;
                  });
                }
              });
            },
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
                      Expanded(
                        child: TextField(
                          controller: _moneyController,
                          decoration: InputDecoration(
                            hintText: '请输入提现金额',
                            hintStyle: TextStyle(fontSize: 25, color: Colors.grey[300]),
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 8),
                          ),
                          autofocus: true,
                          cursorColor: Colors.green,
                          style: TextStyle(fontSize: 30),
                          keyboardType: TextInputType.number,
                        ),
                      )
                    ],
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(top:25, bottom: 25,),
                  child: new Row(
                    children: <Widget>[
                      Text('零钱余额¥'+ _money.toString() +'，', style: TextStyle(color: Colors.black45),),
                      new GestureDetector(
                        child: Text('全部提现', style: TextStyle(color: Colors.blue),),
                        onTap: (){
                          _moneyController.text = (_money - (_money % 100)).toString();
                        },
                      )
                    ],
                  ),
                ),
                new FractionallySizedBox(
                  widthFactor: 1,
                  child: new FlatButton(
                    color: Colors.green,
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    child: Text('提现', style: TextStyle(color: Colors.white, fontSize: 18),),
                    shape: RoundedRectangleBorder(
                      side: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    onPressed: (){
                      if(bankIndex == null){
                        Fluttertoast.showToast(msg: '请先选择提现银行卡', gravity: ToastGravity.CENTER);
                        return;
                      }
                      if(double.parse(_moneyController.text) % 100 != 0){
                        Fluttertoast.showToast(msg: '金额请输入100的整数倍', gravity: ToastGravity.CENTER);
                        return;
                      }
                      Http.post(API.withdraw, data:{'account_token': _token, 'account': widget.type, 'price': _moneyController.text, 'bankid': list[bankIndex]['id']}).then((result){
                        Fluttertoast.showToast(msg: result['msg'], gravity: ToastGravity.CENTER);
                        if(result['code'] == 1){
                          print(result['resum']);
                          Navigator.pop(context, result['resum'].toDouble());
                        }
                      });
                    },
                  ),
                ),
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
            icon: Icon(Icons.close),
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