import Foundation

enum PracticeKind: String, CaseIterable, Identifiable {
    case minimalPairs = "Minimal Pairs"
    case tongueTwisters = "Tongue Twisters"
    case shortMessages = "Short Messages"
    case sentences = "Sentence Drills"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .minimalPairs:   return "arrow.left.arrow.right"
        case .tongueTwisters: return "tongue"
        case .shortMessages:  return "text.bubble"
        case .sentences:      return "text.alignleft"
        }
    }

    var blurb: String {
        switch self {
        case .minimalPairs:   return "Two words that differ by a single sound. Hear the contrast, then say each."
        case .tongueTwisters: return "Repeat tricky sound clusters to build fluency and control."
        case .shortMessages:  return "Bite-size everyday phrases — perfect for a quick daily session."
        case .sentences:      return "Full sentences to practise rhythm, linking, and stress."
        }
    }
}

/// A minimal pair: two words differing by one phoneme.
struct MinimalPair: Identifiable, Hashable {
    let id = UUID()
    let first: String
    let second: String
    let contrast: String   // e.g. "short i vs long e"
}

/// A single practice line the learner reads aloud and can hear.
struct PracticeLine: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let focus: String      // what sound/skill it targets
}
