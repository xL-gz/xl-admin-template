-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- 主机： localhost
-- 生成日期： 2026-01-06 18:06:40
-- 服务器版本： 5.7.44-log
-- PHP 版本： 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 数据库： `xl_im`
--

-- --------------------------------------------------------

--
-- 表的结构 `sys_button_authorize`
--

CREATE TABLE `sys_button_authorize` (
  `id` varchar(50) NOT NULL COMMENT '权限ID',
  `menu_id` bigint(20) NOT NULL COMMENT '所属菜单ID',
  `en_code` varchar(50) NOT NULL COMMENT '权限编码',
  `full_name` varchar(100) NOT NULL COMMENT '权限名称',
  `icon` varchar(100) DEFAULT NULL COMMENT '图标',
  `url_address` varchar(255) DEFAULT NULL COMMENT '请求地址',
  `sort_code` int(11) DEFAULT '0' COMMENT '排序',
  `enabled_mark` tinyint(4) DEFAULT '1' COMMENT '启用状态（0禁用 1启用）',
  `description` varchar(500) DEFAULT NULL COMMENT '描述',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint(4) DEFAULT '0' COMMENT '删除标志'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='按钮权限表';

--
-- 转存表中的数据 `sys_button_authorize`
--

INSERT INTO `sys_button_authorize` (`id`, `menu_id`, `en_code`, `full_name`, `icon`, `url_address`, `sort_code`, `enabled_mark`, `description`, `create_time`, `update_time`, `deleted`) VALUES
('btn_group_add', 4, 'add', '创建群组', 'icon-ym icon-ym-btn-add', '/im/group', 1, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
('btn_group_delete', 4, 'delete', '解散群组', 'icon-ym icon-ym-btn-delete', '/im/group/{id}', 3, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
('btn_group_edit', 4, 'edit', '编辑', 'icon-ym icon-ym-btn-edit', '/im/group/{id}', 2, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
('btn_group_member', 4, 'member', '成员管理', 'icon-ym icon-ym-btn-member', '/im/group/members', 4, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
('btn_role_add', 13, 'add', '新增', 'icon-ym icon-ym-btn-add', '/system/role', 1, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
('btn_role_auth', 13, 'auth', '分配权限', 'icon-ym icon-ym-btn-auth', '/system/role/authorize', 4, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
('btn_role_delete', 13, 'delete', '删除', 'icon-ym icon-ym-btn-delete', '/system/role/{id}', 3, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
('btn_role_edit', 13, 'edit', '编辑', 'icon-ym icon-ym-btn-edit', '/system/role/{id}', 2, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
('btn_user_add', 12, 'add', '新增', 'icon-ym icon-ym-btn-add', '/system/user', 1, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
('btn_user_delete', 12, 'delete', '删除', 'icon-ym icon-ym-btn-delete', '/system/user/{id}', 3, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0);

-- --------------------------------------------------------

--
-- 表的结构 `sys_column_authorize`
--

CREATE TABLE `sys_column_authorize` (
  `id` varchar(50) NOT NULL COMMENT '权限ID',
  `menu_id` bigint(20) NOT NULL COMMENT '所属菜单ID',
  `en_code` varchar(50) NOT NULL COMMENT '字段编码',
  `full_name` varchar(100) NOT NULL COMMENT '字段名称',
  `sort_code` int(11) DEFAULT '0' COMMENT '排序',
  `enabled_mark` tinyint(4) DEFAULT '1' COMMENT '启用状态',
  `description` varchar(500) DEFAULT NULL COMMENT '描述',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint(4) DEFAULT '0' COMMENT '删除标志'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='列表权限表';

--
-- 转存表中的数据 `sys_column_authorize`
--

INSERT INTO `sys_column_authorize` (`id`, `menu_id`, `en_code`, `full_name`, `sort_code`, `enabled_mark`, `description`, `create_time`, `update_time`, `deleted`) VALUES
('col_user_create_time', 12, 'createTime', '创建时间', 7, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
('col_user_dept', 12, 'deptName', '部门', 5, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
('col_user_email', 12, 'email', '邮箱', 3, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
('col_user_nickname', 12, 'nickname', '昵称', 2, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
('col_user_phone', 12, 'phone', '手机号', 4, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
('col_user_status', 12, 'status', '状态', 6, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
('col_user_username', 12, 'username', '用户名', 1, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0);

-- --------------------------------------------------------

--
-- 表的结构 `sys_config`
--

CREATE TABLE `sys_config` (
  `id` bigint(20) NOT NULL COMMENT '配置ID',
  `config_name` varchar(100) NOT NULL COMMENT '配置名称',
  `config_key` varchar(100) NOT NULL COMMENT '配置键名',
  `config_value` varchar(500) DEFAULT NULL COMMENT '配置键值',
  `config_type` char(1) DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint(4) DEFAULT '0' COMMENT '删除标志'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统配置表';

--
-- 转存表中的数据 `sys_config`
--

INSERT INTO `sys_config` (`id`, `config_name`, `config_key`, `config_value`, `config_type`, `remark`, `create_time`, `update_time`, `deleted`) VALUES
(1, '系统名称', 'sys.name', 'XL即时通讯系统', 'Y', '系统名称', '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
(2, '系统版本', 'sys.version', 'v1.0.0', 'Y', '系统版本号', '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
(3, '是否开放注册', 'sys.account.registerUser', 'false', 'Y', '是否开放用户注册功能', '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
(4, 'Token超时时间', 'sys.token.timeout', '7200', 'Y', 'Token超时时间（秒）', '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
(5, '密码错误次数限制', 'sys.password.maxRetry', '5', 'Y', '密码错误次数限制', '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0);

-- --------------------------------------------------------

--
-- 表的结构 `sys_data_authorize`
--

CREATE TABLE `sys_data_authorize` (
  `id` varchar(50) NOT NULL COMMENT '权限ID',
  `menu_id` bigint(20) NOT NULL COMMENT '所属菜单ID',
  `en_code` varchar(50) NOT NULL COMMENT '权限编码',
  `full_name` varchar(100) NOT NULL COMMENT '权限名称',
  `condition_text` text COMMENT '数据权限条件',
  `condition_sql` text COMMENT '数据权限SQL',
  `sort_code` int(11) DEFAULT '0' COMMENT '排序',
  `enabled_mark` tinyint(4) DEFAULT '1' COMMENT '启用状态',
  `description` varchar(500) DEFAULT NULL COMMENT '描述',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint(4) DEFAULT '0' COMMENT '删除标志'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='数据权限表';

-- --------------------------------------------------------

--
-- 表的结构 `sys_dept`
--

CREATE TABLE `sys_dept` (
  `id` bigint(20) NOT NULL COMMENT '部门ID',
  `parent_id` bigint(20) DEFAULT '0' COMMENT '父部门ID',
  `dept_name` varchar(50) NOT NULL COMMENT '部门名称',
  `dept_code` varchar(50) DEFAULT NULL COMMENT '部门编码',
  `leader` varchar(50) DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `sort_code` int(11) DEFAULT '0' COMMENT '显示顺序',
  `status` tinyint(4) DEFAULT '1' COMMENT '部门状态（0停用 1正常）',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint(4) DEFAULT '0' COMMENT '删除标志'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='部门表';

--
-- 转存表中的数据 `sys_dept`
--

INSERT INTO `sys_dept` (`id`, `parent_id`, `dept_name`, `dept_code`, `leader`, `phone`, `email`, `sort_code`, `status`, `create_time`, `update_time`, `deleted`) VALUES
(1, 0, '总公司', 'ROOT', '张三', NULL, NULL, 0, 1, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
(2, 1, '技术部', 'TECH', '李四', NULL, NULL, 1, 1, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
(3, 1, '市场部', 'MARKET', '王五', NULL, NULL, 2, 1, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0);

-- --------------------------------------------------------

--
-- 表的结构 `sys_form_authorize`
--

CREATE TABLE `sys_form_authorize` (
  `id` varchar(50) NOT NULL COMMENT '权限ID',
  `menu_id` bigint(20) NOT NULL COMMENT '所属菜单ID',
  `en_code` varchar(50) NOT NULL COMMENT '字段编码',
  `full_name` varchar(100) NOT NULL COMMENT '字段名称',
  `sort_code` int(11) DEFAULT '0' COMMENT '排序',
  `enabled_mark` tinyint(4) DEFAULT '1' COMMENT '启用状态',
  `description` varchar(500) DEFAULT NULL COMMENT '描述',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint(4) DEFAULT '0' COMMENT '删除标志'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='表单权限表';

--
-- 转存表中的数据 `sys_form_authorize`
--

INSERT INTO `sys_form_authorize` (`id`, `menu_id`, `en_code`, `full_name`, `sort_code`, `enabled_mark`, `description`, `create_time`, `update_time`, `deleted`) VALUES
('form_user_dept', 12, 'deptId', '所属部门', 6, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
('form_user_email', 12, 'email', '邮箱', 4, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
('form_user_nickname', 12, 'nickname', '昵称', 3, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
('form_user_password', 12, 'password', '密码', 2, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
('form_user_phone', 12, 'phone', '手机号', 5, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
('form_user_role', 12, 'roleIds', '角色', 7, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
('form_user_status', 12, 'status', '状态', 8, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
('form_user_username', 12, 'username', '用户名', 1, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0);

-- --------------------------------------------------------

--
-- 表的结构 `sys_log`
--

CREATE TABLE `sys_log` (
  `id` bigint(20) NOT NULL COMMENT '日志ID',
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户ID',
  `username` varchar(50) DEFAULT NULL COMMENT '用户账号',
  `operation` varchar(50) DEFAULT NULL COMMENT '操作类型',
  `method` varchar(200) DEFAULT NULL COMMENT '请求方法',
  `params` text COMMENT '请求参数',
  `ip` varchar(50) DEFAULT NULL COMMENT 'IP地址',
  `location` varchar(100) DEFAULT NULL COMMENT '操作地点',
  `status` tinyint(4) DEFAULT '1' COMMENT '操作状态（0失败 1成功）',
  `error_msg` text COMMENT '错误消息',
  `execute_time` int(11) DEFAULT '0' COMMENT '执行时长(毫秒)',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作日志表';

-- --------------------------------------------------------

--
-- 表的结构 `sys_menu`
--

CREATE TABLE `sys_menu` (
  `id` bigint(20) NOT NULL COMMENT '菜单ID',
  `system_id` varchar(50) DEFAULT NULL COMMENT '所属应用系统ID',
  `menu_name` varchar(50) NOT NULL COMMENT '菜单名称',
  `full_name` varchar(100) DEFAULT NULL COMMENT '菜单全称',
  `en_code` varchar(50) DEFAULT NULL COMMENT '菜单编码',
  `parent_id` bigint(20) DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int(11) DEFAULT '0' COMMENT '显示顺序',
  `sort_code` int(11) DEFAULT '0' COMMENT '排序码',
  `path` varchar(200) DEFAULT '' COMMENT '路由地址',
  `url_address` varchar(255) DEFAULT NULL COMMENT '菜单地址/组件路径',
  `component` varchar(255) DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) DEFAULT NULL COMMENT '路由参数',
  `is_frame` tinyint(4) DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `link_target` varchar(20) DEFAULT '_self' COMMENT '链接打开方式（_self=当前窗口 _blank=新窗口）',
  `is_cache` tinyint(4) DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `type` tinyint(4) DEFAULT '2' COMMENT '菜单类型编号（1=目录 2=菜单 3=按钮 4=字典 5=报表 6=大屏 7=外链 8=门户 9=流程）',
  `category` varchar(20) DEFAULT 'Web' COMMENT '分类（Web/App）',
  `visible` char(1) DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `enabled_mark` tinyint(4) DEFAULT '1' COMMENT '启用状态（0禁用 1启用）',
  `perms` varchar(100) DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) DEFAULT '#' COMMENT '菜单图标',
  `property_json` text COMMENT '扩展属性JSON',
  `remark` varchar(500) DEFAULT '' COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint(4) DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜单权限表';

--
-- 转存表中的数据 `sys_menu`
--

INSERT INTO `sys_menu` (`id`, `system_id`, `menu_name`, `full_name`, `en_code`, `parent_id`, `order_num`, `sort_code`, `path`, `url_address`, `component`, `query`, `is_frame`, `link_target`, `is_cache`, `menu_type`, `type`, `category`, `visible`, `status`, `enabled_mark`, `perms`, `icon`, `property_json`, `remark`, `create_time`, `update_time`, `deleted`) VALUES
(1, 'im-system', '工作台', '工作台', 'dashboard', 0, 1, 1, '/dashboard', 'basic/home/index', 'basic/home/index', NULL, 1, '_self', 0, 'C', 2, 'Web', '0', '0', 1, '', 'icon-ym icon-ym-nav-home', '{}', '工作台首页', '2025-10-30 11:08:28', '2025-10-31 14:06:47', 1),
(2, 'im-system', '即时通讯', '即时通讯', 'im', 0, 2, 2, '/im', NULL, NULL, NULL, 1, '_self', 0, 'M', 1, 'Web', '0', '0', 1, '', 'icon-ym icon-ym-nav-im', '{}', 'IM模块', '2025-10-30 11:08:28', '2025-10-31 14:06:45', 1),
(3, 'im-system', '聊天', '聊天管理', 'im-chat', 2, 1, 1, '/im/chat', 'im/Chat', 'im/Chat', NULL, 1, '_self', 0, 'C', 2, 'Web', '0', '0', 1, 'im:chat:view', 'icon-ym icon-ym-chat', '{\"moduleId\":\"im-chat\"}', '聊天功能', '2025-10-30 11:08:28', '2025-10-31 14:06:43', 1),
(4, 'im-system', '群组', '群组管理', 'im-group', 2, 2, 2, '/im/group', 'im/Group', 'im/Group', NULL, 1, '_self', 0, 'C', 2, 'Web', '0', '0', 1, 'im:group:view', 'icon-ym icon-ym-group', '{\"moduleId\":\"im-group\"}', '群组管理', '2025-10-30 11:08:28', '2025-10-31 14:06:42', 1),
(5, 'im-system', '好友', '好友管理', 'im-friends', 2, 3, 3, '/im/friends', 'im/Friends', 'im/Friends', NULL, 1, '_self', 0, 'C', 2, 'Web', '0', '0', 1, 'im:friends:view', 'icon-ym icon-ym-user', '{\"moduleId\":\"im-friends\"}', '好友管理', '2025-10-30 11:08:28', '2025-10-31 14:06:37', 1),
(6, 'im-system', '通讯录', '通讯录', 'im-contacts', 2, 4, 4, '/im/contacts', 'im/Contacts', 'im/Contacts', NULL, 1, '_self', 0, 'C', 2, 'Web', '0', '0', 1, 'im:contacts:view', 'icon-ym icon-ym-contacts', '{\"moduleId\":\"im-contacts\"}', '通讯录', '2025-10-30 11:08:28', '2025-10-31 14:06:32', 1),
(10, 'admin-system', '系统管理', '系统管理', 'system', 0, 1, 1, '/system', NULL, NULL, NULL, 1, '_self', 0, 'M', 1, 'Web', '0', '0', 1, '', 'icon-ym icon-ym-nav-system', '{}', '系统管理模块', '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
(11, 'admin-system', '应用管理', '应用系统管理', 'system-app', 10, 1, 1, '/system/app', 'system/menu/index', 'system/menu/index', NULL, 1, '_self', 0, 'C', 2, 'Web', '0', '0', 1, 'system:app:view', 'icon-ym icon-ym-app', '{\"moduleId\":\"system-app\"}', '应用系统管理', '2025-10-30 11:08:28', '2025-11-03 17:06:21', 0),
(12, 'admin-system', '用户管理', '用户管理', 'system-user', 10, 2, 2, '/system/user', 'permission/user/index', 'permission/user/index', NULL, 1, '_self', 0, 'C', 2, 'Web', '0', '0', 1, 'system:user:view', 'icon-ym icon-ym-user', '{\"moduleId\":\"system-user\"}', '用户管理', '2025-10-30 11:08:28', '2025-10-31 14:31:47', 1),
(13, 'admin-system', '角色管理', '角色管理', 'system-role', 10, 3, 3, '/system/role', 'permission/role/index', 'permission/role/index', NULL, 1, '_self', 0, 'C', 2, 'Web', '0', '0', 1, 'system:role:view', 'icon-ym icon-ym-role', '{\"moduleId\":\"system-role\"}', '角色管理', '2025-10-30 11:08:28', '2025-10-31 14:31:45', 1);

-- --------------------------------------------------------

--
-- 表的结构 `sys_role`
--

CREATE TABLE `sys_role` (
  `id` bigint(20) NOT NULL COMMENT '角色ID',
  `role_name` varchar(30) NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) NOT NULL COMMENT '角色权限字符串',
  `role_sort` int(11) DEFAULT '0' COMMENT '显示顺序',
  `data_scope` tinyint(4) DEFAULT '1' COMMENT '数据权限范围（1全部 2自定义 3本部门 4本部门及以下 5仅本人）',
  `status` tinyint(4) DEFAULT '1' COMMENT '角色状态（0停用 1正常）',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint(4) DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色信息表';

--
-- 转存表中的数据 `sys_role`
--

INSERT INTO `sys_role` (`id`, `role_name`, `role_key`, `role_sort`, `data_scope`, `status`, `remark`, `create_time`, `update_time`, `deleted`) VALUES
(1, '超级管理员', 'admin', 1, 1, 1, '超级管理员，拥有所有权限', '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
(2, 'IM用户', 'im_user', 2, 5, 1, '即时通讯普通用户', '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
(3, '系统管理员', 'sys_admin', 3, 2, 1, '系统管理员，管理系统配置', '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0);

-- --------------------------------------------------------

--
-- 表的结构 `sys_role_authorize`
--

CREATE TABLE `sys_role_authorize` (
  `id` bigint(20) NOT NULL COMMENT '主键ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `authorize_id` varchar(50) NOT NULL COMMENT '权限ID',
  `authorize_type` varchar(20) NOT NULL COMMENT '权限类型（button/column/form/data）',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色权限关联表';

--
-- 转存表中的数据 `sys_role_authorize`
--

INSERT INTO `sys_role_authorize` (`id`, `role_id`, `authorize_id`, `authorize_type`, `create_time`) VALUES
(1, 1, 'btn_user_add', 'button', '2025-10-30 11:08:28'),
(2, 1, 'btn_user_edit', 'button', '2025-10-30 11:08:28'),
(3, 1, 'btn_user_delete', 'button', '2025-10-30 11:08:28'),
(4, 1, 'btn_user_export', 'button', '2025-10-30 11:08:28'),
(5, 1, 'btn_user_import', 'button', '2025-10-30 11:08:28'),
(6, 1, 'btn_user_reset', 'button', '2025-10-30 11:08:28'),
(7, 1, 'btn_role_add', 'button', '2025-10-30 11:08:28'),
(8, 1, 'btn_role_edit', 'button', '2025-10-30 11:08:28'),
(9, 1, 'btn_role_delete', 'button', '2025-10-30 11:08:28'),
(10, 1, 'btn_role_auth', 'button', '2025-10-30 11:08:28');

-- --------------------------------------------------------

--
-- 表的结构 `sys_role_menu`
--

CREATE TABLE `sys_role_menu` (
  `id` bigint(20) NOT NULL COMMENT '主键ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `menu_id` bigint(20) NOT NULL COMMENT '菜单ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色和菜单关联表';

--
-- 转存表中的数据 `sys_role_menu`
--

INSERT INTO `sys_role_menu` (`id`, `role_id`, `menu_id`, `create_time`) VALUES
(1, 1, 1, '2025-10-30 11:08:28'),
(2, 1, 2, '2025-10-30 11:08:28'),
(3, 1, 3, '2025-10-30 11:08:28'),
(4, 1, 4, '2025-10-30 11:08:28'),
(5, 1, 5, '2025-10-30 11:08:28'),
(6, 1, 6, '2025-10-30 11:08:28'),
(7, 1, 10, '2025-10-30 11:08:28'),
(8, 1, 11, '2025-10-30 11:08:28'),
(9, 1, 12, '2025-10-30 11:08:28'),
(10, 1, 13, '2025-10-30 11:08:28');

-- --------------------------------------------------------

--
-- 表的结构 `sys_system`
--

CREATE TABLE `sys_system` (
  `id` varchar(50) NOT NULL COMMENT '系统ID',
  `en_code` varchar(50) NOT NULL COMMENT '系统编码',
  `full_name` varchar(100) NOT NULL COMMENT '系统名称',
  `description` varchar(500) DEFAULT NULL COMMENT '系统说明',
  `icon` varchar(100) DEFAULT NULL COMMENT '系统图标',
  `url_address` varchar(255) DEFAULT NULL COMMENT '系统地址',
  `sort_code` int(11) DEFAULT '0' COMMENT '排序码',
  `enabled_mark` tinyint(4) DEFAULT '1' COMMENT '启用状态（0禁用 1启用）',
  `is_main` tinyint(4) DEFAULT '0' COMMENT '是否主系统（0否 1是）',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint(4) DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='应用系统表';

--
-- 转存表中的数据 `sys_system`
--

INSERT INTO `sys_system` (`id`, `en_code`, `full_name`, `description`, `icon`, `url_address`, `sort_code`, `enabled_mark`, `is_main`, `create_time`, `update_time`, `deleted`) VALUES
('051c02d5a0434ff4900ca8e7f37919e4', 'wuliuSystem', '物流系统', NULL, 'icon-ym icon-ym-caret-right', NULL, 0, 1, 0, '2025-10-30 15:22:14', '2025-10-30 15:22:44', 1),
('8967b335f20e4712a3f151c63f395858', '1', '1', NULL, 'icon-ym icon-ym-header-notice', NULL, 0, 1, 0, '2025-10-31 11:48:40', '2025-10-31 13:33:01', 1),
('admin-system', 'adminSystem', '开发平台', '用于开发平台的所有调式所有功能', 'icon-ym icon-ym-thumb-mode', '/admin', 0, 1, 1, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0),
('im-system', 'imSystem', 'IM系统1', '即时通讯核心功能', 'icon-ym icon-ym-nav-im', '/im', 1, 1, 0, '2025-10-30 11:08:28', '2025-10-31 14:06:59', 1);

-- --------------------------------------------------------

--
-- 表的结构 `sys_user`
--

CREATE TABLE `sys_user` (
  `id` bigint(20) NOT NULL COMMENT '用户ID',
  `username` varchar(30) NOT NULL COMMENT '用户账号',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `nickname` varchar(30) DEFAULT NULL COMMENT '用户昵称',
  `email` varchar(50) DEFAULT NULL COMMENT '用户邮箱',
  `phone` varchar(11) DEFAULT NULL COMMENT '手机号码',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像地址',
  `gender` tinyint(4) DEFAULT '0' COMMENT '性别（0未知 1男 2女）',
  `dept_id` bigint(20) DEFAULT NULL COMMENT '部门ID',
  `position_id` bigint(20) DEFAULT NULL COMMENT '岗位ID',
  `status` tinyint(4) DEFAULT '1' COMMENT '帐号状态（0停用 1正常）',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint(4) DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户信息表';

--
-- 转存表中的数据 `sys_user`
--

INSERT INTO `sys_user` (`id`, `username`, `password`, `nickname`, `email`, `phone`, `avatar`, `gender`, `dept_id`, `position_id`, `status`, `remark`, `create_time`, `update_time`, `deleted`) VALUES
(1, 'admin', '$2a$10$rU46L49FCYs367oKtKcLWOWhRCbLZdQ8quFHEqsQ0wkgjIQwzKhpK', '超级管理员', 'admin@xl.com', '13800138000', '', 1, 1, NULL, 1, NULL, '2025-10-30 11:08:28', '2025-11-13 10:07:26', 0),
(2, 'test', '$2a$10$7JB720yubVSZfsvVWb5K5O9hf4A3qXC9E0kXdOQVE1ypHKXQ8fH.W', '测试用户', 'test@xl.com', '13800138001', '', 1, 2, NULL, 1, NULL, '2025-10-30 11:08:28', '2025-10-30 11:08:28', 0);

-- --------------------------------------------------------

--
-- 表的结构 `sys_user_role`
--

CREATE TABLE `sys_user_role` (
  `id` bigint(20) NOT NULL COMMENT '主键ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户和角色关联表';

--
-- 转存表中的数据 `sys_user_role`
--

INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `create_time`) VALUES
(1, 1, 1, '2025-10-30 11:08:28'),
(2, 2, 2, '2025-10-30 11:08:28');

--
-- 转储表的索引
--

--
-- 表的索引 `sys_button_authorize`
--
ALTER TABLE `sys_button_authorize`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_enabled_mark` (`enabled_mark`),
  ADD KEY `idx_menu_id` (`menu_id`);

--
-- 表的索引 `sys_column_authorize`
--
ALTER TABLE `sys_column_authorize`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_menu_id` (`menu_id`);

--
-- 表的索引 `sys_config`
--
ALTER TABLE `sys_config`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_config_key` (`config_key`);

--
-- 表的索引 `sys_data_authorize`
--
ALTER TABLE `sys_data_authorize`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_menu_id` (`menu_id`);

--
-- 表的索引 `sys_dept`
--
ALTER TABLE `sys_dept`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_parent_id` (`parent_id`);

--
-- 表的索引 `sys_form_authorize`
--
ALTER TABLE `sys_form_authorize`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_menu_id` (`menu_id`);

--
-- 表的索引 `sys_log`
--
ALTER TABLE `sys_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_create_time` (`create_time`),
  ADD KEY `idx_user_id` (`user_id`);

--
-- 表的索引 `sys_menu`
--
ALTER TABLE `sys_menu`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_enabled_mark` (`enabled_mark`),
  ADD KEY `idx_parent_id` (`parent_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_system_id` (`system_id`),
  ADD KEY `idx_type` (`type`);

--
-- 表的索引 `sys_role`
--
ALTER TABLE `sys_role`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_role_key` (`role_key`),
  ADD KEY `idx_status` (`status`);

--
-- 表的索引 `sys_role_authorize`
--
ALTER TABLE `sys_role_authorize`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_role_auth` (`role_id`,`authorize_id`,`authorize_type`),
  ADD KEY `idx_authorize_type` (`authorize_type`),
  ADD KEY `idx_role_id` (`role_id`);

--
-- 表的索引 `sys_role_menu`
--
ALTER TABLE `sys_role_menu`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_role_menu` (`role_id`,`menu_id`),
  ADD KEY `idx_menu_id` (`menu_id`),
  ADD KEY `idx_role_id` (`role_id`);

--
-- 表的索引 `sys_system`
--
ALTER TABLE `sys_system`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_en_code` (`en_code`),
  ADD KEY `idx_enabled_mark` (`enabled_mark`);

--
-- 表的索引 `sys_user`
--
ALTER TABLE `sys_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_username` (`username`),
  ADD KEY `idx_dept_id` (`dept_id`),
  ADD KEY `idx_status` (`status`);

--
-- 表的索引 `sys_user_role`
--
ALTER TABLE `sys_user_role`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_user_role` (`user_id`,`role_id`),
  ADD KEY `idx_role_id` (`role_id`),
  ADD KEY `idx_user_id` (`user_id`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `sys_config`
--
ALTER TABLE `sys_config`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '配置ID', AUTO_INCREMENT=6;

--
-- 使用表AUTO_INCREMENT `sys_dept`
--
ALTER TABLE `sys_dept`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '部门ID', AUTO_INCREMENT=4;

--
-- 使用表AUTO_INCREMENT `sys_log`
--
ALTER TABLE `sys_log`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志ID';

--
-- 使用表AUTO_INCREMENT `sys_menu`
--
ALTER TABLE `sys_menu`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '菜单ID', AUTO_INCREMENT=14;

--
-- 使用表AUTO_INCREMENT `sys_role`
--
ALTER TABLE `sys_role`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色ID', AUTO_INCREMENT=4;

--
-- 使用表AUTO_INCREMENT `sys_role_authorize`
--
ALTER TABLE `sys_role_authorize`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID', AUTO_INCREMENT=11;

--
-- 使用表AUTO_INCREMENT `sys_role_menu`
--
ALTER TABLE `sys_role_menu`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID', AUTO_INCREMENT=11;

--
-- 使用表AUTO_INCREMENT `sys_user_role`
--
ALTER TABLE `sys_user_role`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID', AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
