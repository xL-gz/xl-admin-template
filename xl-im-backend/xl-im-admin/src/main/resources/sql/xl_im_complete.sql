-- ========================================
-- XL即时通讯系统 - 完整数据库脚本
-- 包含：表结构 + 初始数据
-- ========================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS `xl_im` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `xl_im`;

-- ========================================
-- 1. 用户表
-- ========================================
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `id` bigint NOT NULL COMMENT '用户ID',
  `username` varchar(30) NOT NULL COMMENT '用户账号',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `nickname` varchar(30) DEFAULT NULL COMMENT '用户昵称',
  `email` varchar(50) DEFAULT NULL COMMENT '用户邮箱',
  `phone` varchar(11) DEFAULT NULL COMMENT '手机号码',
  `avatar` varchar(100) DEFAULT NULL COMMENT '头像地址',
  `status` tinyint DEFAULT '1' COMMENT '帐号状态（0停用 1正常）',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户信息表';

-- ========================================
-- 2. 角色表
-- ========================================
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) NOT NULL COMMENT '角色权限字符串',
  `role_sort` int DEFAULT '0' COMMENT '显示顺序',
  `status` tinyint DEFAULT '1' COMMENT '角色状态（0停用 1正常）',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_key` (`role_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色信息表';

-- ========================================
-- 3. 用户角色关联表
-- ========================================
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_role` (`user_id`, `role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户和角色关联表';

-- ========================================
-- 4. 菜单权限表（完整版）
-- ========================================
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) NOT NULL COMMENT '菜单名称',
  `full_name` varchar(100) DEFAULT NULL COMMENT '菜单全称',
  `en_code` varchar(50) DEFAULT NULL COMMENT '菜单编码',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `sort_code` int DEFAULT '0' COMMENT '排序码',
  `path` varchar(200) DEFAULT '' COMMENT '路由地址',
  `url_address` varchar(255) DEFAULT NULL COMMENT '菜单地址',
  `component` varchar(255) DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) DEFAULT NULL COMMENT '路由参数',
  `is_frame` tinyint DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `link_target` varchar(20) DEFAULT '_self' COMMENT '链接打开方式（_self=当前窗口 _blank=新窗口）',
  `is_cache` tinyint DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `type` tinyint DEFAULT '2' COMMENT '菜单类型编号（1=目录 2=菜单 3=按钮）',
  `visible` char(1) DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `enabled_mark` tinyint DEFAULT '1' COMMENT '启用状态（0禁用 1启用）',
  `perms` varchar(100) DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) DEFAULT '#' COMMENT '菜单图标',
  `property_json` text COMMENT '扩展属性JSON',
  `remark` varchar(500) DEFAULT '' COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_status` (`status`),
  KEY `idx_enabled_mark` (`enabled_mark`),
  KEY `idx_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='菜单权限表';

-- ========================================
-- 5. 角色菜单关联表
-- ========================================
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_menu` (`role_id`, `menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色和菜单关联表';

-- ========================================
-- 6. 系统配置表
-- ========================================
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `config_name` varchar(100) NOT NULL COMMENT '配置名称',
  `config_key` varchar(100) NOT NULL COMMENT '配置键名',
  `config_value` varchar(500) DEFAULT NULL COMMENT '配置键值',
  `config_type` char(1) DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';

-- ========================================
-- 插入初始数据
-- ========================================

-- 插入用户数据
INSERT INTO `sys_user` (`id`, `username`, `password`, `nickname`, `email`, `phone`, `avatar`, `status`, `create_time`, `update_time`, `deleted`) VALUES
(1, 'admin', '$2a$10$7JB720yubVSZfsvVWb5K5O9hf4A3qXC9E0kXdOQVE1ypHKXQ8fH.W', '管理员', 'admin@xl.com', '13800138000', '', 1, NOW(), NOW(), 0),
(2, 'test', '$2a$10$7JB720yubVSZfsvVWb5K5O9hf4A3qXC9E0kXdOQVE1ypHKXQ8fH.W', '测试用户', 'test@xl.com', '13800138001', '', 1, NOW(), NOW(), 0);

-- 插入角色数据
INSERT INTO `sys_role` (`id`, `role_name`, `role_key`, `role_sort`, `status`, `remark`) VALUES
(1, '超级管理员', 'admin', 1, 1, '超级管理员'),
(2, '普通用户', 'user', 2, 1, '普通用户');

-- 插入用户角色关联数据
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES
(1, 1),
(2, 2);

-- 插入菜单数据
INSERT INTO `sys_menu` (`id`, `menu_name`, `full_name`, `en_code`, `parent_id`, `order_num`, `sort_code`, `path`, `url_address`, `component`, `menu_type`, `type`, `link_target`, `visible`, `status`, `enabled_mark`, `perms`, `icon`, `property_json`, `remark`) VALUES
-- 一级菜单：工作台
(1, '工作台', '工作台', 'dashboard', 0, 1, 1, '/dashboard', 'basic/home/index', 'basic/home/index', 'C', 2, '_self', '0', '0', 1, '', 'icon-ym icon-ym-nav-home', '{}', '工作台首页'),

-- 一级菜单：即时通讯
(2, '即时通讯', '即时通讯', 'im', 0, 2, 2, '/im', NULL, NULL, 'M', 1, '_self', '0', '0', 1, '', 'icon-ym icon-ym-nav-im', '{}', 'IM模块'),
(3, '聊天', '聊天管理', 'im-chat', 2, 1, 1, '/im/chat', 'im/Chat', 'im/Chat', 'C', 2, '_self', '0', '0', 1, 'im:chat:view', 'icon-ym icon-ym-chat', '{}', '聊天功能'),
(4, '群组', '群组管理', 'im-group', 2, 2, 2, '/im/group', 'im/Group', 'im/Group', 'C', 2, '_self', '0', '0', 1, 'im:group:view', 'icon-ym icon-ym-group', '{}', '群组管理'),
(5, '好友', '好友管理', 'im-friends', 2, 3, 3, '/im/friends', 'im/Friends', 'im/Friends', 'C', 2, '_self', '0', '0', 1, 'im:friends:view', 'icon-ym icon-ym-user', '{}', '好友管理'),
(6, '通讯录', '通讯录', 'im-contacts', 2, 4, 4, '/im/contacts', 'im/Contacts', 'im/Contacts', 'C', 2, '_self', '0', '0', 1, 'im:contacts:view', 'icon-ym icon-ym-contacts', '{}', '通讯录'),

-- 一级菜单：系统管理
(10, '系统管理', '系统管理', 'system', 0, 3, 3, '/system', NULL, NULL, 'M', 1, '_self', '0', '0', 1, '', 'icon-ym icon-ym-nav-system', '{}', '系统管理模块'),
(11, '用户管理', '用户管理', 'system-user', 10, 1, 1, '/system/user', 'permission/user/index', 'permission/user/index', 'C', 2, '_self', '0', '0', 1, 'system:user:view', 'icon-ym icon-ym-user', '{}', '用户管理'),
(12, '角色管理', '角色管理', 'system-role', 10, 2, 2, '/system/role', 'permission/role/index', 'permission/role/index', 'C', 2, '_self', '0', '0', 1, 'system:role:view', 'icon-ym icon-ym-role', '{}', '角色管理'),
(13, '菜单管理', '菜单管理', 'system-menu', 10, 3, 3, '/system/menu', 'system/menuManage/index', 'system/menuManage/index', 'C', 2, '_self', '0', '0', 1, 'system:menu:view', 'icon-ym icon-ym-menu', '{}', '菜单管理'),
(14, '系统配置', '系统配置', 'system-config', 10, 4, 4, '/system/config', 'system/sysConfig/index', 'system/sysConfig/index', 'C', 2, '_self', '0', '0', 1, 'system:config:view', 'icon-ym icon-ym-config', '{}', '系统配置'),

-- 一级菜单：系统监控
(20, '系统监控', '系统监控', 'monitor', 0, 4, 4, '/monitor', NULL, NULL, 'M', 1, '_self', '0', '0', 1, '', 'icon-ym icon-ym-nav-monitor', '{}', '系统监控模块'),
(21, '在线用户', '在线用户', 'monitor-online', 20, 1, 1, '/monitor/online', 'permission/userOnline/index', 'permission/userOnline/index', 'C', 2, '_self', '0', '0', 1, 'monitor:online:view', 'icon-ym icon-ym-user', '{}', '在线用户'),
(22, '操作日志', '操作日志', 'monitor-log', 20, 2, 2, '/monitor/log', 'system/log/index', 'system/log/index', 'C', 2, '_self', '0', '0', 1, 'monitor:log:view', 'icon-ym icon-ym-log', '{}', '操作日志'),
(23, '通知公告', '通知公告', 'monitor-notice', 20, 3, 3, '/monitor/notice', 'system/notice/index', 'system/notice/index', 'C', 2, '_self', '0', '0', 1, 'monitor:notice:view', 'icon-ym icon-ym-notice', '{}', '通知公告');

-- 插入角色菜单关联数据（超级管理员拥有所有菜单权限）
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6),
(1, 10), (1, 11), (1, 12), (1, 13), (1, 14),
(1, 20), (1, 21), (1, 22), (1, 23);

-- 普通用户只有IM模块和工作台权限
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 6);

-- 插入系统配置数据
INSERT INTO `sys_config` (`config_name`, `config_key`, `config_value`, `config_type`, `remark`) VALUES
('系统名称', 'sys.name', 'XL即时通讯系统', 'Y', '系统名称'),
('系统版本', 'sys.version', 'v1.0.0', 'Y', '系统版本号'),
('是否开放注册', 'sys.account.registerUser', 'false', 'Y', '是否开放用户注册功能');

-- ========================================
-- 验证数据
-- ========================================
SELECT '=== 用户表 ===' as '';
SELECT id, username, nickname, status FROM sys_user WHERE deleted = 0;

SELECT '=== 角色表 ===' as '';
SELECT id, role_name, role_key, status FROM sys_role WHERE deleted = 0;

SELECT '=== 菜单表 ===' as '';
SELECT id, menu_name, full_name, en_code, parent_id, path, menu_type, enabled_mark 
FROM sys_menu 
WHERE deleted = 0 
ORDER BY parent_id, sort_code;

SELECT '=== 统计信息 ===' as '';
SELECT 
  (SELECT COUNT(*) FROM sys_user WHERE deleted = 0) as '用户数',
  (SELECT COUNT(*) FROM sys_role WHERE deleted = 0) as '角色数',
  (SELECT COUNT(*) FROM sys_menu WHERE deleted = 0) as '菜单数',
  (SELECT COUNT(*) FROM sys_config WHERE deleted = 0) as '配置数';

-- 完成
SELECT '=== 数据库初始化完成 ===' as '';

