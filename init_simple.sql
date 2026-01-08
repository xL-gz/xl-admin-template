CREATE DATABASE IF NOT EXISTS xl_im CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE xl_im;

CREATE TABLE IF NOT EXISTS sys_system (
  id varchar(50) NOT NULL,
  en_code varchar(50) NOT NULL,
  full_name varchar(100) NOT NULL,
  description varchar(500) DEFAULT NULL,
  icon varchar(100) DEFAULT NULL,
  url_address varchar(255) DEFAULT NULL,
  sort_code int(11) DEFAULT 0,
  enabled_mark tinyint(4) DEFAULT 1,
  is_main tinyint(4) DEFAULT 0,
  create_time datetime DEFAULT NULL,
  update_time datetime DEFAULT NULL,
  deleted tinyint(4) DEFAULT 0,
  PRIMARY KEY (id),
  UNIQUE KEY uk_en_code (en_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO sys_system (id, en_code, full_name, description, sort_code, enabled_mark, is_main) VALUES
('im-system', 'imSystem', 'IM系统', '即时通讯核心功能', 1, 1, 0),
('admin-system', 'adminSystem', '管理后台', '系统管理和配置', 2, 1, 1)
ON DUPLICATE KEY UPDATE 
  full_name = VALUES(full_name),
  description = VALUES(description),
  enabled_mark = VALUES(enabled_mark);

SELECT * FROM sys_system WHERE deleted = 0;