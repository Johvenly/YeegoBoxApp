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
      return jsonDecode(response.data);                         //返回结果
    } on DioError catch(e) {
        print(e);
    }
  }
}