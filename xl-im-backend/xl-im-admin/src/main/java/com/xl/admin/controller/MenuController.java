package com.xl.admin.controller;

import com.xl.common.result.Result;
import com.xl.system.dto.MenuDTO;
import com.xl.system.entity.Menu;
import com.xl.system.service.MenuService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 菜单管理控制器
 */
@RestController
@RequestMapping("/api/system/Menu")
@RequiredArgsConstructor
public class MenuController {
    
    private final MenuService menuService;
    
    /**
     * 获取所有菜单列表（树形结构）
     */
    @GetMapping("/list")
    public Result<List<MenuDTO>> list() {
        List<MenuDTO> menuTree = menuService.selectMenuTreeList();
        return Result.success(menuTree);
    }
    
    /**
     * 根据应用系统ID获取菜单列表（树形结构）
     * GET /api/system/Menu/ModuleBySystem/{systemId}
     */
    @GetMapping("/ModuleBySystem/{systemId}")
    public Result<List<MenuDTO>> getMenuBySystemId(
            @PathVariable String systemId,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) Integer type,
            @RequestParam(required = false) Integer enabledMark) {
        List<MenuDTO> menuTree = menuService.selectMenuTreeBySystemId(systemId, keyword, category, type, enabledMark);
        return Result.success(menuTree);
    }
    
    /**
     * 获取上级菜单下拉框（带systemId过滤）
     * GET /api/system/Menu/Selector/{parentId}/{systemId}
     */
    @GetMapping("/Selector/{parentId}/{systemId}")
    public Result<List<MenuDTO>> getMenuSelector(
            @PathVariable Long parentId,
            @PathVariable String systemId) {
        List<MenuDTO> menus = menuService.selectMenuSelectorBySystemId(parentId, systemId);
        return Result.success(menus);
    }
    
    /**
     * 获取所有菜单选择器（不限应用系统）
     * GET /api/system/Menu/Selector/All
     */
    @GetMapping("/Selector/All")
    public Result<List<MenuDTO>> getAllMenuSelector() {
        List<MenuDTO> menus = menuService.selectMenuTreeList();
        return Result.success(menus);
    }
    
    /**
     * 根据用户ID获取菜单树
     */
    @GetMapping("/user/{userId}")
    public Result<List<MenuDTO>> getUserMenus(@PathVariable Long userId) {
        List<MenuDTO> menuTree = menuService.selectMenuTreeByUserId(userId);
        return Result.success(menuTree);
    }
    
    /**
     * 根据菜单ID获取详细信息
     */
    @GetMapping("/{menuId}")
    public Result<MenuDTO> getInfo(@PathVariable Long menuId) {
        MenuDTO menu = menuService.getMenuDTOById(menuId);
        if (menu == null) {
            return Result.error("菜单不存在");
        }
        return Result.success(menu);
    }
    
    /**
     * 新增菜单
     */
    @PostMapping
    public Result<String> add(@RequestBody MenuDTO menuDTO) {
        // 参数验证
        if (menuDTO.getMenuName() == null || menuDTO.getMenuName().trim().isEmpty()) {
            if (menuDTO.getFullName() == null || menuDTO.getFullName().trim().isEmpty()) {
                return Result.error("菜单名称不能为空");
            }
        }
        
        boolean success = menuService.insertMenu(menuDTO);
        return success ? Result.success("新增成功") : Result.error("新增失败");
    }
    
    /**
     * 修改菜单
     */
    @PutMapping("/{menuId}")
    public Result<String> edit(@PathVariable Long menuId, @RequestBody MenuDTO menuDTO) {
        menuDTO.setId(menuId);
        boolean success = menuService.updateMenu(menuDTO);
        return success ? Result.success("修改成功") : Result.error("修改失败");
    }
    
    /**
     * 删除菜单
     */
    @DeleteMapping("/{menuId}")
    public Result<String> remove(@PathVariable Long menuId) {
        try {
            if (menuService.hasChildByMenuId(menuId)) {
                return Result.error("存在子菜单,不允许删除");
            }
            if (menuService.checkMenuExistRole(menuId)) {
                return Result.error("菜单已分配,不允许删除");
            }
            boolean success = menuService.deleteMenu(menuId);
            return success ? Result.success("删除成功") : Result.error("删除失败");
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("删除失败: " + e.getMessage());
        }
    }
    
    /**
     * 导出系统菜单数据
     * GET /api/system/Menu/{id}/Actions/Export
     */
    @GetMapping("/{menuId}/Actions/Export")
    public Result<String> exportMenu(@PathVariable Long menuId) {
        // TODO: 实现菜单导出功能
        return Result.success("导出功能开发中");
    }
}


