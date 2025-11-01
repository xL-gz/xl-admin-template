package com.xl.admin.controller;

import cn.dev33.satoken.annotation.SaIgnore;
import com.xl.common.result.Result;
import com.xl.system.entity.SystemConfig;
import com.xl.system.service.SystemConfigService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 系统配置控制器
 */
@RestController
@RequiredArgsConstructor
public class SystemConfigController {
    
    private final SystemConfigService systemConfigService;
    
    /**
     * 前端需要的系统配置接口 - GET /api/system/SysConfig
     */
    @GetMapping("/api/system/SysConfig")
    @SaIgnore
    public Result<SystemConfig> getSysConfig() {
        // 获取所有配置，返回第一个（如果没有则返回默认配置）
        List<SystemConfig> configs = systemConfigService.getAll();
        if (configs != null && !configs.isEmpty()) {
            SystemConfig config = configs.get(0);
            // 确保数组字段不为null
            if (config.getOssStorageConfigs() == null) {
                config.setOssStorageConfigs(new java.util.ArrayList<>());
            }
            if (config.getCloudServerStorageConfigs() == null) {
                config.setCloudServerStorageConfigs(new java.util.ArrayList<>());
            }
            return Result.success(config);
        }
        // 如果没有配置，返回一个默认配置
        SystemConfig defaultConfig = new SystemConfig();
        defaultConfig.setTitle("XL即时通讯系统");
        defaultConfig.setSysName("XL IM System");
        defaultConfig.setSysVersion("1.0.0");
        defaultConfig.setCopyright("Copyright © 2025 XL");
        defaultConfig.setMandatoryModificationOfInitialPassword(0);
        // 初始化数组字段
        defaultConfig.setOssStorageConfigs(new java.util.ArrayList<>());
        defaultConfig.setCloudServerStorageConfigs(new java.util.ArrayList<>());
        return Result.success(defaultConfig);
    }
    
    /**
     * 前端需要的系统配置接口 - PUT /api/system/SysConfig
     */
    @PutMapping("/api/system/SysConfig")
    public Result<SystemConfig> updateSysConfig(@RequestBody SystemConfig systemConfig) {
        // 打印接收到的数据
        System.out.println("=== 接收到的配置数据 ===");
        System.out.println("ID: " + systemConfig.getId());
        System.out.println("云服务器配置数量: " + (systemConfig.getCloudServerStorageConfigs() != null ? systemConfig.getCloudServerStorageConfigs().size() : 0));
        if (systemConfig.getCloudServerStorageConfigs() != null) {
            systemConfig.getCloudServerStorageConfigs().forEach(config -> {
                System.out.println("  - 名称: " + config.getName() + ", 路径: " + config.getStoragePath());
            });
        }
        
        // 确保ID存在，如果没有则设置默认ID
        if (systemConfig.getId() == null || systemConfig.getId().isEmpty()) {
            List<SystemConfig> existingConfigs = systemConfigService.getAll();
            if (existingConfigs != null && !existingConfigs.isEmpty()) {
                // 使用现有配置的ID
                systemConfig.setId(existingConfigs.get(0).getId());
            } else {
                // 新建配置，使用默认ID
                systemConfig.setId("default_config");
            }
        }
        
        // 确保数组字段不为null
        if (systemConfig.getOssStorageConfigs() == null) {
            systemConfig.setOssStorageConfigs(new java.util.ArrayList<>());
        }
        if (systemConfig.getCloudServerStorageConfigs() == null) {
            systemConfig.setCloudServerStorageConfigs(new java.util.ArrayList<>());
        }
        
        SystemConfig savedConfig = systemConfigService.save(systemConfig);
        
        // 打印保存后的数据
        System.out.println("=== 保存后的配置数据 ===");
        System.out.println("ID: " + savedConfig.getId());
        System.out.println("云服务器配置数量: " + (savedConfig.getCloudServerStorageConfigs() != null ? savedConfig.getCloudServerStorageConfigs().size() : 0));
        if (savedConfig.getCloudServerStorageConfigs() != null) {
            savedConfig.getCloudServerStorageConfigs().forEach(config -> {
                System.out.println("  - 名称: " + config.getName() + ", 路径: " + config.getStoragePath());
            });
        }
        
        // 确保返回的数据中数组字段不为null
        if (savedConfig.getOssStorageConfigs() == null) {
            savedConfig.setOssStorageConfigs(new java.util.ArrayList<>());
        }
        if (savedConfig.getCloudServerStorageConfigs() == null) {
            savedConfig.setCloudServerStorageConfigs(new java.util.ArrayList<>());
        }
        
        return Result.success(savedConfig, "更新成功");
    }
    
    /**
     * 保存系统配置
     */
    @PostMapping("/system/config")
    public Result<SystemConfig> save(@RequestBody SystemConfig systemConfig) {
        SystemConfig savedConfig = systemConfigService.save(systemConfig);
        return Result.success(savedConfig, "保存成功");
    }
    
    /**
     * 根据ID获取系统配置
     */
    @GetMapping("/system/config/{id}")
    public Result<SystemConfig> getById(@PathVariable String id) {
        SystemConfig config = systemConfigService.getById(id);
        return Result.success(config);
    }
    
    /**
     * 获取所有系统配置
     */
    @GetMapping("/system/config")
    public Result<List<SystemConfig>> getAll() {
        List<SystemConfig> configs = systemConfigService.getAll();
        return Result.success(configs);
    }
    
    /**
     * 根据ID删除系统配置
     */
    @DeleteMapping("/system/config/{id}")
    public Result<String> deleteById(@PathVariable String id) {
        systemConfigService.deleteById(id);
        return Result.success("删除成功");
    }
    
    /**
     * 根据系统名称查找配置
     */
    @GetMapping("/system/config/name/{sysName}")
    public Result<SystemConfig> getBySysName(@PathVariable String sysName) {
        SystemConfig config = systemConfigService.getBySysName(sysName);
        return Result.success(config);
    }
}