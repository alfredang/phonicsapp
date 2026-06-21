import Foundation
import AVFoundation
import SwiftUI

/// Wraps AVSpeechSynthesizer to provide accent-aware, emotion-aware voice-over.
///
/// Note: the on-device AVSpeechSynthesizer ships genuine en-GB and en-US voices,
/// so accent selection is real and works fully offline. A future version could
/// swap this engine for Kyutai's Pocket-TTS (kyutai.org/pocket-tts-technical-report)
/// behind the same `speak(...)` interface without touching the views.
final class SpeechManager: NSObject, ObservableObject {
    @Published private(set) var isSpeaking = false
    /// Text of the utterance currently playing (for per-row highlight in lists).
    @Published private(set) var nowPlaying: String?

    private let synthesizer = AVSpeechSynthesizer()

    override init() {
        super.init()
        synthesizer.delegate = self
        configureAudioSession()
    }

    private func configureAudioSession() {
        // Playback category so voice-over is audible even with the silent switch on.
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
        try? session.setActive(true, options: [])
    }

    /// Speak `text` in the given accent, optionally shaped by an emotion preset.
    func speak(_ text: String,
               accent: Accent,
               emotion: Emotion? = nil,
               rate: Double? = nil) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        // Replace any current utterance immediately.
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = preferredVoice(for: accent)
        utterance.rate = emotion?.rate ?? Float(rate ?? 0.48)
        utterance.pitchMultiplier = emotion?.pitchMultiplier ?? 1.0
        utterance.volume = emotion?.volume ?? 1.0
        utterance.preUtteranceDelay = emotion?.preDelay ?? 0
        utterance.postUtteranceDelay = 0.05

        nowPlaying = text
        synthesizer.speak(utterance)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        nowPlaying = nil
        isSpeaking = false
    }

    /// Pick the best installed voice for the accent. Prefers a known premium/enhanced
    /// named voice, then any voice matching the language, then the default.
    private func preferredVoice(for accent: Accent) -> AVSpeechSynthesisVoice? {
        let voices = AVSpeechSynthesisVoice.speechVoices()
            .filter { $0.language == accent.languageCode }

        // Prefer enhanced/premium quality when the user has downloaded one.
        if let best = voices.sorted(by: { $0.quality.rawValue > $1.quality.rawValue }).first {
            return best
        }
        return AVSpeechSynthesisVoice(language: accent.languageCode)
    }
}

extension SpeechManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ s: AVSpeechSynthesizer, didStart u: AVSpeechUtterance) {
        DispatchQueue.main.async { self.isSpeaking = true }
    }
    func speechSynthesizer(_ s: AVSpeechSynthesizer, didFinish u: AVSpeechUtterance) {
        DispatchQueue.main.async { self.isSpeaking = false; self.nowPlaying = nil }
    }
    func speechSynthesizer(_ s: AVSpeechSynthesizer, didCancel u: AVSpeechUtterance) {
        DispatchQueue.main.async { self.isSpeaking = false; self.nowPlaying = nil }
    }
}
