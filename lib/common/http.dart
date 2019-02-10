// Http请求类
// Authon Johwen
import 'dart:convert';
import 'package:dio/dio.dart';

class Http{

  //Post请求方法
  static Future<dynamic> post(String url, {Map<String, dynamic> data}) async{
    Dio dio = new Dio();
    try {
      Response response = await dio.post(url ,data: data);      //发起请求
      if(response.statusCode == 200){
        return jsonDecode(response.data);  
      }else{
        print(response.statusCode);
        return {'code': 0, 'msg': '网络发生错误'};
      }                       //返回结果
    } on DioError catch(e) {
        print(e);
    }
  }
}