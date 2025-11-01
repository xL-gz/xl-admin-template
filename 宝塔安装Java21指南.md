# 宝塔面板安装 Java 21 完整指南

## 方法一：宝塔软件商店安装（推荐）

1. **打开软件商店**
   - 宝塔面板左侧菜单 → **"软件商店"**
   - 在搜索框搜索：`Java` 或 `JDK`

2. **查找Java管理器**
   - 查找 **"Java项目管理器"** 或 **"JDK"** 相关插件
   - 如果没有现成的Java 21，使用下面的命令行方法

---

## 方法二：命令行安装（推荐，更可靠）

### 步骤1：检查系统类型

```bash
cat /etc/os-release
```

### 步骤2：根据系统安装Java 21

#### 如果是 CentOS/OpenCloudOS/RedHat 系统：

```bash
# 更新系统
yum update -y

# 安装Java 21 (OpenJDK)
yum install -y java-21-openjdk java-21-openjdk-devel

# 验证安装
java -version
```

#### 如果是 Ubuntu/Debian 系统：

```bash
# 更新系统
apt update -y

# 安装Java 21 (OpenJDK)
apt install -y openjdk-21-jdk

# 验证安装
java -version
```

---

## 方法三：手动下载安装（如果上面方法失败）

### 下载OpenJDK 21

```bash
# 进入临时目录
cd /tmp

# 下载OpenJDK 21 (选择适合你系统的版本)
# 对于 x86_64 系统：
wget https://download.java.net/java/GA/jdk21.0.1/415e3f918a1f4062a0074a2794853d0d/12/GPL/openjdk-21.0.1_linux-x64_bin.tar.gz

# 或者使用国内镜像（更快）
# wget https://mirrors.tuna.tsinghua.edu.cn/AdoptOpenJDK/21/jdk/x64/linux/OpenJDK21U-jdk_x64_linux_hotspot_21.0.1_12.tar.gz
```

### 解压并安装

```bash
# 创建Java安装目录
mkdir -p /usr/local/java

# 解压
tar -xzf openjdk-21.0.1_linux-x64_bin.tar.gz -C /usr/local/java/

# 重命名（可选，方便管理）
mv /usr/local/java/jdk-21.0.1 /usr/local/java/jdk21
```

### 配置环境变量

```bash
# 编辑环境变量文件
vim /etc/profile

# 或者使用nano编辑器（更简单）
nano /etc/profile
```

在文件末尾添加：

```bash
export JAVA_HOME=/usr/local/java/jdk21
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib
export PATH=$JAVA_HOME/bin:$PATH
```

保存后执行：

```bash
# 使配置生效
source /etc/profile

# 验证
java -version
```

---

## 验证安装

安装完成后，在终端执行：

```bash
java -version
```

应该看到类似这样的输出：
```
openjdk version "21.0.1" 2024-04-16
OpenJDK Runtime Environment (build 21.0.1+12-OpenJDK)
OpenJDK 64-Bit Server VM (build 21.0.1+12-OpenJDK, mixed mode, sharing)
```

---

## 查找Java安装路径

如果安装成功但脚本找不到Java，查找Java路径：

```bash
# 查找Java可执行文件
which java

# 查找Java安装目录
readlink -f $(which java)

# 或者
ls -la /usr/lib/jvm/
```

然后修改 `start.sh` 脚本中的 `JAVA_HOME` 路径。

---

## 常见问题

### Q1: 提示 "No package java-21-openjdk available"
**解决方法：** 
```bash
# 更新仓库
yum update -y
# 或者尝试安装epel仓库
yum install -y epel-release
```

### Q2: 安装了多个Java版本，如何切换？
```bash
# 查看所有Java版本
alternatives --config java

# 选择Java 21对应的序号
```

### Q3: 安装后仍提示找不到Java
```bash
# 检查PATH环境变量
echo $PATH

# 手动添加到PATH（临时）
export PATH=$PATH:/usr/lib/jvm/java-21-openjdk/bin

# 永久添加（编辑 /etc/profile，如上面的方法三）
```

---

## 快速安装命令（一键安装）

**对于 CentOS/OpenCloudOS 系统：**
```bash
yum update -y && yum install -y java-21-openjdk java-21-openjdk-devel && java -version
```

**对于 Ubuntu/Debian 系统：**
```bash
apt update -y && apt install -y openjdk-21-jdk && java -version
```

