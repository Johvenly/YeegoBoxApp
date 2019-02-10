// 数据接口URL静态对象类
// Authon Johwen

class API{
  //站点资源根目录
  static const String host = r'http://www.yeegobox.com';

  // 接口根url
  static const String apiurl = r'http://api.yeegobox.com';

  // 接口状态调试
  static const String status = apiurl + r'/auth/index.html';

  // 获取公告列表，必须参数：page(int)
  static const String getNoticeList = apiurl + r'/notice/index.html';

  // 获取公告详情，必须参数：id(int)
  static const String getNoticeDetail = apiurl + r'/notice/detail.html';

  // 获取轮播图插件
  static const String getSlideShow = apiurl + r'/home/slideshow.html';

  // 会员登录接口，必须参数：username(String),password(String)
  static const String login = apiurl + r'/auth/login.html';

  // 会员注册接口，必须参数：step(int), 表单列表
  static const String register = apiurl + r'/auth/register.html';

  // 发送短信验证码接口
  static const String sendMessage = apiurl + r'/auth/sendMessage.html';

  // 获取省份列表
  static const String getProvinces = apiurl + r'/auth/getProvinces.html';

  // 上次注册身份照片
  static const String uploadPhoto = apiurl + r'/auth/uploadPhoto.html';

  // 初始化会员数据接口
  static const String initUser = apiurl + r'/user/init.html';

  // 初始化会员数据接口
  static const String subUser = apiurl + r'/user/sub.html';

  // 上传头像接口
  static const String uploadAvatar = apiurl + r'/user/avatar.html';

  // 提交身份认证信息，必要参数：account_token(String), type(String)
  static const String truecheck = apiurl + r'/user/truecheck.html';

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

  // 浏览任务数量接口，必须参数：account_token(String)，
  static const String getBrowseCount = apiurl + r'/browse/count.html';

  // 浏览任务列表接口，必须参数：account_token(String)，
  static const String getBrowseList = apiurl + r'/browse/index.html';

  // 获取浏览任务接口，必须参数：classid(int),account_token(String)，可选参数：price(int)
  static const String getBrowse = apiurl + r'/browse/get.html';

  // 浏览任务详情接口，必须参数：id(int),account_token(String)
  static const String getBrowseDetail = apiurl + r'/browse/detail.html';

  // 取消浏览任务接口，必须参数：id(int),account_token(String)
  static const String cancelBrowse  = apiurl + r'/browse/cancel.html';

  // 验证浏览任务接口，必须参数：id(int),account_token(String),shopname(String)
  static const String checkBrowse  = apiurl + r'/browse/check.html';

  // 获取银行卡列表接口
  static const String getBankList = apiurl + r'/wallet/banklist.html';

  // 绑定银行卡接口
  static const String bindBank = apiurl + r'/wallet/bindbank.html';

  // 删除银行卡接口
  static const String delBank = apiurl + r'/wallet/delbank.html';

  // 提现接口
  static const String withdraw = apiurl + r'/wallet/withdraw.html';

  // 获取会员第三方账号绑定详情
  static const String memberProof = apiurl + r'/proof/index.html';

  // 获取会员第三方账号绑定字段
  static const String proofFields = apiurl + r'/proof/field.html';

  // 上传认证凭据接口
  static const String uploadProofImage = apiurl + r'/proof/uploadImage.html';

  // 提交绑定数据
  static const String proofBind = apiurl + r'/proof/bind.html';
}