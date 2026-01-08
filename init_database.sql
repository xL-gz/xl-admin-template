-- 创建数据库
CREATE DATABASE IF NOT EXISTS xl_im CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE xl_im;

-- 创建应用系统表
CREATE TABLE IF NOT EXISTS `sys_system` (
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
  `deleted` tinyint(4) DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_en_code` (`en_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='应用系统表';

-- 插入应用系统数据
INSERT INTO `sys_system` (`id`, `en_code`, `full_name`, `description`, `icon`, `url_address`, `sort_code`, `enabled_mark`, `is_main`) VALUES
('im-system', 'imSystem', 'IM系统', '即时通讯核心功能', 'icon-ym icon-ym-nav-im', '/im', 1, 1, 0),
('admin-system', 'adminSystem', '管理后台', '系统管理和配置', 'icon-ym icon-ym-nav-admin', '/admin', 2, 1, 1)
ON DUPLICATE KEY UPDATE 
  `full_name` = VALUES(`full_name`),
  `description` = VALUES(`description`),
  `enabled_mark` = VALUES(`enabled_mark`);

-- 创建菜单表
CREATE TABLE IF NOT EXISTS `sys_menu` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `system_id` varchar(50) DEFAULT NULL COMMENT '所属应用系统ID',
  `menu_name` varchar(50) NOT NULL COMMENT '菜单名称',
  `full_name` varchar(100) DEFAULT NULL COMMENT '菜单全称',
  `en_code` varchar(50) DEFAULT NULL COMMENT '菜单编码',
  `parent_id` bigint(20) DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int(11) DEFAULT '0' COMMENT '显示顺序',
  `sort_code` int(11) DEFAULT '0' COMMENT '排序码',
  `path` varchar(200) DEFAULT '' COMMENT '路由地址',
  `url_address` varchar(255) DEFAULT NULL COMMENT '菜单地址',
  `component` varchar(255) DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) DEFAULT NULL COMMENT '路由参数',
  `is_frame` int(1) DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int(1) DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `type` int(1) DEFAULT NULL COMMENT '菜单类型编号（1=目录 2=菜单 3=按钮）',
  `category` varchar(20) DEFAULT 'Web' COMMENT '菜单分类（Web/App）',
  `link_target` varchar(20) DEFAULT '_self' COMMENT '链接打开方式',
  `visible` char(1) DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `enabled_mark` int(1) DEFAULT '1' COMMENT '启用状态（0禁用 1启用）',
  `perms` varchar(100) DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) DEFAULT '#' COMMENT '菜单图标',
  `property_json` text COMMENT '扩展属性JSON',
  `remark` varchar(500) DEFAULT '' COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint(4) DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜单权限表';

-- 插入系统管理菜单
INSERT INTO `sys_menu` (`system_id`, `menu_name`, `full_name`, `en_code`, `parent_id`, `path`, `component`, `type`, `category`, `icon`, `sort_code`, `enabled_mark`) VALUES
('admin-system', '系统管理', '系统管理', 'system', 0, '/system', 'Layout', 1, 'Web', 'icon-ym icon-ym-nav-system', 1, 1),
('admin-system', '应用系统', '应用系统管理', 'system-app', 1, '/system/app', 'system/app/index', 2, 'Web', 'icon-ym icon-ym-nav-app', 1, 1)
ON DUPLICATE KEY UPDATE 
  `menu_name` = VALUES(`menu_name`),
  `enabled_mark` = VALUES(`enabled_mark`);

-- 验证数据
SELECT '========== 应用系统列表 ==========' as '';
SELECT id, en_code, full_name, enabled_mark FROM sys_system WHERE deleted = 0;

SELECT '========== 菜单列表 ==========' as '';
SELECT id, system_id, menu_name, parent_id, enabled_mark FROM sys_menu WHERE deleted = 0 ORDER BY system_id, parent_id, sort_code;