import 'package:flutter/material.dart';
import '../../../config/api.dart';
import '../../../common/loading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:cached_network_image/cached_network_image.dart';

class Explain extends StatefulWidget{
  final Map row;
  Explain({Key key, this.row}): super(key: key);
  State<StatefulWidget> createState() => new ExplainState();
}

class ExplainState extends State<Explain>{
  //数据控制字段
  Map row = new Map();                  //记录数据

  @override
    void initState() {
      super.initState();
    }

  @override
  Widget build(BuildContext context){
    Widget _body = new Container(
      color: Colors.white,
      child: new ListView(
        padding: EdgeInsets.only(top: 8),
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.all(0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                (!widget.row.containsKey('check_explain') || widget.row['check_explain'].isEmpty) ? LoadingView.finished(title: '内容为空') : Html(
                  data: widget.row['check_explain'] ?? '',
                  padding: EdgeInsets.only(top: 15),
                  // backgroundColor: Colors.blue,
                  customRender: (node, children) {
                    if(node is dom.Element) {
                      switch(node.localName) {
                        case "img": 
                          return new Center(
                            child: new CachedNetworkImage(
                              imageUrl: API.host + node.attributes['src'],
                              fit: BoxFit.cover,
                              fadeInDuration: Duration(seconds: 2),
                              placeholder: Image.asset('assets/images/placeholder.jpg', fit: BoxFit.cover,),
                            ),
                          );
                      }
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          title: Text(widget.row['name'] + '示例照片', style: TextStyle(color: Colors.black45)),
          backgroundColor: Colors.white,
          leading: IconButton(
            color: Colors.black54,
            icon: Icon(Icons.close),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
        body: _body,
      ),
    );
  }
}