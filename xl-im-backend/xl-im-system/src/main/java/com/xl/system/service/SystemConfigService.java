package com.xl.system.service;

import com.xl.system.entity.SystemConfig;

import java.util.List;

/**
 * 系统配置服务接口
 */
public interface SystemConfigService {
    
    /**
     * 保存系统配置
     */
    SystemConfig save(SystemConfig systemConfig);
    
    /**
     * 根据ID获取系统配置
     */
    SystemConfig getById(String id);
    
    /**
     * 获取所有系统配置
     */
    List<SystemConfig> getAll();
    
    /**
     * 根据ID删除系统配置
     */
    void deleteById(String id);
    
    /**
     * 根据系统名称查找配置
     */
    SystemConfig getBySysName(String sysName);
}