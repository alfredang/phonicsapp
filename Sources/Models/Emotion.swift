import Foundation

/// An intonation/emotion preset that reshapes how a sentence is spoken.
/// Maps onto AVSpeechUtterance's rate / pitchMultiplier / volume / delay — and also
/// reshapes the sentence's punctuation, because the speech synthesizer's prosody
/// (rising questions, excited bursts, trailing sadness) responds far more strongly to
/// "!", "…" and "?" than to pitch alone. The combination makes each emotion unmistakable.
struct Emotion: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let systemImage: String
    let cue: String              // coaching tip on how the voice should move
    let rate: Float              // 0.0...1.0 (AVSpeechUtterance scale, default ~0.5)
    let pitchMultiplier: Float   // 0.5...2.0
    let volume: Float            // 0.0...1.0
    let preDelay: TimeInterval
    let punctuation: String      // re-applied to the sentence to drive prosody

    /// Strip any trailing sentence punctuation from `base`, then apply this emotion's.
    func render(_ base: String) -> String {
        let trimmed = base.trimmingCharacters(in: .whitespacesAndNewlines)
        let stripped = trimmed.replacingOccurrences(
            of: "[.!?…]+$", with: "", options: .regularExpression)
        return stripped + punctuation
    }

    static let all: [Emotion] = [
        Emotion(name: "Neutral",  systemImage: "minus.circle",
                cue: "Flat, even tone. A steady baseline to compare the others against.",
                rate: 0.46, pitchMultiplier: 1.00, volume: 1.0, preDelay: 0, punctuation: "."),
        Emotion(name: "Happy",    systemImage: "face.smiling",
                cue: "Bright and lifted — pitch rises and the pace quickens.",
                rate: 0.55, pitchMultiplier: 1.35, volume: 1.0, preDelay: 0, punctuation: "!"),
        Emotion(name: "Excited",  systemImage: "sparkles",
                cue: "Fast and high-energy, with big pitch jumps and a burst at the end.",
                rate: 0.64, pitchMultiplier: 1.55, volume: 1.0, preDelay: 0, punctuation: "!!"),
        Emotion(name: "Sad",      systemImage: "cloud.rain",
                cue: "Slow and low. Pitch sags and the energy trails away.",
                rate: 0.33, pitchMultiplier: 0.70, volume: 0.9, preDelay: 0.15, punctuation: "…"),
        Emotion(name: "Angry",    systemImage: "flame",
                cue: "Hard, low and forceful — clipped and punchy.",
                rate: 0.52, pitchMultiplier: 0.76, volume: 1.0, preDelay: 0, punctuation: "!"),
        Emotion(name: "Question", systemImage: "questionmark.circle",
                cue: "Rising intonation — the pitch climbs on the final words.",
                rate: 0.45, pitchMultiplier: 1.22, volume: 1.0, preDelay: 0, punctuation: "?"),
        Emotion(name: "Calm",     systemImage: "leaf",
                cue: "Gentle and unhurried. Soft volume, mid-low steady pitch.",
                rate: 0.36, pitchMultiplier: 0.90, volume: 0.8, preDelay: 0.1, punctuation: "."),
        Emotion(name: "Surprised", systemImage: "exclamationmark.2",
                cue: "Sudden high pitch on the key word, then settles.",
                rate: 0.50, pitchMultiplier: 1.6, volume: 1.0, preDelay: 0, punctuation: "?!")
    ]
}
