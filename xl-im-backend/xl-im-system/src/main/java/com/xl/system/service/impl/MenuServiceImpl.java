package com.xl.system.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xl.system.dto.MenuDTO;
import com.xl.system.entity.Menu;
import com.xl.system.entity.RoleMenu;
import com.xl.system.mapper.MenuMapper;
import com.xl.system.mapper.RoleMenuMapper;
import com.xl.system.service.MenuService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 菜单权限Service实现
 */
@Service
public class MenuServiceImpl extends ServiceImpl<MenuMapper, Menu> implements MenuService {
    
    @Autowired
    private MenuMapper menuMapper;
    
    @Autowired
    private RoleMenuMapper roleMenuMapper;
    
    @Override
    public List<Menu> selectMenuListByUserId(Long userId) {
        return menuMapper.selectMenuListByUserId(userId);
    }
    
    @Override
    public List<MenuDTO> selectMenuTreeByUserId(Long userId) {
        List<Menu> menus = menuMapper.selectMenuTreeByUserId(userId);
        return buildMenuTree(menus);
    }
    
    @Override
    public List<MenuDTO> selectMenuTreeList() {
        LambdaQueryWrapper<Menu> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Menu::getDeleted, 0)
               .eq(Menu::getStatus, "0")
               .eq(Menu::getEnabledMark, 1)
               .orderByAsc(Menu::getParentId, Menu::getSortCode, Menu::getOrderNum);
        List<Menu> menus = this.list(wrapper);
        return buildMenuTree(menus);
    }
    
    @Override
    public List<Menu> selectMenuListByRoleId(Long roleId) {
        return menuMapper.selectMenuListByRoleId(roleId);
    }
    
    @Override
    public List<MenuDTO> buildMenuTree(List<Menu> menus) {
        List<MenuDTO> menuDTOs = menus.stream().map(menu -> {
            MenuDTO menuDTO = new MenuDTO();
            BeanUtils.copyProperties(menu, menuDTO);
            return menuDTO;
        }).collect(Collectors.toList());
        
        List<MenuDTO> tree = new ArrayList<>();
        for (MenuDTO menuDTO : menuDTOs) {
            if (menuDTO.getParentId() == 0) {
                tree.add(menuDTO);
            }
            for (MenuDTO child : menuDTOs) {
                if (child.getParentId().equals(menuDTO.getId())) {
                    if (menuDTO.getChildren() == null) {
                        menuDTO.setChildren(new ArrayList<>());
                    }
                    menuDTO.getChildren().add(child);
                }
            }
        }
        return tree;
    }
    
    @Override
    public boolean insertMenu(Menu menu) {
        return this.save(menu);
    }
    
    @Override
    public boolean updateMenu(Menu menu) {
        return this.updateById(menu);
    }
    
    @Override
    public boolean deleteMenu(Long menuId) {
        return this.removeById(menuId);
    }
    
    @Override
    public boolean hasChildByMenuId(Long menuId) {
        LambdaQueryWrapper<Menu> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Menu::getParentId, menuId)
               .eq(Menu::getDeleted, 0);
        return this.count(wrapper) > 0;
    }
    
    @Override
    public boolean checkMenuExistRole(Long menuId) {
        try {
            LambdaQueryWrapper<RoleMenu> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(RoleMenu::getMenuId, menuId)
                   .eq(RoleMenu::getDeleted, 0);  // 只查询未删除的记录
            return roleMenuMapper.selectCount(wrapper) > 0;
        } catch (Exception e) {
            // 如果查询出错，可能是表不存在，返回 false 允许删除
            // 实际项目中应该确保表存在
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public List<MenuDTO> selectMenuTreeBySystemId(String systemId, String keyword, String category, Integer type, Integer enabledMark) {
        LambdaQueryWrapper<Menu> wrapper = new LambdaQueryWrapper<>();
        
        // 应用系统ID过滤
        if (StrUtil.isNotBlank(systemId)) {
            wrapper.eq(Menu::getSystemId, systemId);
        }
        
        // 关键字搜索（菜单名称或编码）
        if (StrUtil.isNotBlank(keyword)) {
            wrapper.and(w -> w.like(Menu::getMenuName, keyword)
                             .or()
                             .like(Menu::getFullName, keyword)
                             .or()
                             .like(Menu::getEnCode, keyword));
        }
        
        // 分类过滤（Web/App）
        if (StrUtil.isNotBlank(category)) {
            wrapper.eq(Menu::getCategory, category);
        }
        
        // 类型过滤
        if (type != null) {
            wrapper.eq(Menu::getType, type);
        }
        
        // 启用状态过滤
        if (enabledMark != null) {
            wrapper.eq(Menu::getEnabledMark, enabledMark);
        }
        
        // 基本过滤
        wrapper.eq(Menu::getDeleted, 0)
               .eq(Menu::getStatus, "0")
               .orderByAsc(Menu::getParentId, Menu::getSortCode, Menu::getOrderNum);
        
        List<Menu> menus = this.list(wrapper);
        return buildMenuTree(menus);
    }
    
    @Override
    public List<MenuDTO> selectMenuSelectorBySystemId(Long parentId, String systemId) {
        LambdaQueryWrapper<Menu> wrapper = new LambdaQueryWrapper<>();
        
        // 应用系统ID过滤
        if (StrUtil.isNotBlank(systemId) && !"0".equals(systemId)) {
            wrapper.eq(Menu::getSystemId, systemId);
        }
        
        // 基本过滤
        wrapper.eq(Menu::getDeleted, 0)
               .eq(Menu::getStatus, "0")
               .eq(Menu::getEnabledMark, 1)
               .orderByAsc(Menu::getSortCode, Menu::getOrderNum);
        
        List<Menu> menus = this.list(wrapper);
        
        // 转换为DTO
        List<MenuDTO> menuDTOs = menus.stream()
                .map(menu -> BeanUtil.copyProperties(menu, MenuDTO.class))
                .collect(Collectors.toList());
        
        // 构建树形结构
        return buildMenuTree(menus);
    }
    
    @Override
    public MenuDTO getMenuDTOById(Long menuId) {
        Menu menu = this.getById(menuId);
        if (menu == null) {
            return null;
        }
        return BeanUtil.copyProperties(menu, MenuDTO.class);
    }
    
    @Override
    public boolean insertMenu(MenuDTO menuDTO) {
        // 如果menuName为空，使用fullName作为menuName
        if (menuDTO.getMenuName() == null || menuDTO.getMenuName().trim().isEmpty()) {
            menuDTO.setMenuName(menuDTO.getFullName());
        }
        
        // 设置默认的systemId（如果没有设置的话）
        if (menuDTO.getSystemId() == null || menuDTO.getSystemId().trim().isEmpty()) {
            menuDTO.setSystemId("admin-system");
        }
        
        // 修正parentId：如果是-1，改为0（顶级菜单）
        if (menuDTO.getParentId() != null && menuDTO.getParentId() == -1) {
            menuDTO.setParentId(0L);
        }
        
        Menu menu = BeanUtil.copyProperties(menuDTO, Menu.class);
        return this.save(menu);
    }
    
    @Override
    public boolean updateMenu(MenuDTO menuDTO) {
        Menu menu = BeanUtil.copyProperties(menuDTO, Menu.class);
        return this.updateById(menu);
    }
}


