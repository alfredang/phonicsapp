import Foundation

enum PhonicsCategory: String, CaseIterable, Identifiable, Hashable {
    case consonant   = "Consonants"
    case shortVowel  = "Short Vowels"
    case longVowel   = "Long Vowels"
    case digraph     = "Digraphs"
    case blend       = "Blends"
    case vowelTeam   = "Vowel Teams"
    case diphthong   = "Diphthongs"
    case rControlled = "R-Controlled"
    case softSound   = "Soft Sounds"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .consonant:   return "character"
        case .shortVowel:  return "a.circle"
        case .longVowel:   return "a.circle.fill"
        case .digraph:     return "character.book.closed"
        case .blend:       return "link"
        case .vowelTeam:   return "person.2"
        case .diphthong:   return "waveform.path"
        case .rControlled: return "r.circle"
        case .softSound:   return "wind"
        }
    }

    var blurb: String {
        switch self {
        case .consonant:   return "Single consonant letter sounds."
        case .shortVowel:  return "The five short vowel sounds."
        case .longVowel:   return "Vowels that 'say their name', often via silent-e."
        case .digraph:     return "Two letters making one new sound."
        case .blend:       return "Two consonants blended, each still heard."
        case .vowelTeam:   return "Two vowels working together for one sound."
        case .diphthong:   return "Gliding vowel sounds that shift mid-sound."
        case .rControlled: return "Vowels reshaped by a following 'r'."
        case .softSound:   return "When c and g soften before e, i, or y."
        }
    }
}

/// A grapheme→phoneme unit the learner can tap to hear.
struct Phoneme: Identifiable, Hashable {
    let id = UUID()
    let grapheme: String          // e.g. "sh", "igh", "c"
    let ipa: String               // e.g. "/ʃ/"
    let soundDescription: String  // plain-language cue
    let exampleWords: [String]
    let category: PhonicsCategory

    /// What we feed the speech engine to demonstrate the isolated sound.
    var spokenSound: String { exampleWords.first ?? grapheme }
}
