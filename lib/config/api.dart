// 数据接口URL静态对象类
// Authon Johwen

class API{
  //站点资源根目录
  static const String host = r'http://www.yeegobox.cn';

  // 接口根url
  static const String apiurl = r'http://api.yeegobox.com';

  // 接口状态调试
  static const String status = apiurl + r'/auth/index.html';

  // 获取公告列表，必须参数：page(int)
  static const String getNoticeList = apiurl + r'/notice/index.html';

  // 获取公告详情，必须参数：id(int)
  static const String getNoticeDetail = apiurl + r'/notice/detail.html';

  // 会员登录接口，必须参数：username(String),password(String)
  static const String login = apiurl + r'/auth/login.html';

  // 初始化会员数据接口
  static const String initUser = apiurl + r'/user/init.html';

  // 会员修改密码接口
  static const String updatePassword = apiurl + r'/user/updatePassword.html';

  // 试用任务数量接口，必须参数：account_token(String)，
  static const String getReleaseCount = apiurl + r'/release/count.html';

  // 试用任务列表接口，必须参数：account_token(String)，
  static const String getReleaseList = apiurl + r'/release/index.html';

  // 获取试用任务接口，必须参数：classid(int),account_token(String)，可选参数：price(int)
  static const String getRelease = apiurl + r'/release/get.html';

  // 试用任务详情接口，必须参数：id(int),account_token(String)
  static const String getReleaseDetail = apiurl + r'/release/detail.html';

  // 取消试用任务接口，必须参数：id(int),account_token(String)
  static const String cancelRelease  = apiurl + r'/release/cancel.html';

  // 验证试用任务接口，必须参数：id(int),account_token(String),shopname(String)
  static const String checkRelease  = apiurl + r'/release/check.html';
}