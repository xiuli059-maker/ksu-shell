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

// Material 3 dark color scheme seeded green (AMOLED-friendly base)
enum Theme {
    static let primary = Color(hex: 0xA9D6A3)
    static let onPrimary = Color(hex: 0x0B3A11)
    static let primaryContainer = Color(hex: 0x2C5A30)
    static let onPrimaryContainer = Color(hex: 0xC8EFC1)

    static let secondaryContainer = Color(hex: 0x2E4B31)
    static let onSecondaryContainer = Color(hex: 0xD1E9D0)

    static let tertiaryContainer = Color(hex: 0x384B39)
    static let onTertiaryContainer = Color(hex: 0xD3E7D2)

    static let surface = Color(hex: 0x0F1310)
    static let surfaceContainer = Color(hex: 0x161B17)
    static let surfaceBright = Color(hex: 0x1E241F)
    static let surfaceContainerHigh = Color(hex: 0x262C27)

    static let onSurface = Color(hex: 0xE1E3DD)
    static let onSurfaceVariant = Color(hex: 0xC1C9BC)
    static let outline = Color(hex: 0x8B9389)

    static let error = Color(hex: 0xFFB4AB)
    static let errorContainer = Color(hex: 0x93000A)
    static let onErrorContainer = Color(hex: 0xFFDAD6)
}