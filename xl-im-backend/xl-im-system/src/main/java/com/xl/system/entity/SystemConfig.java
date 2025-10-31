package com.xl.system.entity;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

/**
 * 系统配置实体类
 */
@Data
@Document(collection = "system_config")
public class SystemConfig {
    
    @Id
    private String id;
    
    // 基本设置
    private String title;                    // 系统标题
    private String sysName;                  // 系统名称
    private String sysVersion;               // 系统版本
    private String companyName;              // 公司名称
    private String copyright;                // 版权信息
    private String companyCode;              // 公司简称
    private String companyAddress;           // 公司地址
    private String companyContacts;          // 公司法人
    private String companyTelePhone;         // 公司电话
    private String companyEmail;             // 公司邮箱
    private String sysDescription;           // 系统描述
    
    // 图标配置
    private String loginIcon;                // 登录图标
    private String logoIcon;                 // LOGO图标
    private String appIcon;                  // APP图标
    
    // 安全设置
    private Integer singleLogin;             // 登录方式
    private Integer tokenTimeout;            // 超时登出(分钟)
    private Integer passwordErrorsNumber;    // 密码错误次数
    private Boolean whitelistSwitch;         // 白名单开关
    private String whiteListIp;              // 白名单IP
    
    // 密码策略
    private Integer passwordStrengthLimit;   // 密码强度限制
    private Integer passwordLengthMin;       // 最小长度
    private Integer passwordLengthMax;       // 最大长度
    private Boolean containsNumbers;         // 包含数字
    private Boolean includeLowercaseLetters; // 包含小写字母
    private Boolean includeUppercaseLetters; // 包含大写字母
    private Boolean containsCharacters;      // 包含特殊字符
    private Integer mandatoryModificationOfInitialPassword; // 是否强制修改初始密码 (0-否, 1-是)
    private String newUserDefaultPassword;   // 新用户默认密码
    private String navigationIcon;           // 导航图标
    private String workLogoIcon;             // 工作台LOGO图标
}