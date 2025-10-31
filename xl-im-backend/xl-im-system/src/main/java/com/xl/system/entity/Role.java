package com.xl.system.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.xl.common.entity.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 角色信息表
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_role")
public class Role extends BaseEntity {
    
    /**
     * 角色ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /**
     * 角色名称
     */
    private String roleName;
    
    /**
     * 角色权限字符串
     */
    private String roleKey;
    
    /**
     * 显示顺序
     */
    private Integer roleSort;
    
    /**
     * 角色状态（0停用 1正常）
     */
    private Integer status;
    
    /**
     * 备注
     */
    private String remark;
}


