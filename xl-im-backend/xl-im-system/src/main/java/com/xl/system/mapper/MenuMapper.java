package com.xl.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.xl.system.entity.Menu;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 菜单权限Mapper接口
 */
@Mapper
public interface MenuMapper extends BaseMapper<Menu> {
    
    /**
     * 根据用户ID查询菜单权限
     */
    List<Menu> selectMenuListByUserId(@Param("userId") Long userId);
    
    /**
     * 根据角色ID查询菜单权限
     */
    List<Menu> selectMenuListByRoleId(@Param("roleId") Long roleId);
    
    /**
     * 根据用户ID查询菜单树
     */
    List<Menu> selectMenuTreeByUserId(@Param("userId") Long userId);
}


