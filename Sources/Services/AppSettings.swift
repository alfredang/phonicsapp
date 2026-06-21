import Foundation
import SwiftUI

/// The accent the speech engine should use.
enum Accent: String, CaseIterable, Identifiable {
    case british  = "British"
    case american = "American"

    var id: String { rawValue }

    /// BCP-47 language used to pick an AVSpeechSynthesisVoice.
    var languageCode: String {
        switch self {
        case .british:  return "en-GB"
        case .american: return "en-US"
        }
    }

    var flag: String {
        switch self {
        case .british:  return "🇬🇧"
        case .american: return "🇺🇸"
        }
    }

    var subtitle: String {
        switch self {
        case .british:  return "Received Pronunciation (en-GB)"
        case .american: return "General American (en-US)"
        }
    }
}

/// App-wide preferences, persisted via @AppStorage.
final class AppSettings: ObservableObject {
    @AppStorage("accent") private var accentRaw: String = Accent.british.rawValue
    @AppStorage("speechRate") var speechRate: Double = 0.48   // AVSpeechUtterance scale
    @AppStorage("hasSeenWelcome") var hasSeenWelcome: Bool = false

    var accent: Accent {
        get { Accent(rawValue: accentRaw) ?? .british }
        set { objectWillChange.send(); accentRaw = newValue.rawValue }
    }
}
