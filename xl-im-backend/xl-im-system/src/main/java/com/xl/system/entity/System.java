package com.xl.system.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 应用系统表
 */
@Data
@TableName("sys_system")
public class System {
    
    /**
     * 系统ID
     */
    @TableId
    private String id;
    
    /**
     * 系统编码
     */
    private String enCode;
    
    /**
     * 系统名称
     */
    private String fullName;
    
    /**
     * 系统说明
     */
    private String description;
    
    /**
     * 系统图标
     */
    private String icon;
    
    /**
     * 系统地址
     */
    private String urlAddress;
    
    /**
     * 排序码
     */
    private Integer sortCode;
    
    /**
     * 启用状态（0禁用 1启用）
     */
    private Integer enabledMark;
    
    /**
     * 是否主系统（0否 1是）
     */
    private Integer isMain;
    
    /**
     * 创建时间
     */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    /**
     * 更新时间
     */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
    
    /**
     * 删除标记（0未删除 1已删除）
     */
    @TableLogic
    @TableField(fill = FieldFill.INSERT)
    private Integer deleted;
}

