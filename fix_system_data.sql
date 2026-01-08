-- 修复应用系统数据
-- 删除现有的无效数据
DELETE FROM `sys_system` WHERE `deleted` = 1;

-- 插入正确的应用系统数据
INSERT INTO `sys_system` (`id`, `en_code`, `full_name`, `description`, `icon`, `url_address`, `sort_code`, `enabled_mark`, `is_main`, `create_time`, `update_time`, `deleted`) VALUES
('im-system', 'imSystem', 'IM系统', '即时通讯核心功能', 'icon-ym icon-ym-nav-im', '/im', 1, 1, 0, NOW(), NOW(), 0),
('admin-system', 'adminSystem', '管理后台', '系统管理和配置', 'icon-ym icon-ym-nav-admin', '/admin', 2, 1, 1, NOW(), NOW(), 0);

-- 验证数据
SELECT * FROM `sys_system` WHERE `deleted` = 0;