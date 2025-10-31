package com.xl.system.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.xl.common.entity.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 菜单权限表
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_menu")
public class Menu extends BaseEntity {
    
    /**
     * 菜单ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /**
     * 所属应用系统ID
     */
    private String systemId;
    
    /**
     * 菜单名称
     */
    private String menuName;
    
    /**
     * 菜单全称
     */
    private String fullName;
    
    /**
     * 菜单编码
     */
    private String enCode;
    
    /**
     * 父菜单ID
     */
    private Long parentId;
    
    /**
     * 显示顺序
     */
    private Integer orderNum;
    
    /**
     * 排序码
     */
    private Integer sortCode;
    
    /**
     * 路由地址
     */
    private String path;
    
    /**
     * 菜单地址
     */
    private String urlAddress;
    
    /**
     * 组件路径
     */
    private String component;
    
    /**
     * 路由参数
     */
    private String query;
    
    /**
     * 是否为外链（0是 1否）
     */
    private Integer isFrame;
    
    /**
     * 是否缓存（0缓存 1不缓存）
     */
    private Integer isCache;
    
    /**
     * 菜单类型（M目录 C菜单 F按钮）
     */
    private String menuType;
    
    /**
     * 菜单类型编号（1=目录 2=菜单 3=按钮）
     */
    private Integer type;
    
    /**
     * 菜单分类（Web/App）
     */
    private String category;
    
    /**
     * 链接打开方式（_self=当前窗口 _blank=新窗口）
     */
    private String linkTarget;
    
    /**
     * 菜单状态（0显示 1隐藏）
     */
    private String visible;
    
    /**
     * 菜单状态（0正常 1停用）
     */
    private String status;
    
    /**
     * 启用状态（0禁用 1启用）
     */
    private Integer enabledMark;
    
    /**
     * 权限标识
     */
    private String perms;
    
    /**
     * 菜单图标
     */
    private String icon;
    
    /**
     * 扩展属性JSON
     */
    private String propertyJson;
    
    /**
     * 备注
     */
    private String remark;
}


