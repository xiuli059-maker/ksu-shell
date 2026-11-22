import Foundation

enum GestaltKeys {
    static let modelNumber = "97JDvERpVwO+GHtthIh7hA"
    static let regionCode = "h63QSdBCiT/z0WU6rdQv6Q"
    static let regionInfo = "zHeENZu+wbg7PUprwNwBWg"
}

struct ModelPreset: Identifiable {
    let id: String
    let title: String
    let value: String
    static let all: [ModelPreset] = [
        .init(id: "A3472", title: "A3472 · 18 Pro 美国", value: "A3472"),
        .init(id: "A3713", title: "A3713 · 18 Pro 加/日", value: "A3713"),
        .init(id: "A3714", title: "A3714 · 18 Pro 其他地区", value: "A3714"),
        .init(id: "A3715", title: "A3715 · 18 Pro 中国大陆", value: "A3715"),
        .init(id: "A3473", title: "A3473 · 18 Pro Max 美国", value: "A3473"),
        .init(id: "A3716", title: "A3716 · 18 Pro Max 加/日", value: "A3716"),
        .init(id: "A3717", title: "A3717 · 18 Pro Max 其他地区", value: "A3717"),
        .init(id: "A3718", title: "A3718 · 18 Pro Max 中国大陆", value: "A3718"),
        .init(id: "A3260", title: "A3260 · Air 美/加", value: "A3260"),
        .init(id: "A3516", title: "A3516 · Air 日本", value: "A3516"),
        .init(id: "A3517", title: "A3517 · Air 其他地区", value: "A3517"),
        .init(id: "A3518", title: "A3518 · Air 中国大陆", value: "A3518")
    ]
}

struct RegionPreset: Identifiable {
    let id: String
    let title: String
    let code: String
    let info: String
    static let all: [RegionPreset] = [
        .init(id: "US", title: "美国 LL", code: "LL", info: "LL/A"),
        .init(id: "HK", title: "香港 ZA", code: "ZA", info: "ZA/A"),
        .init(id: "JP", title: "日本 J", code: "J", info: "J/A"),
        .init(id: "CN", title: "中国大陆 CH", code: "CH", info: "CH/A"),
        .init(id: "TW", title: "台湾 TA", code: "TA", info: "TA/A"),
        .init(id: "UK", title: "英国 B", code: "B", info: "B/A"),
        .init(id: "CA", title: "加拿大 C", code: "C", info: "C/A")
    ]
}

enum CapabilityCategory: String, CaseIterable, Identifiable {
    case display = "显示"
    case device = "设备"
    case ipad = "iPad"
    case intelligence = "智能"
    case advanced = "高级"
    var id: String { rawValue }
    var symbol: String {
        switch self {
        case .display: return "display"
        case .device: return "iphone"
        case .ipad: return "ipad.landscape"
        case .intelligence: return "sparkles"
        case .advanced: return "wrench.and.screwdriver"
        }
    }
}

// 对照 GestaltX Capabilities.swift（GPL-3.0）的 MobileGestalt CacheExtra 键映射
struct Capability: Identifiable {
    let id: String
    let category: CapabilityCategory
    let title: String
    let detail: String
    let keys: [String]
    var caution: Bool = false
    var values: [String: Any]? = nil

    var enabledValue: Any { id == "ipadApps" ? [1, 2] : 1 }

    static let all: [Capability] = [
        .init(id: "dynamicIsland", category: .display, title: "灵动岛", detail: "启用替代灵动岛能力。", keys: ["YlEtTtHlNesRBMal1CqRaA"]),
        .init(id: "aod", category: .display, title: "全天候显示", detail: "显示行为取决于面板，可能增加功耗与烧屏风险。", keys: ["2OOJf1VhaM7NxfRok3HbWQ", "j8/Omm6s1lsmTDFsXjsBfA"], caution: true),
        .init(id: "aodVibrancy", category: .display, title: "AOD 鲜艳度", detail: "调整全天候渲染能力。", keys: ["ykpu7qyhqFweVMKtxNylWA"]),
        .init(id: "aodHighLuminance", category: .display, title: "高亮度全天候", detail: "允许 AOD 达到更高亮度。", keys: ["7brdL5xrEUWnlF9C0kdg5A"]),
        .init(id: "aodFlipbook", category: .display, title: "AOD 翻页小组件", detail: "在锁屏启用 AOD 翻页小组件。", keys: ["aoJSd/MXk7M40NgXTM6x+g"]),
        .init(id: "aodFlipbookCount", category: .display, title: "AOD 翻页数量", detail: "设置允许的 AOD 翻页条目数。", keys: ["qqrspu7CpuPdZwSDxNY+Fg"], caution: true, values: ["qqrspu7CpuPdZwSDxNY+Fg": 3]),
        .init(id: "parallax", category: .display, title: "关闭壁纸视差", detail: "停止壁纸随设备移动。", keys: ["UIParallaxCapability"], values: ["UIParallaxCapability": 0]),
        .init(id: "hdrPhotoDisplay", category: .display, title: "HDR 照片显示", detail: "为照片启用真正的 HDR 渲染。", keys: ["a1r7npIrhXsZ7SmKRKC1eA"]),
        .init(id: "pwm", category: .display, title: "PWM 调光", detail: "宣称 PWM 显示支持。", keys: ["6IejgN+1Fmu5/QrZFOIeNw"], caution: true),
        .init(id: "displayPort", category: .display, title: "DisplayPort 输出", detail: "宣称 DisplayPort 输出支持。", keys: ["CoWnN4xo783YGn4wLrUatA"], caution: true),
        .init(id: "liquidGlass", category: .display, title: "液态玻璃低功耗渲染", detail: "在 iOS 26+ 使用低性能渲染能力。", keys: ["SAGvsp6O6kAQ4fEfDJpC4Q"]),

        .init(id: "bootChime", category: .device, title: "开关机提示音", detail: "暴露启动/关机声音能力。", keys: ["QHxt+hGLaBPbQJbXiUJX3w"]),
        .init(id: "chargeLimit", category: .device, title: "充电上限", detail: "显示充电上限设置。", keys: ["37NVydb//GP/GrhuTN+exg"]),
        .init(id: "tapToWake", category: .device, title: "轻点唤醒", detail: "在隐藏该能力的设备上暴露轻点唤醒。", keys: ["yZf3GTRMGTuwSV/lD7Cagw"]),
        .init(id: "cameraControl", category: .device, title: "相机控制", detail: "显示相机控制设置。", keys: ["CwvKxM2cEogD3p+HYgaW0Q", "oOV1jhJbdV3AddkcCg0AEA"]),
        .init(id: "actionButton", category: .device, title: "操作按钮", detail: "显示操作按钮设置页。", keys: ["cT44WE1EohiwRzhsZ8xEsw"]),
        .init(id: "collisionSOS", category: .device, title: "碰撞检测 SOS", detail: "在紧急 SOS 显示碰撞检测。", keys: ["HCzWusHQwZDea6nNhaKndw"]),
        .init(id: "audioMix", category: .device, title: "音频混合", detail: "为支持的媒体启用音频混合。", keys: ["aVL5GE3tx0LSCI/ErfrJGA"]),
        .init(id: "spatialFaceTimeAudio", category: .device, title: "空间 FaceTime 音频", detail: "为 FaceTime 启用空间音频。", keys: ["/EVOCjM/Nmb2roP5ebtEFA"]),

        .init(id: "pencil", category: .ipad, title: "Apple Pencil", detail: "暴露 Apple Pencil 设置。", keys: ["yhHcB0iH0d1XzPO/CFd3ow"]),
        .init(id: "stageManager", category: .ipad, title: "台前调度", detail: "暴露台前调度支持。", keys: ["qeaj75wk3HF4DwQ8qbIi7g"], caution: true),
        .init(id: "ipadApps", category: .ipad, title: "iPad 应用兼容", detail: "在 iPhone 上允许 iPad 应用兼容类型。", keys: ["9MZ5AdH43csAUajl/dU+IQ"]),

        .init(id: "ai", category: .intelligence, title: "Apple Intelligence 能力", detail: "设置生成式模型能力。", keys: ["A62OafQ85EJAiiqKn4agtg"]),
        .init(id: "siriAIMode", category: .intelligence, title: "Siri AI 模式", detail: "将 SiriMode 设为 2。", keys: ["a3n5T9sFtlyQ74NEp9ESxg"], caution: true, values: ["a3n5T9sFtlyQ74NEp9ESxg": 2]),
        .init(id: "siriOnDevice", category: .intelligence, title: "端侧 Siri", detail: "Siri 使用设备特定能力类型。", keys: ["K/R1GfGfCkXvEhaPS2Vrng"], caution: true),
        .init(id: "audioIntelligence", category: .intelligence, title: "音频智能", detail: "宣称 iOS 27 音频智能能力。", keys: ["rb2tKZxlj0Gm2tBmUQSLqQ"], caution: true),
        .init(id: "personalTranslator", category: .intelligence, title: "个人翻译", detail: "宣称个人翻译能力。", keys: ["M1n2sAqf33NAOgZRGxQYBA"], caution: true),
        .init(id: "photosCleanUp", category: .intelligence, title: "照片消除", detail: "宣称照片修补（消除）能力。", keys: ["XNCjqOupLM/S8fNyxRNQTA"], caution: true),
        .init(id: "handwritingSynthesis", category: .intelligence, title: "手写合成", detail: "宣称手写合成模型能力。", keys: ["YgYIIViDt1kgzyIsIV61vA"], caution: true),
        .init(id: "alwaysListeningSiri", category: .intelligence, title: "始终监听 Hey Siri", detail: "宣称始终监听 Hey Siri 支持。", keys: ["TusANsf9Lfe3P/9fIXXSrQ"], caution: true),

        .init(id: "internal", category: .advanced, title: "Apple 内部功能", detail: "暴露内部菜单。", keys: ["EqrsVvjcYDdxHBiQmGhAWw"], caution: true),
        .init(id: "storage", category: .advanced, title: "Internal Build", detail: "修改系统级 InternalBuild 标记。", keys: ["LBJfwOEzExRxzlAnSuI7eg"], caution: true),
        .init(id: "srd", category: .advanced, title: "安全研究设备", detail: "修改 SRD 能力标记。", keys: ["XYlJKKkj2hztRP1NWWnhlw"], caution: true),
        .init(id: "internalSettings", category: .advanced, title: "内部设置包", detail: "暴露 Apple 内部设置包。", keys: ["Oji6HRoPi7rH7HPdWVakuw"], caution: true)
    ]
}