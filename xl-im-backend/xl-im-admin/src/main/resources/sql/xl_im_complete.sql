-- ========================================
-- XL即时通讯系统 - MySQL数据库脚本
-- ========================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS `xl_im` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

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
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像地址',
  `gender` tinyint DEFAULT '0' COMMENT '性别（0未知 1男 2女）',
  `dept_id` bigint DEFAULT NULL COMMENT '部门ID',
  `status` tinyint DEFAULT '1' COMMENT '帐号状态（0停用 1正常）',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  KEY `idx_dept_id` (`dept_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户信息表';

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
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_key` (`role_key`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色信息表';

-- ========================================
-- 3. 部门表
-- ========================================
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门ID',
  `parent_id` bigint DEFAULT '0' COMMENT '父部门ID',
  `dept_name` varchar(50) NOT NULL COMMENT '部门名称',
  `leader` varchar(50) DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `sort_code` int DEFAULT '0' COMMENT '显示顺序',
  `status` tinyint DEFAULT '1' COMMENT '部门状态（0停用 1正常）',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='部门表';

-- ========================================
-- 4. 用户角色关联表
-- ========================================
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户和角色关联表';

-- ========================================
-- 插入初始数据
-- ========================================

-- 部门数据
INSERT INTO `sys_dept` (`id`, `parent_id`, `dept_name`, `leader`, `phone`, `email`, `sort_code`, `status`, `create_time`, `update_time`) VALUES
(1, 0, '某某科技有限公司', '张总', '010-12345678', 'ceo@example.com', 1, 1, NOW(), NOW()),
(2, 1, '技术部', '李经理', '010-12345679', 'tech@example.com', 1, 1, NOW(), NOW()),
(3, 1, '市场部', '王经理', '010-12345680', 'market@example.com', 2, 1, NOW(), NOW());

-- 角色数据
INSERT INTO `sys_role` (`id`, `role_name`, `role_key`, `role_sort`, `status`, `remark`, `create_time`, `update_time`) VALUES
(1, '超级管理员', 'admin', 1, 1, '超级管理员，拥有所有权限', NOW(), NOW()),
(2, 'IM用户', 'im_user', 2, 1, '即时通讯系统普通用户', NOW(), NOW());

-- 用户数据（密码都是123456的MD5加密：e10adc3949ba59abbe56e057f20f883e）
INSERT INTO `sys_user` (`id`, `username`, `password`, `nickname`, `email`, `phone`, `gender`, `dept_id`, `status`, `remark`, `create_time`, `update_time`) VALUES
(1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', '系统管理员', 'admin@example.com', '13800138000', 1, 1, 1, '系统管理员账号', NOW(), NOW()),
(2, 'test', 'e10adc3949ba59abbe56e057f20f883e', '测试用户', 'test@example.com', '13800138001', 2, 2, 1, '测试用户账号', NOW(), NOW());

-- 用户角色关联数据
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES
(1, 1),
(2, 2);

-- ========================================
-- 4. 用户角色关联表
-- ========================================
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_role` (`user_id`, `role_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户和角色关联表';

-- ========================================
-- 第二层：菜单权限表（Menu）- 增加 system_id
-- ========================================
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `system_id` varchar(50) DEFAULT NULL COMMENT '所属应用系统ID',
  `menu_name` varchar(50) NOT NULL COMMENT '菜单名称',
  `full_name` varchar(100) DEFAULT NULL COMMENT '菜单全称',
  `en_code` varchar(50) DEFAULT NULL COMMENT '菜单编码',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `sort_code` int DEFAULT '0' COMMENT '排序码',
  `path` varchar(200) DEFAULT '' COMMENT '路由地址',
  `url_address` varchar(255) DEFAULT NULL COMMENT '菜单地址/组件路径',
  `component` varchar(255) DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) DEFAULT NULL COMMENT '路由参数',
  `is_frame` tinyint DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `link_target` varchar(20) DEFAULT '_self' COMMENT '链接打开方式（_self=当前窗口 _blank=新窗口）',
  `is_cache` tinyint DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `type` tinyint DEFAULT '2' COMMENT '菜单类型编号（1=目录 2=菜单 3=按钮 4=字典 5=报表 6=大屏 7=外链 8=门户 9=流程）',
  `category` varchar(20) DEFAULT 'Web' COMMENT '分类（Web/App）',
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
  KEY `idx_system_id` (`system_id`),
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
  UNIQUE KEY `uk_role_menu` (`role_id`, `menu_id`),
  KEY `idx_role_id` (`role_id`),
  KEY `idx_menu_id` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色和菜单关联表';

-- ========================================
-- 第三层：权限表（Permission）
-- ========================================

-- 6. 按钮权限表
DROP TABLE IF EXISTS `sys_button_authorize`;
CREATE TABLE `sys_button_authorize` (
  `id` varchar(50) NOT NULL COMMENT '权限ID',
  `menu_id` bigint NOT NULL COMMENT '所属菜单ID',
  `en_code` varchar(50) NOT NULL COMMENT '权限编码',
  `full_name` varchar(100) NOT NULL COMMENT '权限名称',
  `icon` varchar(100) DEFAULT NULL COMMENT '图标',
  `url_address` varchar(255) DEFAULT NULL COMMENT '请求地址',
  `sort_code` int DEFAULT '0' COMMENT '排序',
  `enabled_mark` tinyint DEFAULT '1' COMMENT '启用状态（0禁用 1启用）',
  `description` varchar(500) DEFAULT NULL COMMENT '描述',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`id`),
  KEY `idx_menu_id` (`menu_id`),
  KEY `idx_enabled_mark` (`enabled_mark`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='按钮权限表';

-- 7. 列表权限表
DROP TABLE IF EXISTS `sys_column_authorize`;
CREATE TABLE `sys_column_authorize` (
  `id` varchar(50) NOT NULL COMMENT '权限ID',
  `menu_id` bigint NOT NULL COMMENT '所属菜单ID',
  `en_code` varchar(50) NOT NULL COMMENT '字段编码',
  `full_name` varchar(100) NOT NULL COMMENT '字段名称',
  `sort_code` int DEFAULT '0' COMMENT '排序',
  `enabled_mark` tinyint DEFAULT '1' COMMENT '启用状态',
  `description` varchar(500) DEFAULT NULL COMMENT '描述',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`id`),
  KEY `idx_menu_id` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='列表权限表';

-- 8. 表单权限表
DROP TABLE IF EXISTS `sys_form_authorize`;
CREATE TABLE `sys_form_authorize` (
  `id` varchar(50) NOT NULL COMMENT '权限ID',
  `menu_id` bigint NOT NULL COMMENT '所属菜单ID',
  `en_code` varchar(50) NOT NULL COMMENT '字段编码',
  `full_name` varchar(100) NOT NULL COMMENT '字段名称',
  `sort_code` int DEFAULT '0' COMMENT '排序',
  `enabled_mark` tinyint DEFAULT '1' COMMENT '启用状态',
  `description` varchar(500) DEFAULT NULL COMMENT '描述',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`id`),
  KEY `idx_menu_id` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='表单权限表';

-- 9. 数据权限表
DROP TABLE IF EXISTS `sys_data_authorize`;
CREATE TABLE `sys_data_authorize` (
  `id` varchar(50) NOT NULL COMMENT '权限ID',
  `menu_id` bigint NOT NULL COMMENT '所属菜单ID',
  `en_code` varchar(50) NOT NULL COMMENT '权限编码',
  `full_name` varchar(100) NOT NULL COMMENT '权限名称',
  `condition_text` text COMMENT '数据权限条件',
  `condition_sql` text COMMENT '数据权限SQL',
  `sort_code` int DEFAULT '0' COMMENT '排序',
  `enabled_mark` tinyint DEFAULT '1' COMMENT '启用状态',
  `description` varchar(500) DEFAULT NULL COMMENT '描述',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`id`),
  KEY `idx_menu_id` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='数据权限表';

-- 10. 角色权限关联表（统一管理按钮、列表、表单、数据权限）
DROP TABLE IF EXISTS `sys_role_authorize`;
CREATE TABLE `sys_role_authorize` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `authorize_id` varchar(50) NOT NULL COMMENT '权限ID',
  `authorize_type` varchar(20) NOT NULL COMMENT '权限类型（button/column/form/data）',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_auth` (`role_id`, `authorize_id`, `authorize_type`),
  KEY `idx_role_id` (`role_id`),
  KEY `idx_authorize_type` (`authorize_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色权限关联表';

-- ========================================
-- 11. 系统配置表
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
  `deleted` tinyint DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';

-- 12. 操作日志表
DROP TABLE IF EXISTS `sys_log`;
CREATE TABLE `sys_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `username` varchar(50) DEFAULT NULL COMMENT '用户账号',
  `operation` varchar(50) DEFAULT NULL COMMENT '操作类型',
  `method` varchar(200) DEFAULT NULL COMMENT '请求方法',
  `params` text COMMENT '请求参数',
  `ip` varchar(50) DEFAULT NULL COMMENT 'IP地址',
  `location` varchar(100) DEFAULT NULL COMMENT '操作地点',
  `status` tinyint DEFAULT '1' COMMENT '操作状态（0失败 1成功）',
  `error_msg` text COMMENT '错误消息',
  `execute_time` int DEFAULT '0' COMMENT '执行时长(毫秒)',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志表';

-- ========================================
-- 插入初始数据
-- ========================================

-- 插入应用系统数据
INSERT INTO `sys_system` (`id`, `en_code`, `full_name`, `description`, `icon`, `url_address`, `sort_code`, `enabled_mark`, `is_main`) VALUES
('im-system', 'imSystem', 'IM系统', '即时通讯核心功能', 'icon-ym icon-ym-nav-im', '/im', 1, 1, 0),
('admin-system', 'adminSystem', '管理后台', '系统管理和配置', 'icon-ym icon-ym-nav-admin', '/admin', 2, 1, 1);

-- 插入部门数据
INSERT INTO `sys_dept` (`id`, `parent_id`, `dept_name`, `dept_code`, `leader`, `sort_code`, `status`) VALUES
(1, 0, '总公司', 'ROOT', '张三', 0, 1),
(2, 1, '技术部', 'TECH', '李四', 1, 1),
(3, 1, '市场部', 'MARKET', '王五', 2, 1);

-- 插入用户数据（密码：admin123 的BCrypt加密）
INSERT INTO `sys_user` (`id`, `username`, `password`, `nickname`, `email`, `phone`, `avatar`, `gender`, `dept_id`, `status`) VALUES
(1, 'admin', '$2a$10$7JB720yubVSZfsvVWb5K5O9hf4A3qXC9E0kXdOQVE1ypHKXQ8fH.W', '超级管理员', 'admin@xl.com', '13800138000', '', 1, 1, 1),
(2, 'test', '$2a$10$7JB720yubVSZfsvVWb5K5O9hf4A3qXC9E0kXdOQVE1ypHKXQ8fH.W', '测试用户', 'test@xl.com', '13800138001', '', 1, 2, 1);

-- 插入角色数据
INSERT INTO `sys_role` (`id`, `role_name`, `role_key`, `role_sort`, `data_scope`, `status`, `remark`) VALUES
(1, '超级管理员', 'admin', 1, 1, 1, '超级管理员，拥有所有权限'),
(2, 'IM用户', 'im_user', 2, 5, 1, '即时通讯普通用户'),
(3, '系统管理员', 'sys_admin', 3, 2, 1, '系统管理员，管理系统配置');

-- 插入用户角色关联数据
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES
(1, 1),  -- admin 是超级管理员
(2, 2);  -- test 是IM用户

-- 插入菜单数据
INSERT INTO `sys_menu` (`id`, `system_id`, `menu_name`, `full_name`, `en_code`, `parent_id`, `order_num`, `sort_code`, `path`, `url_address`, `component`, `menu_type`, `type`, `category`, `visible`, `status`, `enabled_mark`, `perms`, `icon`, `property_json`, `remark`) VALUES
-- ========== IM系统菜单 ==========
-- 一级菜单：工作台
(1, 'im-system', '工作台', '工作台', 'dashboard', 0, 1, 1, '/dashboard', 'basic/home/index', 'basic/home/index', 'C', 2, 'Web', '0', '0', 1, '', 'icon-ym icon-ym-nav-home', '{}', '工作台首页'),

-- 一级菜单：即时通讯
(2, 'im-system', '即时通讯', '即时通讯', 'im', 0, 2, 2, '/im', NULL, NULL, 'M', 1, 'Web', '0', '0', 1, '', 'icon-ym icon-ym-nav-im', '{}', 'IM模块'),
(3, 'im-system', '聊天', '聊天管理', 'im-chat', 2, 1, 1, '/im/chat', 'im/Chat', 'im/Chat', 'C', 2, 'Web', '0', '0', 1, 'im:chat:view', 'icon-ym icon-ym-chat', '{"moduleId":"im-chat"}', '聊天功能'),
(4, 'im-system', '群组', '群组管理', 'im-group', 2, 2, 2, '/im/group', 'im/Group', 'im/Group', 'C', 2, 'Web', '0', '0', 1, 'im:group:view', 'icon-ym icon-ym-group', '{"moduleId":"im-group"}', '群组管理'),
(5, 'im-system', '好友', '好友管理', 'im-friends', 2, 3, 3, '/im/friends', 'im/Friends', 'im/Friends', 'C', 2, 'Web', '0', '0', 1, 'im:friends:view', 'icon-ym icon-ym-user', '{"moduleId":"im-friends"}', '好友管理'),
(6, 'im-system', '通讯录', '通讯录', 'im-contacts', 2, 4, 4, '/im/contacts', 'im/Contacts', 'im/Contacts', 'C', 2, 'Web', '0', '0', 1, 'im:contacts:view', 'icon-ym icon-ym-contacts', '{"moduleId":"im-contacts"}', '通讯录'),

-- ========== 管理后台菜单 ==========
-- 一级菜单：系统管理
(10, 'admin-system', '系统管理', '系统管理', 'system', 0, 1, 1, '/system', NULL, NULL, 'M', 1, 'Web', '0', '0', 1, '', 'icon-ym icon-ym-nav-system', '{}', '系统管理模块'),
(11, 'admin-system', '应用管理', '应用系统管理', 'system-app', 10, 1, 1, '/system/app', 'system/menu/index', 'system/menu/index', 'C', 2, 'Web', '0', '0', 1, 'system:app:view', 'icon-ym icon-ym-app', '{"moduleId":"system-app"}', '应用系统管理'),
(12, 'admin-system', '用户管理', '用户管理', 'system-user', 10, 2, 2, '/system/user', 'permission/user/index', 'permission/user/index', 'C', 2, 'Web', '0', '0', 1, 'system:user:view', 'icon-ym icon-ym-user', '{"moduleId":"system-user"}', '用户管理'),
(13, 'admin-system', '角色管理', '角色管理', 'system-role', 10, 3, 3, '/system/role', 'permission/role/index', 'permission/role/index', 'C', 2, 'Web', '0', '0', 1, 'system:role:view', 'icon-ym icon-ym-role', '{"moduleId":"system-role"}', '角色管理'),
(14, 'admin-system', '部门管理', '部门管理', 'system-dept', 10, 4, 4, '/system/dept', 'permission/organize/index', 'permission/organize/index', 'C', 2, 'Web', '0', '0', 1, 'system:dept:view', 'icon-ym icon-ym-dept', '{"moduleId":"system-dept"}', '部门管理'),
(15, 'admin-system', '菜单管理', '菜单管理', 'system-menu', 10, 5, 5, '/system/menu', 'system/menuManage/index', 'system/menuManage/index', 'C', 2, 'Web', '0', '0', 1, 'system:menu:view', 'icon-ym icon-ym-menu', '{"moduleId":"system-menu"}', '菜单管理'),
(16, 'admin-system', '系统配置', '系统配置', 'system-config', 10, 6, 6, '/system/config', 'system/sysConfig/index', 'system/sysConfig/index', 'C', 2, 'Web', '0', '0', 1, 'system:config:view', 'icon-ym icon-ym-config', '{"moduleId":"system-config"}', '系统配置'),

-- 一级菜单：系统监控
(20, 'admin-system', '系统监控', '系统监控', 'monitor', 0, 2, 2, '/monitor', NULL, NULL, 'M', 1, 'Web', '0', '0', 1, '', 'icon-ym icon-ym-nav-monitor', '{}', '系统监控模块'),
(21, 'admin-system', '在线用户', '在线用户', 'monitor-online', 20, 1, 1, '/monitor/online', 'permission/userOnline/index', 'permission/userOnline/index', 'C', 2, 'Web', '0', '0', 1, 'monitor:online:view', 'icon-ym icon-ym-user', '{"moduleId":"monitor-online"}', '在线用户'),
(22, 'admin-system', '操作日志', '操作日志', 'monitor-log', 20, 2, 2, '/monitor/log', 'system/log/index', 'system/log/index', 'C', 2, 'Web', '0', '0', 1, 'monitor:log:view', 'icon-ym icon-ym-log', '{"moduleId":"monitor-log"}', '操作日志');

-- 插入角色菜单关联数据
-- 超级管理员拥有所有菜单权限
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6),
(1, 10), (1, 11), (1, 12), (1, 13), (1, 14), (1, 15), (1, 16),
(1, 20), (1, 21), (1, 22);

-- IM用户只有IM模块权限
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 6);

-- 系统管理员只有管理后台权限
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES
(3, 10), (3, 11), (3, 12), (3, 13), (3, 14), (3, 15), (3, 16),
(3, 20), (3, 21), (3, 22);

-- ========================================
-- 插入示例权限数据
-- ========================================

-- 用户管理的按钮权限
INSERT INTO `sys_button_authorize` (`id`, `menu_id`, `en_code`, `full_name`, `icon`, `url_address`, `sort_code`, `enabled_mark`) VALUES
('btn_user_add', 12, 'add', '新增', 'icon-ym icon-ym-btn-add', '/system/user', 1, 1),
('btn_user_edit', 12, 'edit', '编辑', 'icon-ym icon-ym-btn-edit', '/system/user/{id}', 2, 1),
('btn_user_delete', 12, 'delete', '删除', 'icon-ym icon-ym-btn-delete', '/system/user/{id}', 3, 1),
('btn_user_export', 12, 'export', '导出', 'icon-ym icon-ym-btn-export', '/system/user/export', 4, 1),
('btn_user_import', 12, 'import', '导入', 'icon-ym icon-ym-btn-import', '/system/user/import', 5, 1),
('btn_user_reset', 12, 'reset', '重置密码', 'icon-ym icon-ym-btn-reset', '/system/user/reset', 6, 1);

-- 用户列表的列权限
INSERT INTO `sys_column_authorize` (`id`, `menu_id`, `en_code`, `full_name`, `sort_code`, `enabled_mark`) VALUES
('col_user_username', 12, 'username', '用户名', 1, 1),
('col_user_nickname', 12, 'nickname', '昵称', 2, 1),
('col_user_email', 12, 'email', '邮箱', 3, 1),
('col_user_phone', 12, 'phone', '手机号', 4, 1),
('col_user_dept', 12, 'deptName', '部门', 5, 1),
('col_user_status', 12, 'status', '状态', 6, 1),
('col_user_create_time', 12, 'createTime', '创建时间', 7, 1);

-- 用户表单的字段权限
INSERT INTO `sys_form_authorize` (`id`, `menu_id`, `en_code`, `full_name`, `sort_code`, `enabled_mark`) VALUES
('form_user_username', 12, 'username', '用户名', 1, 1),
('form_user_password', 12, 'password', '密码', 2, 1),
('form_user_nickname', 12, 'nickname', '昵称', 3, 1),
('form_user_email', 12, 'email', '邮箱', 4, 1),
('form_user_phone', 12, 'phone', '手机号', 5, 1),
('form_user_dept', 12, 'deptId', '所属部门', 6, 1),
('form_user_role', 12, 'roleIds', '角色', 7, 1),
('form_user_status', 12, 'status', '状态', 8, 1);

-- 角色管理的按钮权限
INSERT INTO `sys_button_authorize` (`id`, `menu_id`, `en_code`, `full_name`, `icon`, `url_address`, `sort_code`, `enabled_mark`) VALUES
('btn_role_add', 13, 'add', '新增', 'icon-ym icon-ym-btn-add', '/system/role', 1, 1),
('btn_role_edit', 13, 'edit', '编辑', 'icon-ym icon-ym-btn-edit', '/system/role/{id}', 2, 1),
('btn_role_delete', 13, 'delete', '删除', 'icon-ym icon-ym-btn-delete', '/system/role/{id}', 3, 1),
('btn_role_auth', 13, 'auth', '分配权限', 'icon-ym icon-ym-btn-auth', '/system/role/authorize', 4, 1);

-- 群组管理的按钮权限
INSERT INTO `sys_button_authorize` (`id`, `menu_id`, `en_code`, `full_name`, `icon`, `url_address`, `sort_code`, `enabled_mark`) VALUES
('btn_group_add', 4, 'add', '创建群组', 'icon-ym icon-ym-btn-add', '/im/group', 1, 1),
('btn_group_edit', 4, 'edit', '编辑', 'icon-ym icon-ym-btn-edit', '/im/group/{id}', 2, 1),
('btn_group_delete', 4, 'delete', '解散群组', 'icon-ym icon-ym-btn-delete', '/im/group/{id}', 3, 1),
('btn_group_member', 4, 'member', '成员管理', 'icon-ym icon-ym-btn-member', '/im/group/members', 4, 1);

-- 插入角色权限关联（超级管理员拥有所有按钮权限）
INSERT INTO `sys_role_authorize` (`role_id`, `authorize_id`, `authorize_type`) VALUES
(1, 'btn_user_add', 'button'),
(1, 'btn_user_edit', 'button'),
(1, 'btn_user_delete', 'button'),
(1, 'btn_user_export', 'button'),
(1, 'btn_user_import', 'button'),
(1, 'btn_user_reset', 'button'),
(1, 'btn_role_add', 'button'),
(1, 'btn_role_edit', 'button'),
(1, 'btn_role_delete', 'button'),
(1, 'btn_role_auth', 'button');

-- IM用户拥有群组权限
INSERT INTO `sys_role_authorize` (`role_id`, `authorize_id`, `authorize_type`) VALUES
(2, 'btn_group_add', 'button'),
(2, 'btn_group_edit', 'button'),
(2, 'btn_group_member', 'button');

-- 插入系统配置数据
INSERT INTO `sys_config` (`config_name`, `config_key`, `config_value`, `config_type`, `remark`) VALUES
('系统名称', 'sys.name', 'XL即时通讯系统', 'Y', '系统名称'),
('系统版本', 'sys.version', 'v1.0.0', 'Y', '系统版本号'),
('是否开放注册', 'sys.account.registerUser', 'false', 'Y', '是否开放用户注册功能'),
('Token超时时间', 'sys.token.timeout', '7200', 'Y', 'Token超时时间（秒）'),
('密码错误次数限制', 'sys.password.maxRetry', '5', 'Y', '密码错误次数限制');

-- ========================================
-- 验证数据
-- ========================================
SELECT '========== 数据统计 ==========' as '';
SELECT 
  (SELECT COUNT(*) FROM sys_system WHERE deleted = 0) as '应用系统数',
  (SELECT COUNT(*) FROM sys_user WHERE deleted = 0) as '用户数',
  (SELECT COUNT(*) FROM sys_role WHERE deleted = 0) as '角色数',
  (SELECT COUNT(*) FROM sys_dept WHERE deleted = 0) as '部门数',
  (SELECT COUNT(*) FROM sys_menu WHERE deleted = 0) as '菜单数',
  (SELECT COUNT(*) FROM sys_button_authorize WHERE deleted = 0) as '按钮权限数',
  (SELECT COUNT(*) FROM sys_config WHERE deleted = 0) as '配置数';

SELECT '========== 应用系统列表 ==========' as '';
SELECT id, en_code, full_name, enabled_mark FROM sys_system WHERE deleted = 0;

SELECT '========== 菜单列表（按应用系统分组） ==========' as '';
SELECT 
  m.id, 
  m.system_id,
  s.full_name as system_name,
  m.menu_name, 
  m.en_code,
  m.parent_id, 
  m.type,
  m.enabled_mark 
FROM sys_menu m
LEFT JOIN sys_system s ON m.system_id = s.id
WHERE m.deleted = 0 
ORDER BY m.system_id, m.parent_id, m.sort_code;

SELECT '========== 用户角色分配 ==========' as '';
SELECT 
  u.username,
  u.nickname,
  GROUP_CONCAT(r.role_name) as roles
FROM sys_user u
LEFT JOIN sys_user_role ur ON u.id = ur.user_id
LEFT JOIN sys_role r ON ur.role_id = r.id
WHERE u.deleted = 0
GROUP BY u.id, u.username, u.nickname;

SELECT '========== 数据库初始化完成 ==========' as '';
