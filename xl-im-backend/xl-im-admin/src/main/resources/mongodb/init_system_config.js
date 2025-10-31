// MongoDB 系统配置初始化脚本
// 使用方法: mongo xl_im < init_system_config.js
// 或在MongoDB Shell中: use xl_im; load("init_system_config.js");

// 切换到xl_im数据库
db = db.getSiblingDB('xl_im');

// 清空现有配置（可选，首次初始化可保留）
// db.system_config.deleteMany({});

// 插入默认系统配置
db.system_config.insertOne({
  _id: "default_config",
  // 基本设置
  title: "XL即时通讯系统",
  sysName: "XL-IM",
  sysVersion: "1.0.0",
  companyName: "XL科技有限公司",
  copyright: "Copyright © 2024 XL Tech. All rights reserved.",
  companyCode: "XLTECH",
  companyAddress: "中国广东省深圳市南山区科技园",
  companyContacts: "张经理",
  companyTelePhone: "0755-12345678",
  companyEmail: "contact@xl.com",
  sysDescription: "企业级即时通讯管理系统，提供聊天、群组、文件传输等功能",
  
  // 图标配置
  loginIcon: "/resource/img/logo.png",
  logoIcon: "/resource/img/logo.png",
  appIcon: "/resource/img/logo.png",
  navigationIcon: "/resource/img/logo.png",
  workLogoIcon: "/resource/img/logo.png",
  
  // 安全设置
  singleLogin: 0,                    // 登录方式：0-允许多端登录, 1-单端登录
  tokenTimeout: 120,                 // 超时登出(分钟)
  passwordErrorsNumber: 5,           // 密码错误次数限制
  whitelistSwitch: false,            // 白名单开关
  whiteListIp: "",                   // 白名单IP，多个用逗号分隔
  
  // 密码策略
  passwordStrengthLimit: 2,          // 密码强度限制：1-低, 2-中, 3-高
  passwordLengthMin: 6,              // 最小长度
  passwordLengthMax: 20,             // 最大长度
  containsNumbers: true,             // 必须包含数字
  includeLowercaseLetters: true,     // 必须包含小写字母
  includeUppercaseLetters: false,    // 必须包含大写字母
  containsCharacters: false,         // 必须包含特殊字符
  
  // 新用户设置
  newUserDefaultPassword: "123456",  // 新用户默认密码
  
  // 界面设置
  defaultView: "classic",            // 默认视图：classic-经典, modern-现代
  showLunarCalendar: false,          // 显示农历
  firstDay: 1,                       // 一周第一天：0-周日, 1-周一
  duration: 2,                       // 动画持续时间(秒)
  
  // 其他设置
  youyiDomain: "",                   // 域名配置
  enableRegister: false,             // 是否开放注册
  enableEmailLogin: true,            // 是否允许邮箱登录
  enablePhoneLogin: true,            // 是否允许手机号登录
  
  // 第三方登录配置
  enableWechat: false,               // 是否启用微信登录
  enableDingtalk: false,             // 是否启用钉钉登录
  enableQywechat: false,             // 是否启用企业微信登录
  
  // 文件上传配置
  maxFileSize: 10,                   // 最大文件大小(MB)
  allowedFileTypes: "jpg,jpeg,png,gif,pdf,doc,docx,xls,xlsx,zip,rar", // 允许的文件类型
  
  // 系统功能开关
  enableIM: true,                    // 是否启用即时通讯功能
  enableWorkflow: false,             // 是否启用工作流功能
  enableNotice: true,                // 是否启用通知公告
  
  // 创建和更新时间
  createTime: new Date(),
  updateTime: new Date()
});

print("系统配置初始化完成！");

// 查询验证
var config = db.system_config.findOne({_id: "default_config"});
if (config) {
  print("配置信息：");
  print("系统名称：" + config.sysName);
  print("系统版本：" + config.sysVersion);
  print("公司名称：" + config.companyName);
} else {
  print("配置初始化失败，请检查！");
}

