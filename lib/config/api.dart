// 数据接口URL静态对象类
// Authon Johwen

class API{
  //站点资源根目录
  static const String host = r'http://www.yeegobox.com';

  // 接口根url
  static const String apiurl = r'http://api.yeegobox.com';

  // 接口状态调试
  static const String status = apiurl + r'/auth/index.html';

  // 获取公告列表
  static const String getNoticeList = apiurl + r'';

  // 获取公告详情，必须参数：id(int)
  static const String getNoticeDetail = apiurl + r'';

  // 会员登录接口，必须参数：username(String),password(String)
  static const String login = apiurl + r'/auth/login.html';

  // 初始化会员数据接口
  static const String initUser = apiurl + r'/user/init.html';

  // 会员修改密码接口
  static const String updatePassword = apiurl + r'/user/updatePassword.html';
}