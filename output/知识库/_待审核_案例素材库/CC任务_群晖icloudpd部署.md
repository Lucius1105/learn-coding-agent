# CC 任务清单：群晖 DS916+ 部署 icloudpd

## 我们的目的
解决老徐 iPhone 内存爆满、备份反复失败的问题，建立一个「自动 + 省心」的照片管理流程。

## 动机（为什么要做这件事）
- **现状痛点**：iPhone 内存满了，拍不了新素材；群晖 Photos 备份总是失败，反复折腾很烦躁
- **根本原因**：iCloud「优化存储」和群晖 Photos 冲突——手机存的是缩略图，群晖想备份原图，每次都要从云端下载，耗电耗流量还卡死
- **解决思路**：让群晖直接从 iCloud 云端下载原图，手机只留缩略图，彻底解耦

## 要干嘛
在群晖 DS916+ 上部署 icloudpd Docker 容器，实现：
1. **自动同步**：每天自动从 iCloud 下载原图到 NAS
2. **智能分类**：按年月自动整理文件夹
3. **格式转换**：HEIC 自动转 JPEG，方便后续使用

## 达到什么效果（成功标准）
- ✅ 老徐手机开启「优化存储」后，空间自动释放
- ✅ 群晖每天自动同步最新照片，无需人工干预
- ✅ 照片按年月分类存储，方便查找
- ✅ 老徐每周只需花 5 分钟清理废片，其他时间不用管
- ✅ 紧急情况可以直接删手机照片，原图安全在 NAS

## 背景信息
- **设备**: Synology DS916+
- **当前问题**: iPhone 内存满，iCloud 和群晖 Photos 备份冲突
- **解决方案**: 使用 icloudpd 让群晖直接从 iCloud 云端下载原图
- **Apple ID**: 需向老徐索取
- **密码**: 建议使用 App 专用密码

---

## 执行步骤

### Step 1: 确认环境
- [ ] 登录群晖 DSM，确认 Container Manager（Docker）已安装
- [ ] 确认群晖有外网访问能力（需要连接 iCloud）
- [ ] 检查存储空间，确认有足够容量存放照片

### Step 2: 创建目录结构
在群晖 File Station 中创建以下文件夹：
```
/docker/icloudpd/config      ← 配置文件
/docker/icloudpd/data        ← 下载的照片
```

### Step 3: 获取 Apple 凭证
向老徐索取：
- [ ] Apple ID 邮箱
- [ ] App 专用密码（推荐）或 iCloud 密码

**App 专用密码生成方式**：
1. 访问 https://appleid.apple.com
2. 登录 → 安全 → App 专用密码
3. 生成密码（标签写 "SynologyNAS"）

### Step 4: 创建 Docker Compose 配置
在 `/docker/icloudpd/config/` 创建 `docker-compose.yml`：

```yaml
version: '3'
services:
  icloudpd:
    image: boredazfcuk/icloudpd:latest
    container_name: icloudpd
    restart: always
    environment:
      - apple_id=【老徐的Apple ID】
      - apple_password=【App专用密码】
      - authentication_type=2FA
      - download_path=/data
      - folder_structure={:%Y/%m}
      - interval=86400
      - recent=30
      - convert_heic_to_jpeg=true
      - jpeg_quality=90
    volumes:
      - /volume1/docker/icloudpd/data:/data
      - /volume1/docker/icloudpd/config:/config
    network_mode: bridge
```

### Step 5: 部署容器
- [ ] 打开 Container Manager
- [ ] 项目 → 新建项目
- [ ] 选择路径 `/docker/icloudpd/config`
- [ ] 上传或粘贴 docker-compose.yml
- [ ] 构建并启动项目

### Step 6: 处理 2FA 验证
首次启动需要处理 Apple 双因素认证：

1. 查看容器日志，找到验证码提示
2. 老徐手机上会收到 Apple 的短信验证码
3. 在容器终端中输入验证码完成验证
4. 验证成功后，icloudpd 会记住设备，后续自动运行

**验证命令**（在 Container Manager 的容器中执行）：
```bash
/icloudpd/icloudpd --username "【Apple ID】" --password "【密码】" --auth-only
```

### Step 7: 测试运行
- [ ] 手动触发一次同步测试
- [ ] 检查 `/docker/icloudpd/data/` 是否有照片下载
- [ ] 确认照片文件夹结构正确（按年月分类）

### Step 8: 配置老徐手机
指导老徐完成手机端设置：
- [ ] 设置 → 照片 → 勾选「优化 iPhone 储存空间」
- [ ] 确认 iCloud 照片同步开启
- [ ] 说明：手机只保留缩略图，原图在云端，NAS 自动下载

### Step 9: 文档交付
- [ ] 向老徐说明如何查看同步状态
- [ ] 说明如何手动触发同步（如需）
- [ ] 提供常见问题排查指南

---

## 交付物

1. **部署完成的 icloudpd 容器**（自动每日同步）
2. **照片存储路径**: `/docker/icloudpd/data/`
3. **文件夹结构**: 按年月自动分类（如 `2024/03/`）
4. **操作文档**（简要版）

---

## 注意事项

1. **首次同步**: 如果照片很多，首次同步可能需要较长时间，建议设置 `recent=30` 先跑最近30天
2. **HEIC 转换**: 配置中已开启 HEIC 转 JPEG，方便后续使用
3. **存储空间**: 确保群晖有足够空间，iCloud 照片会全部下载原图
4. **网络**: 需要稳定的网络连接，建议接有线网络

---

## 老徐后续操作

部署完成后，老徐只需要：

1. **每周日晚上**: 打开 iPhone 相册，快速清理上周的废片（拍糊的、重复的）
2. **每月检查**: 确认群晖下载正常，手机可以安心删旧图
3. **紧急情况**: 如果急需释放手机空间，可以直接删 iPhone 上的照片（原图已在 NAS）

---

## 联系信息

如有问题，联系老徐获取：
- Apple ID 和 App 专用密码
- 群晖 DSM 登录信息（如需远程协助）

---

**任务创建时间**: 2026-03-19
**执行人**: CC (Claude Code)
**验收人**: 老徐
