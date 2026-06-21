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

    /// The bare IPA symbols (no slashes / arrows) — e.g. "/eɪ/" → "eɪ".
    var soundIPA: String {
        if let range = ipa.range(of: "/[^/]+/", options: .regularExpression) {
            return String(ipa[range]).replacingOccurrences(of: "/", with: "")
        }
        return ipa.replacingOccurrences(of: "/", with: "")
            .trimmingCharacters(in: .whitespaces)
    }

    /// Stable key for the "now playing the sound" highlight (distinct from word playback).
    var soundKey: String { "sound-\(id.uuidString)" }

    /// A respelling that the speech engine pronounces as this *isolated phoneme*.
    /// AVSpeechSynthesizer does not reliably honour raw IPA notation, so we feed it a
    /// plain-text cue keyed on the phoneme's IPA (e.g. /iː/ → "ee", /tʃ/ → "chuh").
    /// Stretchy continuants are doubled; stops/affricates take a light "-uh" the way
    /// phonics is taught aloud. Falls back to the grapheme if unmapped.
    var soundSpelling: String {
        Phoneme.respelling[soundIPA] ?? grapheme
    }

    /// Filename stem of the pre-rendered audio clip for this sound (per accent:
    /// "<code>_uk.m4a" / "<code>_us.m4a"). Empty when no clip exists (→ TTS fallback).
    /// Keyed on IPA so every grapheme sharing a sound reuses the same clip.
    var audioCode: String { Phoneme.audioCodes[soundIPA] ?? "" }

    /// IPA → audio-clip code. Kept in sync with tools/generate_phoneme_audio.py.
    static let audioCodes: [String: String] = [
        "b": "b", "d": "d", "ɡ": "g", "k": "k", "p": "p", "t": "t", "dʒ": "j", "tʃ": "ch",
        "h": "h", "w": "w", "j": "y", "f": "f", "v": "v", "s": "s", "z": "z", "ʃ": "sh",
        "m": "m", "n": "n", "l": "l", "r": "r", "θ": "th", "ð": "dh", "ŋ": "ng",
        "æ": "ae", "ɛ": "eh", "ɪ": "ih", "ɒ": "aa", "ʌ": "ah",
        "eɪ": "ay", "iː": "ee", "aɪ": "eye", "oʊ": "oh", "juː": "yoo", "uː": "oo",
        "ɔɪ": "oy", "aʊ": "ow", "ɔː": "aw", "ɑːr": "ar", "ɔːr": "or", "ɜːr": "er",
        "bl": "bl", "kl": "cl", "fl": "fl", "ɡr": "gr", "tr": "tr",
        "st": "st", "sp": "sp", "sn": "sn", "str": "str"
    ]

    /// IPA → engine-friendly respelling. Multiple graphemes share an IPA (ai/ay/a_e → /eɪ/).
    static let respelling: [String: String] = [
        // Consonants — stops/affricates take a light schwa; continuants are stretched.
        "b": "buh", "d": "duh", "ɡ": "guh", "g": "guh", "k": "kuh", "p": "puh", "t": "tuh",
        "dʒ": "juh", "tʃ": "chuh",
        "f": "fuh", "v": "vuh", "h": "huh", "w": "wuh", "j": "yuh", "r": "ruh", "l": "luh",
        "s": "sss", "z": "zzz", "m": "mmm", "n": "nnn", "ʃ": "shh", "ŋ": "ung",
        "θ": "thh", "ð": "thuh",
        // Short vowels (clipped — inherently approximate in isolation).
        "æ": "aah", "ɛ": "eh", "ɪ": "ih", "ɒ": "aw", "ʌ": "uh",
        // Long vowels & vowel teams.
        "eɪ": "ay", "iː": "ee", "aɪ": "eye", "oʊ": "oh", "juː": "yoo", "uː": "oo",
        // Diphthongs.
        "ɔɪ": "oy", "aʊ": "ow", "ɔː": "aw",
        // R-controlled.
        "ɑːr": "are", "ɔːr": "or", "ɜːr": "er",
        // Consonant blends — said as the cluster onset.
        "bl": "bluh", "kl": "cluh", "fl": "fluh", "ɡr": "gruh", "tr": "truh",
        "st": "stuh", "sp": "spuh", "sn": "snuh", "str": "struh"
    ]
}
