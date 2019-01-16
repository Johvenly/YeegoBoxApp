import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../config/api.dart';
import '../../../common/http.dart';
import '../../../common/user.dart';
import '../../../common/loading.dart';

class BankList extends StatefulWidget{
  State<StatefulWidget> createState() => new BankListState();
}

class BankListState extends State with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  //数据控制字段
  bool _loaded = false;
  List list = new List();                               //列表数据

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

  }

  @override
  Widget build(BuildContext context){
    Widget _body = !_loaded ? new LoadingView() : new ListView(
      padding: EdgeInsets.only(top: 15),
      children: <Widget>[
        new Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            new Container(
              width: MediaQuery.of(context).size.width - 30,
              alignment: AlignmentDirectional.centerStart,
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('中国农业银行', style: TextStyle(fontSize: 20, color: Colors.white),),
                  Text('福利支行', style: TextStyle(color: Colors.white, height: 1.2),),
                  Text('622 **** **** **** 4479', style: TextStyle(fontSize: 24, color: Colors.white, height: 1.5),),
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

                },
              ),
            )
          ],
        ),
      ],
    );

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('收款银行卡'),
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add, color: Colors.white,),
              onPressed: (){

              },
            )
          ],
        ),
        body: _body,
      );
  }
}