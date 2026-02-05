-- ========================================
-- XL即时通讯系统 - MySQL数据库脚本（干净版本）
-- ========================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS `xl_im` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `xl_im`;

-- ========================================
-- 1. 应用系统表
-- ========================================
DROP TABLE IF EXISTS `sys_system`;
CREATE TABLE `sys_system` (
  `id` varchar(50) NOT NULL COMMENT '系统ID',
  `en_code` varchar(50) NOT NULL COMMENT '系统编码',
  `full_name` varchar(100) NOT NULL COMMENT '系统名称',
  `description` varchar(500) DEFAULT NULL COMMENT '系统描述',
  `icon` varchar(100) DEFAULT NULL COMMENT '系统图标',
  `url_address` varchar(255) DEFAULT NULL COMMENT '系统地址',
  `sort_code` int DEFAULT '0' COMMENT '排序',
  `enabled_mark` tinyint DEFAULT '1' COMMENT '启用状态（0禁用 1启用）',
  `is_main` tinyint DEFAULT '0' COMMENT '是否主系统（0否 1是）',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_en_code` (`en_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='应用系统表';

-- ========================================
-- 2. 部门表
-- ========================================
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门ID',
  `parent_id` bigint DEFAULT '0' COMMENT '父部门ID',
  `dept_name` varchar(50) NOT NULL COMMENT '部门名称',
  `leader` varchar(50) DEFAULT NULL COMMENT '负责人',
  `phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `sort_code` int DEFAULT '0' COMMENT '显示顺序',
  `status` tinyint DEFAULT '1' COMMENT '部门状态（0停用 1正常）',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='部门表';

-- ========================================
-- 3. 角色表
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色信息表';

-- ========================================
-- 4. 用户表
-- ========================================
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `id` bigint NOT NULL COMMENT '用户ID',
  `username` varchar(30) NOT NULL COMMENT '用户账号',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `nickname` varchar(30) DEFAULT NULL COMMENT '用户昵称',
  `email` varchar(50) DEFAULT NULL COMMENT '用户邮箱',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号码',
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户信息表';

-- ========================================
-- 5. 用户角色关联表
-- ========================================
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户和角色关联表';

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
  `deleted` tinyint DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';

-- ========================================
-- 7. 操作日志表
-- ========================================
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
INSERT INTO `sys_dept` (`id`, `parent_id`, `dept_name`, `leader`, `phone`, `email`, `sort_code`, `status`, `create_time`, `update_time`) VALUES
(1, 0, '某某科技有限公司', '张总', '010-12345678', 'ceo@example.com', 1, 1, NOW(), NOW()),
(2, 1, '技术部', '李经理', '010-12345679', 'tech@example.com', 1, 1, NOW(), NOW()),
(3, 1, '市场部', '王经理', '010-12345680', 'market@example.com', 2, 1, NOW(), NOW());

-- 插入角色数据
INSERT INTO `sys_role` (`id`, `role_name`, `role_key`, `role_sort`, `status`, `remark`, `create_time`, `update_time`) VALUES
(1, '超级管理员', 'admin', 1, 1, '超级管理员，拥有所有权限', NOW(), NOW()),
(2, 'IM用户', 'im_user', 2, 1, '即时通讯系统普通用户', NOW(), NOW());

-- 插入用户数据（密码都是123456的MD5加密：e10adc3949ba59abbe56e057f20f883e）
INSERT INTO `sys_user` (`id`, `username`, `password`, `nickname`, `email`, `phone`, `gender`, `dept_id`, `status`, `remark`, `create_time`, `update_time`) VALUES
(1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', '系统管理员', 'admin@example.com', '13800138000', 1, 1, 1, '系统管理员账号', NOW(), NOW()),
(2, 'test', 'e10adc3949ba59abbe56e057f20f883e', '测试用户', 'test@example.com', '13800138001', 2, 2, 1, '测试用户账号', NOW(), NOW());

-- 插入用户角色关联数据
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES
(1, 1),
(2, 2);

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
  (SELECT COUNT(*) FROM sys_config WHERE deleted = 0) as '配置数';

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