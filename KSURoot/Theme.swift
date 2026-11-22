import SwiftUI

extension Color {
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: 1.0
        )
    }
}

struct Palette {
    var primary: Color
    var onPrimary: Color
    var primaryContainer: Color
    var onPrimaryContainer: Color
    var secondaryContainer: Color
    var onSecondaryContainer: Color
    var surface: Color
    var surfaceContainer: Color
    var surfaceBright: Color
    var surfaceContainerHigh: Color
    var onSurface: Color
    var onSurfaceVariant: Color
    var outline: Color
    var error: Color
    var errorContainer: Color
    var onErrorContainer: Color
}

enum Seed: Int, CaseIterable {
    case green, blue, purple, orange, red
    var name: String {
        switch self {
        case .green: return "绿色"
        case .blue: return "蓝色"
        case .purple: return "紫色"
        case .orange: return "橙色"
        case .red: return "红色"
        }
    }
    var swatch: Color {
        switch self {
        case .green: return Color(hex: 0x4CAF50)
        case .blue: return Color(hex: 0x2F6FEB)
        case .purple: return Color(hex: 0x9C27B0)
        case .orange: return Color(hex: 0xFF9800)
        case .red: return Color(hex: 0xF44336)
        }
    }
}

final class ThemeManager: ObservableObject {
    @Published var isDark: Bool = true
    @Published var amoled: Bool = false
    @Published var seed: Int = 0
    @Published var uiMode: Int = 0   // 0 = Material 3, 1 = Miuix

    // 对应 SettingsUiState 默认值
    @Published var enableBlur: Bool = true
    @Published var enableFloatingBar: Bool = true
    @Published var enableFloatingBarBlur: Bool = true
    @Published var enableNavBadge: Bool = true
    @Published var enableSwipeDismiss: Bool = true
    @Published var enablePredictiveBack: Bool = false
    @Published var pageScale: Double = 1.0
    @Published var moduleDescMaxLines: Int = 4

    var palette: Palette {
        buildPalette(seed: Seed(rawValue: seed) ?? .green, isDark: isDark, amoled: amoled)
    }

    var modeName: String {
        if amoled { return "AMOLED 黑" }
        return isDark ? "深色" : "浅色"
    }

    func setUiMode(_ mode: Int) {
        uiMode = mode
        // Miuix 默认偏蓝、Material 默认偏绿（用户可再自选主题色覆盖）
        seed = mode == 1 ? 1 : 0
    }
}

func buildPalette(seed: Seed, isDark: Bool, amoled: Bool) -> Palette {
    var surface: Color
    var surfaceContainer: Color
    var surfaceBright: Color
    var surfaceContainerHigh: Color
    var onSurface: Color
    var onSurfaceVariant: Color
    var outline: Color

    if isDark {
        if amoled {
            surface = Color(hex: 0x000000)
            surfaceContainer = Color(hex: 0x0A0A0C)
            surfaceBright = Color(hex: 0x141416)
            surfaceContainerHigh = Color(hex: 0x1E1E21)
        } else {
            surface = Color(hex: 0x121214)
            surfaceContainer = Color(hex: 0x1A1A1C)
            surfaceBright = Color(hex: 0x232326)
            surfaceContainerHigh = Color(hex: 0x2C2C30)
        }
        onSurface = Color(hex: 0xE6E6E8)
        onSurfaceVariant = Color(hex: 0x9E9EA4)
        outline = Color(hex: 0x4A4A4E)
    } else {
        surface = Color(hex: 0xFDFBFF)
        surfaceContainer = Color(hex: 0xF2F0F4)
        surfaceBright = Color(hex: 0xFFFFFF)
        surfaceContainerHigh = Color(hex: 0xECE6F0)
        onSurface = Color(hex: 0x1B1B1E)
        onSurfaceVariant = Color(hex: 0x46464F)
        outline = Color(hex: 0x767680)
    }

    var primary: Color
    var onPrimary: Color
    var primaryContainer: Color
    var onPrimaryContainer: Color
    var secondaryContainer: Color
    var onSecondaryContainer: Color

    switch seed {
    case .green:
        if isDark {
            primary = Color(hex: 0xA9D6A3); onPrimary = Color(hex: 0x0B3A11)
            primaryContainer = Color(hex: 0x2C5A30); onPrimaryContainer = Color(hex: 0xC8EFC1)
            secondaryContainer = Color(hex: 0x2E4B31); onSecondaryContainer = Color(hex: 0xD1E9D0)
        } else {
            primary = Color(hex: 0x3B6939); onPrimary = Color(hex: 0xFFFFFF)
            primaryContainer = Color(hex: 0xBCF0B4); onPrimaryContainer = Color(hex: 0x00210A)
            secondaryContainer = Color(hex: 0xCEE9C8); onSecondaryContainer = Color(hex: 0x09200B)
        }
    case .blue:
        if isDark {
            primary = Color(hex: 0xAAC7FF); onPrimary = Color(hex: 0x002F65)
            primaryContainer = Color(hex: 0x284777); onPrimaryContainer = Color(hex: 0xD6E3FF)
            secondaryContainer = Color(hex: 0x2C3F5E); onSecondaryContainer = Color(hex: 0xD6E3FF)
        } else {
            primary = Color(hex: 0x3F5F90); onPrimary = Color(hex: 0xFFFFFF)
            primaryContainer = Color(hex: 0xD6E3FF); onPrimaryContainer = Color(hex: 0x001B3D)
            secondaryContainer = Color(hex: 0xD6E3FF); onSecondaryContainer = Color(hex: 0x001B3D)
        }
    case .purple:
        if isDark {
            primary = Color(hex: 0xD0BCFF); onPrimary = Color(hex: 0x371E73)
            primaryContainer = Color(hex: 0x4F378B); onPrimaryContainer = Color(hex: 0xEADDFF)
            secondaryContainer = Color(hex: 0x4A4458); onSecondaryContainer = Color(hex: 0xE8DEF8)
        } else {
            primary = Color(hex: 0x6750A4); onPrimary = Color(hex: 0xFFFFFF)
            primaryContainer = Color(hex: 0xEADDFF); onPrimaryContainer = Color(hex: 0x21005D)
            secondaryContainer = Color(hex: 0xE8DEF8); onSecondaryContainer = Color(hex: 0x1D192B)
        }
    case .orange:
        if isDark {
            primary = Color(hex: 0xFFB787); onPrimary = Color(hex: 0x522300)
            primaryContainer = Color(hex: 0x7A3F0F); onPrimaryContainer = Color(hex: 0xFFDCC6)
            secondaryContainer = Color(hex: 0x5C4030); onSecondaryContainer = Color(hex: 0xFFDCC6)
        } else {
            primary = Color(hex: 0x8B5000); onPrimary = Color(hex: 0xFFFFFF)
            primaryContainer = Color(hex: 0xFFDCC6); onPrimaryContainer = Color(hex: 0x2D1600)
            secondaryContainer = Color(hex: 0xFFDCC6); onSecondaryContainer = Color(hex: 0x2D1600)
        }
    case .red:
        if isDark {
            primary = Color(hex: 0xFFB4AB); onPrimary = Color(hex: 0x690005)
            primaryContainer = Color(hex: 0x93000A); onPrimaryContainer = Color(hex: 0xFFDAD6)
            secondaryContainer = Color(hex: 0x5C4040); onSecondaryContainer = Color(hex: 0xFFDAD6)
        } else {
            primary = Color(hex: 0x8C1D18); onPrimary = Color(hex: 0xFFFFFF)
            primaryContainer = Color(hex: 0xFFDAD6); onPrimaryContainer = Color(hex: 0x410002)
            secondaryContainer = Color(hex: 0xFFDAD6); onSecondaryContainer = Color(hex: 0x410002)
        }
    }

    let error = isDark ? Color(hex: 0xFFB4AB) : Color(hex: 0xBA1A1A)
    let errorContainer = isDark ? Color(hex: 0x93000A) : Color(hex: 0xFFDAD6)
    let onErrorContainer = isDark ? Color(hex: 0xFFDAD6) : Color(hex: 0x410002)

    return Palette(
        primary: primary, onPrimary: onPrimary,
        primaryContainer: primaryContainer, onPrimaryContainer: onPrimaryContainer,
        secondaryContainer: secondaryContainer, onSecondaryContainer: onSecondaryContainer,
        surface: surface, surfaceContainer: surfaceContainer,
        surfaceBright: surfaceBright, surfaceContainerHigh: surfaceContainerHigh,
        onSurface: onSurface, onSurfaceVariant: onSurfaceVariant, outline: outline,
        error: error, errorContainer: errorContainer, onErrorContainer: onErrorContainer
    )
}