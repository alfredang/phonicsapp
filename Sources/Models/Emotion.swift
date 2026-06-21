import Foundation

/// An intonation/emotion preset that reshapes how a sentence is spoken.
/// Maps onto AVSpeechUtterance's rate / pitchMultiplier / volume / delay.
struct Emotion: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let systemImage: String
    let cue: String              // coaching tip on how the voice should move
    let rate: Float              // 0.0...1.0 (AVSpeechUtterance scale, default ~0.5)
    let pitchMultiplier: Float   // 0.5...2.0
    let volume: Float            // 0.0...1.0
    let preDelay: TimeInterval

    static let all: [Emotion] = [
        Emotion(name: "Neutral",  systemImage: "minus.circle",
                cue: "Flat, even tone. A steady baseline to compare against.",
                rate: 0.48, pitchMultiplier: 1.00, volume: 1.0, preDelay: 0),
        Emotion(name: "Happy",    systemImage: "face.smiling",
                cue: "Lift the pitch and quicken slightly — energy rises at the end.",
                rate: 0.54, pitchMultiplier: 1.22, volume: 1.0, preDelay: 0),
        Emotion(name: "Excited",  systemImage: "sparkles",
                cue: "Fast and bright. Big pitch jumps carry the excitement.",
                rate: 0.60, pitchMultiplier: 1.32, volume: 1.0, preDelay: 0),
        Emotion(name: "Sad",      systemImage: "cloud.rain",
                cue: "Slow and low. Pitch sags and the energy fades downward.",
                rate: 0.40, pitchMultiplier: 0.82, volume: 0.9, preDelay: 0.1),
        Emotion(name: "Angry",    systemImage: "flame",
                cue: "Hard and clipped. Lower pitch, punchy emphasis, firm volume.",
                rate: 0.50, pitchMultiplier: 0.88, volume: 1.0, preDelay: 0),
        Emotion(name: "Question", systemImage: "questionmark.circle",
                cue: "Rising intonation — the pitch climbs on the final words.",
                rate: 0.47, pitchMultiplier: 1.15, volume: 1.0, preDelay: 0),
        Emotion(name: "Calm",     systemImage: "leaf",
                cue: "Gentle and unhurried. Soft volume, mid-low steady pitch.",
                rate: 0.42, pitchMultiplier: 0.96, volume: 0.85, preDelay: 0.05),
        Emotion(name: "Surprised", systemImage: "exclamationmark.2",
                cue: "Sudden high pitch on the key word, then settles.",
                rate: 0.52, pitchMultiplier: 1.40, volume: 1.0, preDelay: 0)
    ]
}
