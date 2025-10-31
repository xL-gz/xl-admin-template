package com.xl.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.xl.system.entity.Role;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 角色信息Mapper接口
 */
@Mapper
public interface RoleMapper extends BaseMapper<Role> {
    
    /**
     * 根据用户ID查询角色
     */
    List<Role> selectRolesByUserId(@Param("userId") Long userId);
}


