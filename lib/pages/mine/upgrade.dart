import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import '../../config/api.dart';
import '../../common/http.dart';
import '../../common/loading.dart';
import 'package:device_info/device_info.dart';

class Upgrade extends StatefulWidget{
  State<StatefulWidget> createState() => new UpgradeState();
}

class UpgradeState extends State with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  //数据控制字段
  bool _loaded = false;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    initData().then((_){
      setState(() {
        _loaded = true;
      });
      print(_deviceData);
    });
  }

  Future<dynamic> initData() async {
    await initPlatformState();
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = new Map();

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo build = await deviceInfoPlugin.androidInfo;
        deviceData['device'] = 'Android';
      } else if (Platform.isIOS) {
        IosDeviceInfo data = await deviceInfoPlugin.iosInfo;
        deviceData['device'] = 'IOS';
        deviceData['version'] = data.systemVersion;
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    print(Platform.version);

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('检查更新', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: BackButtonIcon(),
            onPressed: (){
              Navigator.pop(super.context);
            },
          ),
        ),
        body: new ListView(
          padding: EdgeInsets.only(top: 15),
          children: <Widget>[
            Icon(Icons.refresh, size: 80, color: Colors.grey,),
            Text(_deviceData['version'] ?? '', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 18),),
          ],
        ),
      ),
    );
  }
}