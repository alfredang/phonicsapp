import SwiftUI

/// Single source of truth for the app palette. Reference these tokens everywhere
/// instead of raw `Color` literals so a re-theme is a one-file change.
enum Theme {
    static let primary   = Color(hex: 0x4F46E5)   // indigo — key buttons, active states
    static let secondary = Color(hex: 0x0D9488)   // teal — links, selected accents
    static let highlight = Color(hex: 0xF59E0B)   // amber — badges, ratings, emphasis
    static let coral     = Color(hex: 0xEC4899)   // accent for emotion/intonation
    static let background = Color(hex: 0xF7F7FB)   // warm off-white app background
    static let surface    = Color(hex: 0xFFFFFF)   // card surface
    static let chip       = Color(hex: 0xEEEDFA)   // subtle fills, chips
    static let ink        = Color(hex: 0x1B1A2E)   // primary text (explicit, AA-safe on bg)
    static let mutedInk   = Color(hex: 0x6B6A7B)   // secondary text

    /// Per-category accent used across Learn cards and phoneme detail.
    static func accent(for category: PhonicsCategory) -> Color {
        switch category {
        case .consonant:     return Color(hex: 0x4F46E5)
        case .shortVowel:    return Color(hex: 0x0D9488)
        case .longVowel:     return Color(hex: 0x0EA5E9)
        case .digraph:       return Color(hex: 0xF59E0B)
        case .blend:         return Color(hex: 0xEC4899)
        case .vowelTeam:     return Color(hex: 0x8B5CF6)
        case .diphthong:     return Color(hex: 0xEF4444)
        case .rControlled:   return Color(hex: 0x059669)
        case .softSound:     return Color(hex: 0xD97706)
        }
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red:   Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue:  Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}

// MARK: - Reusable card surface

struct AppCard: ViewModifier {
    var padding: CGFloat = 16
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Theme.surface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: .black.opacity(0.06), radius: 10, y: 4)
    }
}

extension View {
    func appCard(padding: CGFloat = 16) -> some View {
        modifier(AppCard(padding: padding))
    }

    /// Standard screen background applied behind a scroll view.
    func screenBackground() -> some View {
        background(Theme.background.ignoresSafeArea())
    }
}
