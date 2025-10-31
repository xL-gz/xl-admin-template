package com.xl.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.xl.system.entity.RoleMenu;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 角色和菜单关联Mapper接口
 */
@Mapper
public interface RoleMenuMapper extends BaseMapper<RoleMenu> {
    
    /**
     * 根据角色ID查询菜单ID列表
     */
    List<Long> selectMenuIdsByRoleId(@Param("roleId") Long roleId);
    
    /**
     * 根据菜单ID查询角色ID列表
     */
    List<Long> selectRoleIdsByMenuId(@Param("menuId") Long menuId);
}


