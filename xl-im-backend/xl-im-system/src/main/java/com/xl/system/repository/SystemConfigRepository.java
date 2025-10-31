package com.xl.system.repository;

import com.xl.system.entity.SystemConfig;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

/**
 * 系统配置Repository
 */
@Repository
public interface SystemConfigRepository extends MongoRepository<SystemConfig, String> {
    
    /**
     * 根据系统名称查找配置
     */
    SystemConfig findBySysName(String sysName);
    
    /**
     * 根据公司名称查找配置
     */
    SystemConfig findByCompanyName(String companyName);
}