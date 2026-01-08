-- 修复刚才新增的菜单数据
-- 1. 设置正确的 system_id
-- 2. 修正 parent_id 从 -1 改为 0（顶级菜单）

UPDATE sys_menu 
SET system_id = 'admin-system', 
    parent_id = 0 
WHERE parent_id = -1 
  AND system_id IS NULL 
  AND create_time >= '2026-01-08 16:48:00';

-- 查看修复后的数据
SELECT id, system_id, menu_name, full_name, parent_id, type, create_time 
FROM sys_menu 
WHERE system_id = 'admin-system' 
ORDER BY parent_id, sort_code;