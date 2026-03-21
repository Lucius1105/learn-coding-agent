# CC 任务清单：群晖 iCloud 照片自动同步系统（完整版）

## 一、项目背景与来龙去脉

### 1.1 老徐是谁
老徐（徐沛霖），连续创业13年，柳州首位 ICF 认证商业教练，经营「雨后甘霖」品牌。日常需要大量拍摄：客户案例、培训现场、生活记录、短视频素材。

### 1.2 当前痛点（为什么要做这件事）
**痛点 1：iPhone 内存爆满**
- 128GB/256GB 手机，照片视频占 80%+
- 经常提示「存储空间不足」，无法拍摄新素材
- 严重影响工作（拍不了客户案例、录不了视频）

**痛点 2：备份反复失败，很烦躁**
- 之前用群晖 Photos App 备份，总是卡住
- 备份一晚上，早上发现失败，重复多次
- 原因：iCloud「优化存储」和群晖 Photos 冲突

**痛点 3：冲突的本质**
```
iCloud 优化存储机制：
- 手机存缩略图（省空间）
- 原图存 iCloud 云端
- 需要时才从云端下载原图

群晖 Photos 备份时：
- 扫描到照片，发现只有缩略图
- 必须先从 iCloud 下载原图
- 才能上传到 NAS
- 结果：耗电、耗流量、容易中断、反复失败
```

### 1.3 解决方案（icloudpd）
**核心思路**：让群晖直接从 iCloud 云端下载原图，手机完全不用参与。

```
新流程：
iPhone 拍照 → 自动同步到 iCloud 云端 → 群晖 icloudpd 每天自动下载 → NAS 存原图
     ↑
手机只存缩略图（省空间）
```

**优势**：
- 手机零负担，不耗电不耗流量
- 下载的是原始高清文件，不是缩略图
- 自动增量同步，每天自动跑
- 支持 HEIC 转 JPEG，方便使用

---

## 二、项目目标

### 2.1 核心目标
建立一个「自动 + 省心 + 安全」的照片管理闭环，让老徐再也不用为手机内存和备份操心。

### 2.2 具体目标
| 目标 | 标准 |
|------|------|
| 自动同步 | 群晖每天自动从 iCloud 下载最新照片，无需人工干预 |
| 空间释放 | iPhone 开启「优化存储」后，本地空间自动释放 |
| 智能分类 | 照片按年月自动分类，方便查找 |
| 无重复混乱 | 同步逻辑清晰，不会出现重复文件或混乱结构 |
| 快速清理 | 部署完成后，老徐可以安心清理 iPhone 相册 |

### 2.3 成功标准（验收 checklist）
- [ ] iPhone 开启「优化存储」后，本地存储空间显著减少
- [ ] 群晖 `/docker/icloudpd/data/` 目录有照片文件
- [ ] 照片按 `2024/03/` 这样的年月结构分类
- [ ] 连续 3 天自动同步正常，无需人工干预
- [ ] 老徐可以在 iPhone 上删除照片，确认原图已在 NAS

---

## 三、老徐的核心担忧与解答

### 担忧 1：会不会有重复照片，导致相册混乱？

**解答**：
icloudpd 使用 iCloud 的同步机制，**不会重复下载**。

**原理**：
- 每次同步时，icloudpd 会记录已下载的照片 ID
- 只下载新增的照片，已存在的自动跳过
- 文件夹结构固定：`年/月/照片文件`

**预防措施**：
- 配置中设置 `recent=30`，先跑最近 30 天测试
- 观察几天确认无重复后，再改为同步全部历史照片
- 文件夹命名包含日期，天然防重复

**实际效果**：
```
/docker/icloudpd/data/
├── 2024/
│   ├── 03/                    ← 3月照片都在这里
│   │   ├── IMG_1234.jpg       ← 文件名唯一
│   │   ├── IMG_1235.heic
│   │   └── ...
│   └── 04/
└── 2025/
    └── 01/
```

### 担忧 2：备份完后，如何快速清理 iPhone 相册？

**解答**：
部署完成后，老徐可以这样清理：

**Step 1：确认 NAS 已备份**
- 检查群晖 `/docker/icloudpd/data/` 目录
- 确认最近的照片已下载（看日期最新的文件夹）

**Step 2：iPhone 开启「优化存储」**
- 设置 → 照片 → 勾选「优化 iPhone 储存空间」
- 系统会自动将旧照片替换为缩略图，释放空间

**Step 3：快速清理废片（每周 5 分钟）**
```
每周日晚上：
1. 打开 iPhone 相册 → 最近项目
2. 快速浏览上周照片（滑动浏览，不用点开）
3. 删除明显废片：
   - 拍糊的（手抖、对焦失败）
   - 重复的（连拍选了最好的，其他删）
   - 无价值的（随手拍的菜单、路牌、试拍）
4. 保留「收藏」的好图（点过爱心的）
5. 完成！
```

**Step 4：紧急情况直接删**
- 如果急需释放空间，可以直接删 iPhone 照片
- 原图安全在 NAS，不用担心丢失

---

## 四、执行步骤（详细操作指南）

### Step 1: 环境确认（5 分钟）

**1.1 登录群晖 DSM**
- 浏览器访问群晖 IP（如 `http://192.168.1.100:5000`）
- 使用管理员账号登录

**1.2 确认 Container Manager 已安装**
- 打开「套件中心」
- 搜索「Container Manager」（旧版叫 Docker）
- 如未安装，点击安装

**1.3 确认存储空间充足**
- 打开「存储空间管理员」
- 确认剩余空间 > 50GB（根据照片量调整）

**1.4 确认网络连接正常**
- 群晖需要能访问外网（下载 iCloud 照片）
- 建议接有线网络，更稳定

### Step 2: 创建目录结构（5 分钟）

**2.1 打开 File Station**
- 进入主菜单 → File Station

**2.2 创建文件夹**
```
/docker/icloudpd/config      ← 配置文件
/docker/icloudpd/data        ← 下载的照片（重要！）
```

**操作路径**：
1. 进入 `docker` 文件夹（如没有，先创建）
2. 右键 → 新建文件夹 → 命名为 `icloudpd`
3. 进入 `icloudpd` 文件夹
4. 新建两个子文件夹：`config` 和 `data`

### Step 3: 获取 Apple 凭证（10 分钟，需老徐配合）

**3.1 向老徐索取信息**
- Apple ID 邮箱
- 是否开启双重认证（2FA）？（通常是开启的）

**3.2 生成 App 专用密码（推荐）**

**生成步骤**：
1. 老徐访问 https://appleid.apple.com
2. 登录 Apple ID
3. 进入「登录和安全」→「App 专用密码」
4. 点击「生成 App 专用密码」
5. 标签填写：`SynologyNAS`
6. 复制生成的密码（格式如：xxxx-xxxx-xxxx-xxxx）

**3.3 记录凭证**
```
Apple ID: 【老徐的邮箱】
App 专用密码: 【生成的密码】
```

### Step 4: 创建 Docker Compose 配置（10 分钟）

**4.1 创建 docker-compose.yml 文件**

在 `/docker/icloudpd/config/` 目录下创建文件：

**docker-compose.yml 内容**：
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

**配置说明**：
| 参数 | 说明 |
|------|------|
| `apple_id` | 老徐的 Apple ID 邮箱 |
| `apple_password` | App 专用密码 |
| `download_path` | 容器内下载路径 |
| `folder_structure` | 文件夹命名格式，`{:%Y/%m}` = 年/月 |
| `interval` | 同步间隔，86400 = 每天一次 |
| `recent` | 首次下载最近 N 天，测试用 30 |
| `convert_heic_to_jpeg` | HEIC 转 JPEG，true = 开启 |

### Step 5: 部署容器（10 分钟）

**5.1 打开 Container Manager**
- 主菜单 → Container Manager

**5.2 创建项目**
1. 左侧菜单 → 「项目」
2. 点击「新建」
3. 项目名称：`icloudpd`
4. 路径：选择 `/docker/icloudpd/config`
5. 点击「完成」

**5.3 查看容器状态**
- 左侧菜单 → 「容器」
- 找到 `icloudpd` 容器
- 确认状态为「运行中」

### Step 6: 处理 2FA 验证（关键步骤，需老徐配合，15 分钟）

**6.1 查看日志获取验证码提示**
- Container Manager → 容器 → icloudpd → 「日志」
- 会看到提示：
  ```
  Two-factor authentication required.
  Please enter the 6-digit code sent to your device:
  ```

**6.2 获取验证码**
- 老徐手机上会收到 Apple 的短信验证码
- 格式如：`123456`

**6.3 输入验证码**
1. Container Manager → 容器 → icloudpd
2. 点击「操作」→ 「打开终端机」
3. 在终端中输入收到的验证码，回车

**6.4 验证成功**
- 日志显示：`Authentication successful`
- 后续自动运行，无需再次验证

### Step 7: 测试运行（10 分钟）

**7.1 检查下载结果**
1. 打开 File Station
2. 进入 `/docker/icloudpd/data/`
3. 查看是否有照片文件
4. 确认文件夹结构为 `年/月/照片`

**7.2 确认照片完整性**
- 随机打开几张照片，确认能正常显示
- 确认 HEIC 照片已转换为 JPEG

### Step 8: 配置老徐手机（5 分钟）

**8.1 开启「优化 iPhone 储存空间」**
1. iPhone 设置 → 照片
2. 勾选「优化 iPhone 储存空间」
3. 确认 iCloud 照片同步已开启

**8.2 说明原理**
告诉老徐：
- 手机现在只存缩略图，省空间
- 原图都在 iCloud 云端
- 群晖每天自动从云端下载原图到 NAS
- 三端同步：iPhone 缩略图 ↔ iCloud 原图 ↔ NAS 原图

### Step 9: 交付与培训（10 分钟）

**9.1 向老徐交付**
- 展示群晖上的照片文件夹
- 说明如何查看同步状态（Container Manager → 日志）

**9.2 提供日常操作指南**

**每周清理流程（5 分钟）**：
```
1. 周日晚上，打开 iPhone 相册 → 最近项目
2. 快速浏览上周照片
3. 删除明显废片（拍糊的、重复的、无价值的）
4. 保留「收藏」的好图
5. 完成！
```

**紧急情况处理**：
- 如果急需释放空间，可以直接删 iPhone 照片
- 原图安全在 NAS，不用担心

---

## 五、常见问题 FAQ

**Q: 同步失败了怎么办？**
A: 查看 Container Manager → 日志，通常是网络问题或 2FA 过期。

**Q: 想同步全部历史照片？**
A: 修改 docker-compose.yml，删除 `recent=30`，然后重启容器。

**Q: 照片在 NAS 上怎么查看？**
A: File Station 浏览，或 Synology Photos 套件导入该文件夹。

**Q: 会有重复照片吗？**
A: 不会。icloudpd 记录已下载的照片 ID，只下载新增照片。

---

**任务创建时间**: 2026-03-19
**执行人**: CC (Claude Code)
**验收人**: 老徐
