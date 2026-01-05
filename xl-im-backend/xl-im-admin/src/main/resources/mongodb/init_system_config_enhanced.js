// ========================================
// XL即时通讯系统 - MongoDB初始化脚本
// ========================================

// 使用数据库
db = db.getSiblingDB('xl_im');

// ========================================
// 1. 系统配置集合
// ========================================
db.system_config.drop();
db.createCollection('system_config');

db.system_config.insertOne({
  _id: 'main_config',
  basic: {
    title: 'XL即时通讯系统',
    sysName: 'XL-IM',
    sysVersion: 'v1.0.0'
  },
  security: {
    tokenTimeout: 7200,
    passwordErrorsNumber: 5,
    enableCaptcha: true
  },
  fileUpload: {
    maxSize: 10485760,
    allowedTypes: ['image/jpeg', 'image/png', 'image/gif', 'application/pdf'],
    uploadPath: '/uploads'
  },
  imConfig: {
    enableGroupChat: true,
    enablePrivateChat: true,
    maxGroupMembers: 500,
    maxFriends: 1000,
    enableFileTransfer: true,
    maxFileSize: 20971520
  },
  metadata: {
    createdAt: new Date(),
    updatedAt: new Date(),
    version: '1.0.0'
  }
});

// ========================================
// 2. 聊天消息集合
// ========================================
db.chat_message.drop();
db.createCollection('chat_message');

// 创建索引
db.chat_message.createIndex({ "conversationId": 1, "createTime": -1 });
db.chat_message.createIndex({ "fromUserId": 1 });
db.chat_message.createIndex({ "toUserId": 1 });

// ========================================
// 3. 群组消息集合
// ========================================
db.group_message.drop();
db.createCollection('group_message');

// 创建索引
db.group_message.createIndex({ "groupId": 1, "createTime": -1 });
db.group_message.createIndex({ "fromUserId": 1 });

// ========================================
// 4. 文件信息集合
// ========================================
db.file_info.drop();
db.createCollection('file_info');

// 创建索引
db.file_info.createIndex({ "uploadUserId": 1 });
db.file_info.createIndex({ "createTime": -1 });

// ========================================
// 5. 用户在线状态集合
// ========================================
db.user_online_status.drop();
db.createCollection('user_online_status');

// 创建索引
db.user_online_status.createIndex({ "userId": 1 }, { unique: true });
db.user_online_status.createIndex({ "lastOnlineTime": -1 });

print("MongoDB初始化完成！");
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

