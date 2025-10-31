package com.xl.system.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.xl.system.dto.MenuDTO;
import com.xl.system.entity.Menu;

import java.util.List;

/**
 * 菜单权限Service接口
 */
public interface MenuService extends IService<Menu> {
    
    /**
     * 根据用户ID查询菜单权限
     */
    List<Menu> selectMenuListByUserId(Long userId);
    
    /**
     * 根据用户ID查询菜单树
     */
    List<MenuDTO> selectMenuTreeByUserId(Long userId);
    
    /**
     * 查询菜单树列表
     */
    List<MenuDTO> selectMenuTreeList();
    
    /**
     * 根据角色ID查询菜单权限
     */
    List<Menu> selectMenuListByRoleId(Long roleId);
    
    /**
     * 构建菜单树
     */
    List<MenuDTO> buildMenuTree(List<Menu> menus);
    
    /**
     * 新增菜单
     */
    boolean insertMenu(Menu menu);
    
    /**
     * 修改菜单
     */
    boolean updateMenu(Menu menu);
    
    /**
     * 删除菜单
     */
    boolean deleteMenu(Long menuId);
    
    /**
     * 是否存在菜单子节点
     */
    boolean hasChildByMenuId(Long menuId);
    
    /**
     * 查询菜单使用数量
     */
    boolean checkMenuExistRole(Long menuId);
    
    /**
     * 根据应用系统ID查询菜单树
     * @param systemId 应用系统ID
     * @param keyword 关键字
     * @param category 分类
     * @param type 类型
     * @param enabledMark 启用状态
     * @return 菜单树列表
     */
    List<MenuDTO> selectMenuTreeBySystemId(String systemId, String keyword, String category, Integer type, Integer enabledMark);
    
    /**
     * 获取菜单选择器（按systemId过滤）
     * @param parentId 父菜单ID
     * @param systemId 应用系统ID
     * @return 菜单列表
     */
    List<MenuDTO> selectMenuSelectorBySystemId(Long parentId, String systemId);
    
    /**
     * 根据菜单ID获取MenuDTO
     * @param menuId 菜单ID
     * @return MenuDTO
     */
    MenuDTO getMenuDTOById(Long menuId);
    
    /**
     * 新增菜单（支持MenuDTO）
     * @param menuDTO 菜单DTO
     * @return 结果
     */
    boolean insertMenu(MenuDTO menuDTO);
    
    /**
     * 修改菜单（支持MenuDTO）
     * @param menuDTO 菜单DTO
     * @return 结果
     */
    boolean updateMenu(MenuDTO menuDTO);
}


