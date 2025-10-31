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
            return Result.success(configs.get(0));
        }
        // 如果没有配置，返回一个默认配置
        SystemConfig defaultConfig = new SystemConfig();
        defaultConfig.setTitle("XL即时通讯系统");
        defaultConfig.setSysName("XL IM System");
        defaultConfig.setSysVersion("1.0.0");
        defaultConfig.setCopyright("Copyright © 2025 XL");
        defaultConfig.setMandatoryModificationOfInitialPassword(0);
        return Result.success(defaultConfig);
    }
    
    /**
     * 前端需要的系统配置接口 - PUT /api/system/SysConfig
     */
    @PutMapping("/api/system/SysConfig")
    public Result<SystemConfig> updateSysConfig(@RequestBody SystemConfig systemConfig) {
        SystemConfig savedConfig = systemConfigService.save(systemConfig);
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