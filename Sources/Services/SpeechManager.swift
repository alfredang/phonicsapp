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
    private var audioPlayer: AVAudioPlayer?

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
        // Replace any current utterance / clip immediately.
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        audioPlayer?.stop()
        audioPlayer = nil

        // Emotions reshape the sentence's punctuation so the synthesizer applies real
        // prosody (rising questions, excited bursts, trailing sadness).
        let spoken = emotion?.render(text) ?? text
        let utterance = AVSpeechUtterance(string: spoken)
        utterance.voice = preferredVoice(for: accent)
        utterance.rate = emotion?.rate ?? Float(rate ?? 0.48)
        utterance.pitchMultiplier = emotion?.pitchMultiplier ?? 1.0
        utterance.volume = emotion?.volume ?? 1.0
        utterance.preUtteranceDelay = emotion?.preDelay ?? 0
        utterance.postUtteranceDelay = 0.05

        nowPlaying = text
        synthesizer.speak(utterance)
    }

    /// Speak the *isolated sound* of a grapheme (e.g. /iː/), using a respelling the engine
    /// pronounces correctly — not the example word, and not raw IPA (which the on-device
    /// voices don't reliably honour). `text` is `Phoneme.soundSpelling`.
    func speakSound(text: String, accent: Accent, key: String) {
        let cue = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cue.isEmpty else { return }
        if synthesizer.isSpeaking { synthesizer.stopSpeaking(at: .immediate) }

        let utterance = AVSpeechUtterance(string: cue)
        utterance.voice = preferredVoice(for: accent)
        utterance.rate = 0.38              // slower — an isolated sound, not a word
        utterance.pitchMultiplier = 1.0
        utterance.postUtteranceDelay = 0.05

        nowPlaying = key
        synthesizer.speak(utterance)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        audioPlayer?.stop()
        audioPlayer = nil
        nowPlaying = nil
        isSpeaking = false
    }

    /// Play a real human recording of `word` (bundled from Wiktionary / Wikimedia Commons),
    /// preferring the chosen accent and falling back to the other accent, then to TTS.
    /// `key` drives the "now playing" highlight (defaults to the word itself).
    func speakWord(_ word: String, accent: Accent, key: String? = nil) {
        synthesizer.stopSpeaking(at: .immediate)
        audioPlayer?.stop()
        audioPlayer = nil

        let base = word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let order = (accent == .british) ? ["uk", "us", "au"] : ["us", "uk", "au"]
        let url = order.lazy
            .compactMap { Bundle.main.url(forResource: "\(base)_\($0)", withExtension: "m4a") }
            .first

        if let url, let player = try? AVAudioPlayer(contentsOf: url) {
            player.delegate = self
            audioPlayer = player
            nowPlaying = key ?? word
            isSpeaking = true
            player.play()
            return
        }
        // No recording for this word → synthesize it.
        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = preferredVoice(for: accent)
        utterance.rate = 0.46
        nowPlaying = key ?? word
        synthesizer.speak(utterance)
    }

    /// Demonstrate a phoneme's sound via TTS, fed a "hidden" cue word/letter (not shown on
    /// screen) chosen so the engine says the target sound as closely as possible — e.g.
    /// /juː/ → "you", /aɪ/ → "eye", /ɑːr/ → "are". (Temporary: TTS can't fully isolate
    /// short vowels and stops; real recordings remain the only exact route.)
    func speakPhoneme(_ phoneme: Phoneme, accent: Accent) {
        speakSound(text: phoneme.soundSpelling, accent: accent, key: phoneme.soundKey)
    }

    /// Pick the best installed voice for the accent and the user's gender preference.
    /// Filters by language, then by gender when matching voices exist, then by quality.
    /// (Gender is read from the shared defaults so call sites don't need to thread it.)
    private func preferredVoice(for accent: Accent) -> AVSpeechSynthesisVoice? {
        let desired = VoiceGender(rawValue: UserDefaults.standard.string(forKey: "voiceGender") ?? "")
            ?? .female
        let target: AVSpeechSynthesisVoiceGender = (desired == .male) ? .male : .female

        // Only voices that actually match this accent's region. Crucially we never fall
        // back to a different region's default (which made en-GB and en-US sound alike) —
        // if no exact-region voice exists we still pin the language so the OS supplies the
        // correct accent rather than the device default.
        let regionVoices = AVSpeechSynthesisVoice.speechVoices()
            .filter { $0.language == accent.languageCode }

        let gendered = regionVoices.filter { $0.gender == target }
        let pool = gendered.isEmpty ? regionVoices : gendered

        // Prefer premium/enhanced quality (more distinct, richer accent) when available.
        if let best = pool.max(by: { $0.quality.rawValue < $1.quality.rawValue }) {
            return best
        }
        // Last resort: construct directly from the language code (still the right accent).
        return AVSpeechSynthesisVoice(language: accent.languageCode)
    }
}

extension SpeechManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async { self.isSpeaking = false; self.nowPlaying = nil }
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
