// 数据接口URL静态对象类
// Authon Johwen
class API{
  // 接口根url
  static const String host = r'http://www.yeegobox.com';

  // 获取公告列表
  static const String getNoticeList = host + r'';

  // 获取公告详情，必须参数：id(int)
  static const String getNoticeDetail = host + r'';
}