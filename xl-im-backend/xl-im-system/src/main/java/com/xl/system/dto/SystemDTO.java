package com.xl.system.dto;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 应用系统DTO
 */
@Data
public class SystemDTO {
    
    /**
     * 系统ID
     */
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
    private LocalDateTime createTime;
    
    /**
     * 更新时间
     */
    private LocalDateTime updateTime;
}

