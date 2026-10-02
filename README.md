# Apple Books iOS 26+ Liquid Glass Edition (液态玻璃精选复刻)

本项目使用 **SwiftUI** 纯原生实现，严格对照实机录屏全面升级为 **iOS 26+ 液态玻璃（Liquid Glass）设计语言**，完整复刻了 Apple Books（图书）应用的核心界面、流体材质与沉浸式交互动效。

---

## 💎 iOS 26+ 液态玻璃（Liquid Glass）视觉体系与特色

1. **流体多层毛玻璃材质（Multi-layer Liquid Glass Surface）**：
   - 底层采用 `.ultraThinMaterial` 实现动态光学折射与背景穿透模糊；
   - 叠合微光色散渐变与半透明深空微光滤层，营造透亮、纯净的流体质感。
2. **镜面高光倒角棱线（Specular Highlight Caustics Border）**：
   - 针对所有卡片、胶囊与圆形控件定制多段斜向线性高光描边（左上 50% 纯白反光至右下柔和过渡），模拟现实物理玻璃微曲面的反光倒角效果。
3. **悬浮胶囊底栏与流体气泡（Liquid Floating Tab Bar）**：
   - 彻底重构原生 TabView，采用底部悬浮的流体液态玻璃胶囊 Bar；
   - 5 大导航标签：`主页`、`书库`、`书店`、`有声书`、`搜索`；
   - 选中项具备 `matchedGeometryEffect` 流体气泡滑移高光，伴随弹性阻尼过渡。
4. **悬浮液态玻璃弹出菜单（Liquid Glass Floating Menu Sheet）**：
   - 书库右上角轻触圆形玻璃按钮即可呼出浮动液态玻璃面板：
     - `选择`（带有对勾圆环）
     - 视图切换：`网格` / `列表`
     - 排序方式：`最近阅读` / `书名` / `作者` / `手动`
     - 功能操作：`移除下载`（垃圾桶图标与右箭头）
5. **沉浸式阅读器液态玻璃控制组（Liquid Glass Reader Controls）**：
   - **右上角**：圆形液态玻璃关闭按钮（`xmark`）；
   - **顶部居中**：悬浮液态玻璃药丸徽标（“本章还剩 3 页” / “本章最后一页”）；
   - **底部居中**：悬浮液态玻璃页码胶囊（“16/255 页”）；
   - **右侧边缘**：竖向流体玻璃进度滑槽（`VerticalPageScrubber`），可随手势实时滑动物理搜页；
   - **右下角**：圆形流体玻璃气泡按钮，轻触即刻以弹性动画展开多功能控制面板（包含 `目录`、`在图书中搜索`、`主题与设置 大小`，以及底栏四个快捷玻璃方块：分享、旋转锁、翻页模式、书签）。

---

## 🏗 项目架构与目录结构

```
AppleBooksClone/
├── AppleBooksClone.xcodeproj/          # 完整 Xcode 工程配置文件
│   ├── project.pbxproj                 # 包含全部 29 个源码引用的 PBX 配置文件
│   └── xcshareddata/xcschemes/
│       └── AppleBooksClone.xcscheme    # CI/CD 共享自动化 Scheme
├── AppleBooksClone/
│   ├── App/
│   │   ├── AppleBooksApp.swift         # App 启动入口
│   │   └── Info.plist                  # 应用信息配置清单
│   ├── Models/
│   │   ├── Book.swift                  # 图书模型、分类、排序模式、封面样式
│   │   ├── Chapter.swift               # 章节正文数据模型
│   │   └── ReadingGoal.swift           # 每日阅读打卡与连续天数
│   ├── ViewModels/
│   │   └── BooksViewModel.swift        # 全局状态管理（筛选过滤、阅读时长回写、页码持久化）
│   ├── Views/
│   │   ├── MainTabView.swift           # 根视图，承载全屏悬浮 LiquidGlassTabBar
│   │   ├── Components/
│   │   │   ├── LiquidGlassModifier.swift # 液态玻璃材质修饰符、高光边框、按压微动效
│   │   │   ├── LiquidGlassTabBar.swift   # 底部悬浮流体液态玻璃 5-Tab 胶囊栏
│   │   │   ├── BookCoverView.swift       # 3D 光影真实书脊封面
│   │   │   ├── CircularProgressView.swift# 环形流体进度条
│   │   │   ├── ReadingProgressBar.swift  # 胶囊平滑阅读进度条
│   │   │   └── Color+Hex.swift           # 十六进制颜色转换
│   │   ├── ReadingNow/
│   │   │   ├── ReadingNowView.swift      # “主页”视图：探索书店玻璃胶囊、一周打卡打勾圆环、今年读过的图书、正在阅读
│   │   │   ├── CurrentlyReadingCard.swift# 正在阅读液态玻璃卡片
│   │   │   ├── HorizontalBookShelf.swift # 横向流动图书展架
│   │   │   └── ReadingGoalCard.swift     # 阅读目标环形卡片
│   │   ├── Library/
│   │   │   ├── LibraryView.swift         # “书库”主界面：书库大标题、圆形玻璃按钮、弹窗菜单
│   │   │   ├── LiquidGlassMenuSheet.swift# 书库浮动液态玻璃操作菜单
│   │   │   ├── BookGridView.swift        # 2列网格（含“新增”蓝标、百分比、云朵下载与更多）
│   │   │   ├── BookListView.swift        # 列表视图
│   │   │   ├── BookRowView.swift         # 列表项单行组件
│   │   │   └── CategoryPillsView.swift   # 胶囊分类筛选器
│   │   ├── Detail/
│   │   │   └── BookDetailView.swift      # 图书详情页液态玻璃 Sheet
│   │   └── Reader/
│   │       ├── ReaderView.swift          # 全屏液态玻璃阅读器
│   │       ├── LiquidGlassReaderMenu.swift # 右下角展开的液态玻璃阅读菜单
│   │       ├── VerticalPageScrubber.swift  # 右侧边缘竖向液态玻璃进度滑杆
│   │       ├── ReaderSettingsView.swift  # “Aa”排版与主题设置面板
│   │       ├── TableOfContentsView.swift # 目录抽屉
│   │       └── ReaderThemes.swift        # 阅读主题配色
│   └── Assets.xcassets/
├── .github/
│   └── workflows/
│       └── build-ipa.yml                 # GitHub Actions 自动化打包免签名 IPA 流程
└── README.md
```

---

## 🚀 GitHub Actions 自动化打包免签 IPA

每次推送到 `main` 或 `master` 分支，GitHub Actions（`macos-14` Apple Silicon Runner）均会自动执行：
1. `xcodebuild` 编译 Release 归档（禁用 Code Signing：`CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO`）；
2. 提取 `AppleBooksClone.app` 到 `Payload/` 目录下；
3. 打包生成 `AppleBooksClone.ipa` 并上传至 Artifacts 供直接下载；
4. 用户下载后可直接使用企业证书（如 `zsign` 或 `iOS App Signer`）进行自签名。
