package com.xl.system.service.impl;

import com.xl.system.entity.SystemConfig;
import com.xl.system.repository.SystemConfigRepository;
import com.xl.system.service.SystemConfigService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 系统配置服务实现类
 */
@Slf4j
@Service
public class SystemConfigServiceImpl implements SystemConfigService {
    
    @Autowired
    private SystemConfigRepository systemConfigRepository;
    
    @Override
    public SystemConfig save(SystemConfig systemConfig) {
        log.info("保存系统配置 - ID: {}, OSS配置数量: {}, 云服务器配置数量: {}", 
            systemConfig.getId(),
            systemConfig.getOssStorageConfigs() != null ? systemConfig.getOssStorageConfigs().size() : 0,
            systemConfig.getCloudServerStorageConfigs() != null ? systemConfig.getCloudServerStorageConfigs().size() : 0);
        
        SystemConfig saved = systemConfigRepository.save(systemConfig);
        
        log.info("保存后读取 - ID: {}, OSS配置数量: {}, 云服务器配置数量: {}", 
            saved.getId(),
            saved.getOssStorageConfigs() != null ? saved.getOssStorageConfigs().size() : 0,
            saved.getCloudServerStorageConfigs() != null ? saved.getCloudServerStorageConfigs().size() : 0);
        
        return saved;
    }
    
    @Override
    public SystemConfig getById(String id) {
        SystemConfig config = systemConfigRepository.findById(id).orElse(null);
        if (config != null) {
            log.info("根据ID获取配置 - ID: {}, OSS配置数量: {}, 云服务器配置数量: {}", 
                config.getId(),
                config.getOssStorageConfigs() != null ? config.getOssStorageConfigs().size() : 0,
                config.getCloudServerStorageConfigs() != null ? config.getCloudServerStorageConfigs().size() : 0);
        }
        return config;
    }
    
    @Override
    public List<SystemConfig> getAll() {
        List<SystemConfig> configs = systemConfigRepository.findAll();
        if (configs != null && !configs.isEmpty()) {
            configs.forEach(config -> {
                log.info("获取所有配置 - ID: {}, OSS配置数量: {}, 云服务器配置数量: {}", 
                    config.getId(),
                    config.getOssStorageConfigs() != null ? config.getOssStorageConfigs().size() : 0,
                    config.getCloudServerStorageConfigs() != null ? config.getCloudServerStorageConfigs().size() : 0);
            });
        }
        return configs;
    }
    
    @Override
    public void deleteById(String id) {
        systemConfigRepository.deleteById(id);
    }
    
    @Override
    public SystemConfig getBySysName(String sysName) {
        return systemConfigRepository.findBySysName(sysName);
    }
}