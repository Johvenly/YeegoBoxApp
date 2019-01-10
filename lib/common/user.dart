import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_bus/event_bus.dart';
class User{

  static const String FIELD_TOKEN = 'token';
  static const String FIELD_MOBILE = 'mobile';
  static const String FIELD_AVATAR = 'avatar';
  static const String FIELD_AVERAGEREWARD = 'averagereward';        //普通奖励
  static const String FIELD_PROMOTIONREWARD = 'promotionreward';    //推广奖励
  static const String FIELD_FROZENCREDIT = 'frozencredit';          //冻结学分

  //登录后缓存用户信息
  static Future<dynamic> saveUserInfo(Map row) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(FIELD_TOKEN, row[FIELD_TOKEN]);
    prefs.setString(FIELD_MOBILE, row[FIELD_MOBILE]);
    prefs.setString(FIELD_AVATAR, row[FIELD_AVATAR]);
    prefs.setDouble(FIELD_AVERAGEREWARD, double.parse(row[FIELD_AVERAGEREWARD]));
    prefs.setDouble(FIELD_PROMOTIONREWARD, double.parse(row[FIELD_PROMOTIONREWARD]));
    prefs.setDouble(FIELD_FROZENCREDIT, double.parse(row[FIELD_FROZENCREDIT]));
    return true;
  }

  //获取缓存用户信息
  static Future<Map> getUserInfo() async {
    Map<String, dynamic> result = new Map();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    result[FIELD_TOKEN] = prefs.getString(FIELD_TOKEN);
    result[FIELD_MOBILE] = prefs.getString(FIELD_MOBILE);
    result[FIELD_AVATAR] = prefs.getString(FIELD_AVATAR);
    result[FIELD_AVERAGEREWARD] = prefs.getDouble(FIELD_AVERAGEREWARD);
    result[FIELD_PROMOTIONREWARD] = prefs.getDouble(FIELD_PROMOTIONREWARD);
    result[FIELD_FROZENCREDIT] = prefs.getDouble(FIELD_FROZENCREDIT);
    return result;
  }

  //获取登录Token方法
  static Future<String> getAccountToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    return token;
  }

  //删除登录Token方法
  static Future<dynamic> delAccountToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    return true;
  }

  //判断是否登录
  static Future<bool> isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if(token != null){
      return true;
    }else{
      return false;
    }
  }
}

class UserEvent{ 
  static EventBus eventBus = new EventBus();
}