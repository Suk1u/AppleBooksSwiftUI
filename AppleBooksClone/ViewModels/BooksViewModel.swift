import SwiftUI
import Combine

public final class BooksViewModel: ObservableObject {
    @Published public var books: [Book] = []
    @Published public var readingGoal: ReadingGoal = ReadingGoal()
    @Published public var selectedCategory: BookCategory = .all
    @Published public var selectedSort: SortOption = .recent
    @Published public var viewMode: ViewMode = .grid
    @Published public var searchText: String = ""

    // 当前在阅读器中打开的书籍
    @Published public var activeReadingBook: Book? = nil
    // 当前查看详情的书籍
    @Published public var selectedDetailBook: Book? = nil

    public init() {
        loadSampleBooks()
    }

    // 正在阅读的书籍列表（阅读进度大于0且未读完，或最近读过）
    public var currentlyReadingBooks: [Book] {
        books.filter { $0.currentPage > 0 && !$0.isFinished }
            .sorted { ($0.lastReadDate ?? .distantPast) > ($1.lastReadDate ?? .distantPast) }
    }

    // 欲读清单书籍
    public var wantToReadBooks: [Book] {
        books.filter { $0.isWantToRead }
    }

    // 已读完书籍
    public var finishedBooks: [Book] {
        books.filter { $0.isFinished }
    }

    // 书库过滤与排序后的书籍列表
    public var filteredLibraryBooks: [Book] {
        var result = books

        // 标签筛选
        switch selectedCategory {
        case .all:
            break
        case .reading:
            result = result.filter { $0.currentPage > 0 && !$0.isFinished }
        case .wantToRead:
            result = result.filter { $0.isWantToRead }
        case .finished:
            result = result.filter { $0.isFinished }
        case .fiction, .sciFi, .business, .philosophy:
            result = result.filter { $0.category == selectedCategory }
        }

        // 搜索关键词
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            result = result.filter { book in
                book.title.localizedCaseInsensitiveContains(trimmed) ||
                book.author.localizedCaseInsensitiveContains(trimmed) ||
                book.synopsis.localizedCaseInsensitiveContains(trimmed)
            }
        }

        // 排序规则
        switch selectedSort {
        case .recent:
            result.sort { ($0.lastReadDate ?? .distantPast) > ($1.lastReadDate ?? .distantPast) }
        case .title:
            result.sort { $0.title.localizedCompare($1.title) == .orderedAscending }
        case .author:
            result.sort { $0.author.localizedCompare($1.author) == .orderedAscending }
        case .progress:
            result.sort { $0.progressPercentage > $1.progressPercentage }
        }

        return result
    }

    // 更新书籍进度
    public func updateProgress(for bookId: UUID, toPage newPage: Int) {
        guard let index = books.firstIndex(where: { $0.id == bookId }) else { return }
        books[index].currentPage = max(1, min(newPage, books[index].totalPages))
        books[index].lastReadDate = Date()
        if books[index].currentPage >= books[index].totalPages {
            books[index].isFinished = true
        }
        // 同步正在阅读的 activeReadingBook
        if activeReadingBook?.id == bookId {
            activeReadingBook = books[index]
        }
        // 更新今日目标
        readingGoal.todayMinutes += 2
        readingGoal.lastUpdatedDate = Date()
    }

    // 切换欲读状态
    public func toggleWantToRead(for bookId: UUID) {
        guard let index = books.firstIndex(where: { $0.id == bookId }) else { return }
        books[index].isWantToRead.toggle()
        if selectedDetailBook?.id == bookId {
            selectedDetailBook = books[index]
        }
    }

    // 切换已读完状态
    public func toggleFinished(for bookId: UUID) {
        guard let index = books.firstIndex(where: { $0.id == bookId }) else { return }
        books[index].isFinished.toggle()
        if books[index].isFinished {
            books[index].currentPage = books[index].totalPages
        }
        if selectedDetailBook?.id == bookId {
            selectedDetailBook = books[index]
        }
    }

    private func loadSampleBooks() {
        self.books = [
            Book(
                title: "三体",
                subtitle: "地球往事三部曲之一",
                author: "刘慈欣",
                category: .sciFi,
                synopsis: "文化大革命如火如荼地进行，军方探寻外星文明的绝秘计划“红岸工程”取得了突破性进展。但在按下发射键的那一刻，历经劫难的叶文洁没有意识到，她彻底改变了人类的命运。地球文明向宇宙发出的第一声啼鸣，以太阳为中心，向宇宙深处飞驰……",
                rating: 4.9,
                ratingCount: 28410,
                totalPages: 302,
                currentPage: 142,
                isWantToRead: false,
                isFinished: false,
                lastReadDate: Date().addingTimeInterval(-1800),
                coverTheme: BookCoverTheme(primary: "#1A2A6C", secondary: "#B21F1F", text: "#FFFFFF"),
                chapters: [
                    Chapter(title: "第一章 科学边界", content: "汪淼觉得，纳米中心最近的气氛有些古怪。这种古怪不是由于什么突发事件引起的，而是一种悄然滋生的反常。基础理论物理的进展停滞了，许多著名的物理学家相继离世，世界的物理学界笼罩在一种压抑而诡秘的气氛中。", startPage: 1, pageCount: 25),
                    Chapter(title: "第二章 射手与农场主", content: "“射手”假说：有一名神枪手，在一个靶子上每隔十厘米打一个洞。设想这个靶子上生活着一种二维智能生物，它们通过观察，发现了宇宙的一个伟大定律：“宇宙每隔十厘米必有一个洞。”它们把神枪手一时兴起的随意行为，看成了宇宙的固有规律。\n\n“农场主”假说：一个农场里有一群火鸡，农场主每天中午十一点来给它们喂食。火鸡中的科学家观察了这个现象，一直观察了近一年都没有例外，于是它也发现了宇宙定律：“每天上午十一点，食物降临。”但在感恩节这天上午十一点，食物没有降临，农场主进来把它们都捉去杀了。", startPage: 26, pageCount: 30),
                    Chapter(title: "第三章 红岸基地", content: "叶文洁默默地站在红岸基地的巨型抛物面天线下。天线如同一个巨大的金属碗，高耸入云，指向深邃寂静的太空。冷风从大兴安岭的松林吹过，带起阵阵林涛。", startPage: 56, pageCount: 40),
                    Chapter(title: "第四章 宇宙闪烁", content: "汪淼戴上墨镜，走出观测室。午夜的夜空在3K宇宙微波背景辐射的波段下，开始有节奏地明暗交替——整个宇宙，在为他闪烁。", startPage: 96, pageCount: 46)
                ]
            ),
            Book(
                title: "纳瓦尔宝典",
                subtitle: "致富与幸福指南",
                author: "埃里克·乔根森",
                category: .business,
                synopsis: "致富不是靠运气，幸福也不是从天而降的。积累财富和幸福生活都是我们可以通过学习掌握的技能。本书汇集了硅谷传奇投资人纳瓦尔·拉维肯特的智慧箴言与人生哲学。",
                rating: 4.8,
                ratingCount: 15200,
                totalPages: 240,
                currentPage: 88,
                isWantToRead: false,
                isFinished: false,
                lastReadDate: Date().addingTimeInterval(-86400),
                coverTheme: BookCoverTheme(primary: "#0F2027", secondary: "#203A43", text: "#E0EAFC"),
                chapters: [
                    Chapter(title: "第一部分 积累财富", content: "把自己产品化。追求财富，而不是金钱或地位。财富是指在你睡觉时仍能为你赚钱的资产。金钱是我们转换时间和财富的工具。地位是你在社会等级体系中的位置。", startPage: 1, pageCount: 40),
                    Chapter(title: "第二部分 杠杆的力量", content: "现代杠杆有三种：第一种是人力杠杆，也就是为你工作的人；第二种是资本杠杆，也就是用钱生钱；第三种是新时代的杠杆：复制边际成本为零的产品，包括代码和媒体。", startPage: 41, pageCount: 47),
                    Chapter(title: "第三部分 学习幸福", content: "幸福是一种技能，就像营养学和健身一样。幸福是内心的平静，是放下对未来和过去的过度执念，全然专注于当下。", startPage: 88, pageCount: 40)
                ]
            ),
            Book(
                title: "百年孤独",
                subtitle: "魔幻现实主义文学巅峰",
                author: "加西亚·马尔克斯",
                category: .fiction,
                synopsis: "布恩迪亚家族七代人在虚构小镇马孔多的传奇兴衰史。马尔克斯融魔幻与现实于一炉，借由这片热带土地上的爱恨情仇与孤独宿命，展现了拉美历史的沧桑与瑰丽。",
                rating: 4.9,
                ratingCount: 39120,
                totalPages: 360,
                currentPage: 360,
                isWantToRead: false,
                isFinished: true,
                lastReadDate: Date().addingTimeInterval(-604800),
                coverTheme: BookCoverTheme(primary: "#870000", secondary: "#190A05", text: "#FAD961"),
                chapters: [
                    Chapter(title: "第一章 吉卜赛人的魔术", content: "多年以后，面对行刑队，奥雷里亚诺·布恩迪亚上校将会回想起父亲带他去见识冰块的那个遥远的下午。那时的马孔多是一个二十户人家的村落，泥巴和芦苇盖成的房屋沿河岸排开。", startPage: 1, pageCount: 50)
                ]
            ),
            Book(
                title: "原子习惯",
                subtitle: "细微改变带来巨大成就",
                author: "詹姆斯·克利尔",
                category: .business,
                synopsis: "无论你的目标是什么，《原子习惯》都能为你提供一套行之有效的日常改善框架。微小的改变会随着时间的推移产生惊人的复利效应。",
                rating: 4.7,
                ratingCount: 19800,
                totalPages: 280,
                currentPage: 0,
                isWantToRead: true,
                isFinished: false,
                lastReadDate: nil,
                coverTheme: BookCoverTheme(primary: "#F3904F", secondary: "#3B4371", text: "#FFFFFF"),
                chapters: [
                    Chapter(title: "基本原理 微习惯的惊人力量", content: "1%的微小改变看似不起眼，但如果每天都能进步1%，一年之后你将进步37倍。习惯是自我提高的复利。", startPage: 1, pageCount: 35)
                ]
            ),
            Book(
                title: "置身事内",
                subtitle: "中国政府与经济发展",
                author: "兰小欢",
                category: .philosophy,
                synopsis: "本书将经济学逻辑与中国政治经济实践相结合，通俗易懂地讲述了中国地方政府推动经济发展的模式、机制与未来转型挑战。",
                rating: 4.9,
                ratingCount: 22100,
                totalPages: 328,
                currentPage: 210,
                isWantToRead: false,
                isFinished: false,
                lastReadDate: Date().addingTimeInterval(-43200),
                coverTheme: BookCoverTheme(primary: "#2C3E50", secondary: "#4CA1AF", text: "#ECE9E6"),
                chapters: [
                    Chapter(title: "第一章 微观机制", content: "在中国，政府不仅影响经济，其本身就是经济深度参与者。要理解中国经济，必须理解中国各级政府官员的激励机制与财政事权。", startPage: 1, pageCount: 45)
                ]
            ),
            Book(
                title: "沙丘",
                subtitle: "科幻史诗巨著",
                author: "弗兰克·赫伯特",
                category: .sciFi,
                synopsis: "在荒凉的厄拉科斯星球上，唯一的宝贵资源是香料美琅脂。少年保罗·厄崔迪踏入了这个被沙漠与沙虫统治的残酷世界，迎向自己的救世主宿命。",
                rating: 4.8,
                ratingCount: 31200,
                totalPages: 520,
                currentPage: 0,
                isWantToRead: true,
                isFinished: false,
                lastReadDate: nil,
                coverTheme: BookCoverTheme(primary: "#E65C00", secondary: "#F9D423", text: "#222222"),
                chapters: [
                    Chapter(title: "第一章 痛苦的试炼", content: "清晨的微光穿透了卡拉丹古堡的石窗。圣母莫希安让保罗将右手放入那个神秘的黑色盒子里——盒子里只有极致的痛苦，测试他究竟是人，还是动物。", startPage: 1, pageCount: 60)
                ]
            )
        ]
    }
}
