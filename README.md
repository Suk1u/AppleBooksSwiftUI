# Apple Books SwiftUI Replica (图书应用精选复刻)

本项目使用 **SwiftUI** 纯原生实现，尽可能完整地复刻了 iOS 原生“图书”（Apple Books）应用的核心视觉风格与交互体验。

---

## 📱 核心功能特性

### 1. “阅读中”（Reading Now）板块
- **每日阅读目标环形进度**：还原 Apple 经典的同心圆目标进度环，展示今日阅读分钟数、目标差距与连续达成天数（火焰徽章）。
- **当前阅读专区（Currently Reading）**：以精致拟真封面卡片展示正在阅读的书籍、实时进度条、百分比与页码，并支持一键“继续阅读”。
- **欲读清单与已读完书架**：横向流动书架，展示稍后读与已读完书籍。

### 2. “书库”（Library）板块
- **多维度标签筛选**：支持“全部”、“正在阅读”、“欲读清单”、“已读完”、“文学小说”、“科幻小说”、“商业与思维”、“社科哲学”等快速胶囊标签切换。
- **视图模式无缝切换**：支持 **网格模式（Grid View）** 与 **列表模式（List View）** 切换。
- **高拟真书籍封面**：还原真实图书光影细节（左侧书脊压痕阴影、微光漫反射高光、右侧微圆角与景深阴影）。
- **实时搜索与动态排序**：支持实时过滤书名、作者与简介内容；支持按“最近阅读”、“按书名”、“按作者”、“按阅读进度”排序。
- **长按上下文菜单（Context Menu）**：支持快速进入阅读、查看详情、切换欲读状态或标记已读完。

### 3. 书籍详情页（Book Detail View）
- 顶部沉浸式书籍封面大图，搭配多星级评分与读者评价数。
- 快捷操作按钮：“继续阅读 / 开始阅读”、“欲读清单”、“标为已读”。
- 关键规格参数条（总页数、分类标签、预计阅读用时）。
- 可展开/收起的内容简介文本。
- 完整章节目录速览。

### 4. 全屏沉浸式阅读界面（Reader View）
- **沉浸交互**：轻点正文中央区域，平滑呼出/隐藏顶部与底部导航栏。
- **双排版交互模式**：
  - **翻页模式（Paginated）**：点击屏幕左侧 25% 翻上一页，点击右侧 25% 翻下一页，同时支持左右滑动转场。
  - **上下滚动模式（Continuous Scroll）**：支持传统流畅流式长文滚动。
- **主题色板系统（“Aa”设置）**：
  - **纯白（Original White）**：通透高对比度。
  - **羊皮纸（Warm Sepia）**：温润护眼暖黄，阅读经典文学的绝佳搭配。
  - **水墨灰（Paper Gray）**：低饱和度柔和灰色。
  - **暗夜黑（Dark Night）**：极致纯黑深色模式。
- **字体与版式自由微调**：
  - 支持字号动态步进（14pt - 28pt）。
  - 支持衬线宋体（Serif）、系统黑体（Sans-Serif）、圆体（Rounded）自由切换。
  - 屏幕亮度快捷滑块模拟。
- **实时进度与目录跳转**：底部滑动进度条可拖拽跨页跳转；内置全书章节目录抽屉，点击章节即刻定位。
- **数据持久化与用时回写**：退出阅读器时自动计算用时累加到今日目标，并持久化当前阅读页码与进度。

---

## 🏗 项目架构与目录结构

```
AppleBooksClone/
├── AppleBooksClone.xcodeproj/          # 完整 Xcode 工程配置文件
│   ├── project.pbxproj
│   └── xcshareddata/xcschemes/
│       └── AppleBooksClone.xcscheme    # 共享 Scheme（CI 自动化构建必需）
├── AppleBooksClone/
│   ├── App/
│   │   ├── AppleBooksApp.swift         # App 启动入口
│   │   └── Info.plist                  # 应用配置清单
│   ├── Models/
│   │   ├── Book.swift                  # 图书模型、分类枚举、排序选项、封面主题
│   │   ├── Chapter.swift               # 章节与正文内容模型
│   │   └── ReadingGoal.swift           # 每日阅读目标与连胜数据模型
│   ├── ViewModels/
│   │   └── BooksViewModel.swift        # 全局响应式状态管理（图书库、过滤排序、阅读进度管理）
│   ├── Views/
│   │   ├── MainTabView.swift           # 根 TabView 视图
│   │   ├── ReadingNow/
│   │   │   ├── ReadingNowView.swift    # “阅读中”主界面
│   │   │   ├── ReadingGoalCard.swift   # 每日阅读目标环形进度卡片
│   │   │   ├── CurrentlyReadingCard.swift # 正在阅读 Hero 封面卡片
│   │   │   └── HorizontalBookShelf.swift  # 横向滑动图书展架
│   │   ├── Library/
│   │   │   ├── LibraryView.swift       # “书库”主界面（包含搜索、排序与视图切换）
│   │   │   ├── BookGridView.swift      # 网格排布展示视图
│   │   │   ├── BookListView.swift      # 列表排布展示视图
│   │   │   ├── BookRowView.swift       # 列表单行图书组件
│   │   │   └── CategoryPillsView.swift # 水平滑动胶囊分类筛选器
│   │   ├── Detail/
│   │   │   └── BookDetailView.swift    # 书籍详情页 Sheet
│   │   ├── Reader/
│   │   │   ├── ReaderView.swift        # 全屏沉浸式图书阅读界面
│   │   │   ├── ReaderSettingsView.swift# “Aa”排版与主题设置弹窗
│   │   │   ├── TableOfContentsView.swift # 章节目录抽屉
│   │   │   └── ReaderThemes.swift      # 四套阅读背景与文字主题规范
│   │   └── Components/
│   │       ├── BookCoverView.swift     # 3D 光影质感拟真书籍封面组件
│   │       ├── CircularProgressView.swift # 环形进度条组件
│   │       ├── ReadingProgressBar.swift  # 胶囊式平滑进度条
│   │       └── Color+Hex.swift         # 十六进制颜色解析拓展
│   └── Assets.xcassets/                # 图标与全局主题色彩资源资产
├── .github/
│   └── workflows/
│       └── build-ipa.yml               # GitHub Actions 自动化打包免签名 IPA 工作流
└── README.md
```

---

## 💡 关键交互与核心实现思路

### 1. 翻页与分段阅读逻辑
- 阅读器采用分层架构：底层为正文排版容器，上层为透明手势热区（Gesture Layer）。
- 左右边缘区域（各占屏幕宽度的 25%）响应上一页/下一页操作，中间 50% 区域响应沉浸式控制栏的淡入淡出。
- 支持 DragGesture 水平拖拽，结合 `.transition(.opacity)` 模拟书页切换。

### 2. 进度持久化与目标时间统计
- 进入阅读器时记录开始时间戳；退出或页面跳转时计算阅读增量分钟数。
- 增量实时累加至 `ReadingGoal.todayMinutes`，驱动主界面的环形目标图动态闭合。
- `currentPage` 自动反查对应章节目录位置，保持页码、章节与总进度三者一致。

### 3. 书库分类筛选与响应式动态排序
- `BooksViewModel` 作为共享 `@StateObject`，通过 `@Published` 暴露 `filteredLibraryBooks` 计算属性。
- 采用管道组合模式（Category Filter -> Keyword Search -> Sort Selector），任何一维条件改变均触发 SwiftUI 局部差量重绘。

---

## 🚀 自动化构建与免签名 IPA 打包 (GitHub Actions)

仓库已集成 `.github/workflows/build-ipa.yml`：
1. 在 macOS Runner 上通过 `xcodebuild` 进行 Release 编译归档，传入：
   ```bash
   CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY=""
   ```
2. 提取编译后的 `AppleBooksClone.app` 目录至 `Payload/` 结构下。
3. 压缩生成免签名 `AppleBooksClone.ipa` 文件。
4. 自动上传为 GitHub Actions 构建产物（Artifacts）。

### 后续企业证书重签名方法
下载 GitHub Actions 生成的 `AppleBooksClone.ipa` 后，可使用常用重签名工具（如 `iOS App Signer`、`zsign` 或 `codesign` 命令行）直接注入企业证书与 MobileProvision 描述文件：

```bash
# 示例：使用 zsign 对免签 ipa 进行企业签名
zsign -k enterprise.p12 -p 证书密码 -m embedded.mobileprovision -o Signed_AppleBooks.ipa AppleBooksClone.ipa
```
