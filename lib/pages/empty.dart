import 'package:flutter/material.dart';
class Empty extends StatefulWidget{
  State<StatefulWidget> createState() => new EmptyState();
}

class EmptyState extends State{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('空的', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: BackButtonIcon(),
            onPressed: (){
              Navigator.pop(super.context);
            },
          ),
        ),
        // body: new FocusScope(),
      ),
    );
  }
}