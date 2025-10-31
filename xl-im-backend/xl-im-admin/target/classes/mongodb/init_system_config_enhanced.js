// ========================================
// XL即时通讯系统 - MongoDB初始化脚本
// 用途：存储系统配置、聊天记录、文件信息等非关系型数据
// ========================================

// 使用数据库
db = db.getSiblingDB('xl_im');

// ========================================
// 1. 系统配置集合（system_config）
// 用途：存储复杂的系统配置信息（JSON格式）
// ========================================
db.system_config.drop();
db.createCollection('system_config');

// 插入系统配置数据
db.system_config.insertOne({
  _id: 'main_config',
  
  // 基本设置
  basic: {
    title: 'XL即时通讯系统',
    sysName: 'XL-IM',
    sysVersion: 'v1.0.0',
    companyName: '某某科技有限公司',
    copyright: '© 2024 某某科技',
    companyCode: 'XXKJ',
    companyAddress: '北京市朝阳区xxx号',
    companyContacts: '张三',
    companyTelePhone: '010-12345678',
    companyEmail: 'contact@example.com',
    sysDescription: '企业级即时通讯系统'
  },
  
  // 图标配置
  icons: {
    loginIcon: '/static/img/login-logo.png',
    logoIcon: '/static/img/logo.png',
    appIcon: '/static/img/app-icon.png',
    favicon: '/favicon.ico'
  },
  
  // 安全设置
  security: {
    singleLogin: 1,                      // 登录方式（0:允许多端 1:单端登录）
    tokenTimeout: 7200,                  // Token超时时间(秒)
    passwordErrorsNumber: 5,             // 密码错误次数限制
    whitelistSwitch: false,              // 白名单开关
    whiteListIp: [],                     // 白名单IP列表
    enableCaptcha: true,                 // 是否启用验证码
    captchaOnFailure: 3                  // 失败N次后启用验证码
  },
  
  // 密码策略
  passwordPolicy: {
    passwordStrengthLimit: 2,            // 密码强度限制（0:无 1:弱 2:中 3:强）
    passwordLengthMin: 6,                // 最小长度
    passwordLengthMax: 20,               // 最大长度
    containsNumbers: true,               // 必须包含数字
    includeLowercaseLetters: true,       // 包含小写字母
    includeUppercaseLetters: false,      // 包含大写字母
    containsCharacters: false,           // 包含特殊字符
    passwordExpireDays: 90,              // 密码过期天数（0表示永不过期）
    mandatoryModificationOfInitialPassword: 0  // 是否强制修改初始密码
  },
  
  // 文件上传配置
  fileUpload: {
    maxSize: 10485760,                   // 最大文件大小(字节) 10MB
    allowedTypes: [                       // 允许的文件类型
      'image/jpeg', 'image/png', 'image/gif', 'image/webp',
      'application/pdf', 'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'application/vnd.ms-excel',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    ],
    imageMaxSize: 5242880,               // 图片最大大小(字节) 5MB
    avatarMaxSize: 1048576,              // 头像最大大小(字节) 1MB
    uploadPath: '/uploads',              // 上传路径
    avatarPath: '/uploads/avatars'       // 头像路径
  },
  
  // IM配置
  imConfig: {
    enableGroupChat: true,               // 启用群聊
    enablePrivateChat: true,             // 启用私聊
    maxGroupMembers: 500,                // 群组最大成员数
    maxFriends: 1000,                    // 最大好友数
    messageRetentionDays: 90,            // 消息保留天数（0表示永久）
    enableFileTransfer: true,            // 启用文件传输
    maxFileSize: 20971520,               // 文件传输最大大小(字节) 20MB
    enableVoiceCall: true,               // 启用语音通话
    enableVideoCall: true,               // 启用视频通话
    enableScreenShare: false,            // 启用屏幕共享
    offlineMessagePush: true,            // 离线消息推送
    messageReadReceipt: true             // 消息已读回执
  },
  
  // 界面配置
  uiConfig: {
    theme: 'light',                      // 主题（light/dark）
    primaryColor: '#1890ff',             // 主题色
    enableThemeSwitch: true,             // 允许用户切换主题
    enableMultiLanguage: true,           // 启用多语言
    defaultLanguage: 'zh_CN',            // 默认语言
    enableAnimation: true,               // 启用动画效果
    compactMode: false                   // 紧凑模式
  },
  
  // 第三方集成
  thirdParty: {
    // 企业微信
    weChat: {
      enabled: false,
      corpId: '',
      agentId: '',
      secret: ''
    },
    // 钉钉
    dingTalk: {
      enabled: false,
      appKey: '',
      appSecret: ''
    },
    // 飞书
    feishu: {
      enabled: false,
      appId: '',
      appSecret: ''
    }
  },
  
  // 消息推送配置
  pushConfig: {
    enableEmailNotify: false,            // 启用邮件通知
    enableSmsNotify: false,              // 启用短信通知
    emailProvider: 'smtp',               // 邮件服务商
    smtpHost: '',
    smtpPort: 465,
    smtpUser: '',
    smtpPassword: '',
    smsProvider: ''                      // 短信服务商
  },
  
  // 元数据
  metadata: {
    createdAt: new Date(),
    updatedAt: new Date(),
    version: '1.0.0'
  }
});

print('✅ 系统配置已初始化');

// ========================================
// 2. 聊天消息集合（chat_message）
// 用途：存储聊天消息记录
// ========================================
db.chat_message.drop();
db.createCollection('chat_message');

// 创建索引
db.chat_message.createIndex({ conversationId: 1, createTime: -1 });
db.chat_message.createIndex({ fromUserId: 1 });
db.chat_message.createIndex({ toUserId: 1 });
db.chat_message.createIndex({ messageType: 1 });
db.chat_message.createIndex({ createTime: -1 });

// 插入示例消息
db.chat_message.insertMany([
  {
    _id: 'msg_001',
    conversationId: 'conv_user_1_2',     // 会话ID
    fromUserId: 1,                       // 发送者ID
    toUserId: 2,                         // 接收者ID
    messageType: 'text',                 // 消息类型：text/image/file/voice/video
    content: '你好，这是第一条测试消息',
    contentExtra: null,                  // 额外内容（图片URL、文件信息等）
    isRead: false,                       // 是否已读
    isDeleted: false,                    // 是否删除
    createTime: new Date(),
    readTime: null
  },
  {
    _id: 'msg_002',
    conversationId: 'conv_user_1_2',
    fromUserId: 2,
    toUserId: 1,
    messageType: 'text',
    content: '你好，收到！',
    contentExtra: null,
    isRead: true,
    isDeleted: false,
    createTime: new Date(),
    readTime: new Date()
  }
]);

print('✅ 聊天消息集合已创建');

// ========================================
// 3. 群组消息集合（group_message）
// 用途：存储群组聊天消息
// ========================================
db.group_message.drop();
db.createCollection('group_message');

// 创建索引
db.group_message.createIndex({ groupId: 1, createTime: -1 });
db.group_message.createIndex({ fromUserId: 1 });
db.group_message.createIndex({ createTime: -1 });

// 插入示例群消息
db.group_message.insertMany([
  {
    _id: 'gmsg_001',
    groupId: 1,                          // 群组ID
    fromUserId: 1,                       // 发送者ID
    messageType: 'text',
    content: '大家好，这是群组消息',
    contentExtra: null,
    isDeleted: false,
    createTime: new Date(),
    readUserIds: [1]                     // 已读用户ID列表
  }
]);

print('✅ 群组消息集合已创建');

// ========================================
// 4. 文件信息集合（file_info）
// 用途：存储上传的文件信息
// ========================================
db.file_info.drop();
db.createCollection('file_info');

// 创建索引
db.file_info.createIndex({ uploadUserId: 1 });
db.file_info.createIndex({ fileType: 1 });
db.file_info.createIndex({ createTime: -1 });

// 插入示例文件信息
db.file_info.insertOne({
  _id: 'file_001',
  fileName: 'test.jpg',
  originalName: '测试图片.jpg',
  fileSize: 102400,                      // 文件大小(字节)
  fileType: 'image/jpeg',
  filePath: '/uploads/2024/01/test.jpg',
  fileUrl: 'http://example.com/uploads/2024/01/test.jpg',
  thumbnailUrl: 'http://example.com/uploads/2024/01/test_thumb.jpg',
  uploadUserId: 1,
  uploadUserName: 'admin',
  uploadTime: new Date(),
  isDeleted: false,
  metadata: {
    width: 1920,
    height: 1080,
    duration: null                       // 视频时长(秒)
  }
});

print('✅ 文件信息集合已创建');

// ========================================
// 5. 用户会话列表集合（user_conversation）
// 用途：存储每个用户的会话列表
// ========================================
db.user_conversation.drop();
db.createCollection('user_conversation');

// 创建索引
db.user_conversation.createIndex({ userId: 1, lastMessageTime: -1 });
db.user_conversation.createIndex({ conversationId: 1 });

// 插入示例会话
db.user_conversation.insertMany([
  {
    _id: 'uconv_001',
    userId: 1,                           // 用户ID
    conversationId: 'conv_user_1_2',     // 会话ID
    conversationType: 'private',         // 会话类型：private/group
    targetId: 2,                         // 对方用户ID或群组ID
    targetName: '测试用户',
    targetAvatar: '',
    lastMessage: '你好，收到！',
    lastMessageTime: new Date(),
    unreadCount: 0,                      // 未读消息数
    isTop: false,                        // 是否置顶
    isMute: false,                       // 是否静音
    isDeleted: false,
    createTime: new Date(),
    updateTime: new Date()
  },
  {
    _id: 'uconv_002',
    userId: 2,
    conversationId: 'conv_user_1_2',
    conversationType: 'private',
    targetId: 1,
    targetName: '超级管理员',
    targetAvatar: '',
    lastMessage: '你好，收到！',
    lastMessageTime: new Date(),
    unreadCount: 0,
    isTop: false,
    isMute: false,
    isDeleted: false,
    createTime: new Date(),
    updateTime: new Date()
  }
]);

print('✅ 用户会话列表集合已创建');

// ========================================
// 6. 用户在线状态集合（user_online_status）
// 用途：存储用户在线状态
// ========================================
db.user_online_status.drop();
db.createCollection('user_online_status');

// 创建索引
db.user_online_status.createIndex({ userId: 1 });
db.user_online_status.createIndex({ status: 1 });
db.user_online_status.createIndex({ updateTime: -1 });

// 插入示例在线状态
db.user_online_status.insertMany([
  {
    userId: 1,
    status: 'online',                    // 在线状态：online/offline/busy/away
    lastOnlineTime: new Date(),
    deviceType: 'web',                   // 设备类型：web/ios/android/windows/mac
    deviceId: 'device_001',
    ipAddress: '192.168.1.100',
    location: '北京市',
    updateTime: new Date()
  },
  {
    userId: 2,
    status: 'offline',
    lastOnlineTime: new Date(Date.now() - 3600000),  // 1小时前
    deviceType: 'web',
    deviceId: 'device_002',
    ipAddress: '192.168.1.101',
    location: '上海市',
    updateTime: new Date()
  }
]);

print('✅ 用户在线状态集合已创建');

// ========================================
// 7. 系统通知集合（system_notification）
// 用途：存储系统通知、公告
// ========================================
db.system_notification.drop();
db.createCollection('system_notification');

// 创建索引
db.system_notification.createIndex({ type: 1 });
db.system_notification.createIndex({ targetUserId: 1 });
db.system_notification.createIndex({ createTime: -1 });

// 插入示例通知
db.system_notification.insertOne({
  _id: 'notify_001',
  type: 'system',                        // 类型：system/friend/group
  title: '系统维护通知',
  content: '系统将于今晚22:00-24:00进行维护升级',
  targetType: 'all',                     // 目标类型：all/user/role/dept
  targetUserId: null,                    // 目标用户ID（targetType=user时）
  isRead: false,
  createTime: new Date(),
  readTime: null,
  expireTime: new Date(Date.now() + 7 * 24 * 3600000)  // 7天后过期
});

print('✅ 系统通知集合已创建');

// ========================================
// 统计信息
// ========================================
print('\n========================================');
print('📊 数据库统计信息：');
print('----------------------------------------');
print('系统配置: ' + db.system_config.count() + ' 条');
print('聊天消息: ' + db.chat_message.count() + ' 条');
print('群组消息: ' + db.group_message.count() + ' 条');
print('文件信息: ' + db.file_info.count() + ' 条');
print('用户会话: ' + db.user_conversation.count() + ' 条');
print('在线状态: ' + db.user_online_status.count() + ' 条');
print('系统通知: ' + db.system_notification.count() + ' 条');
print('========================================');
print('✅ MongoDB 初始化完成！');
print('========================================\n');

