package com.xl.system.service.impl;

import com.xl.system.entity.SystemConfig;
import com.xl.system.repository.SystemConfigRepository;
import com.xl.system.service.SystemConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 系统配置服务实现类
 */
@Service
public class SystemConfigServiceImpl implements SystemConfigService {
    
    @Autowired
    private SystemConfigRepository systemConfigRepository;
    
    @Override
    public SystemConfig save(SystemConfig systemConfig) {
        return systemConfigRepository.save(systemConfig);
    }
    
    @Override
    public SystemConfig getById(String id) {
        return systemConfigRepository.findById(id).orElse(null);
    }
    
    @Override
    public List<SystemConfig> getAll() {
        return systemConfigRepository.findAll();
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