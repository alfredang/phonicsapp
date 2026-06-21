import SwiftUI

/// Demonstrates how intonation conveys emotion: the learner picks a sentence,
/// then hears it spoken through each emotion preset (pitch + rate + volume shaped).
struct EmotionPracticeView: View {
    @EnvironmentObject private var settings: AppSettings
    @EnvironmentObject private var speech: SpeechManager

    @State private var sentenceIndex = 0

    private var sentence: String { ContentLibrary.emotionScripts[sentenceIndex] }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Say it with feeling")
                    .font(.title.bold())
                    .foregroundStyle(Theme.ink)
                Text("The words stay the same — the meaning changes with your pitch, pace, and stress. Pick a line, then tap each emotion to hear the difference.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.mutedInk)

                // Sentence card with a shuffle/cycle control
                VStack(alignment: .leading, spacing: 14) {
                    Text("“\(sentence)”")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(Theme.ink)
                        .fixedSize(horizontal: false, vertical: true)
                    HStack {
                        Button {
                            sentenceIndex = (sentenceIndex + 1) % ContentLibrary.emotionScripts.count
                        } label: {
                            Label("Next line", systemImage: "arrow.triangle.2.circlepath")
                                .font(.subheadline.weight(.semibold))
                        }
                        .tint(Theme.coral)
                        Spacer()
                        Button {
                            speech.speak(sentence, accent: settings.accent,
                                         emotion: Emotion.all.first)   // Neutral baseline
                        } label: {
                            Label("Neutral", systemImage: "play.circle")
                                .font(.subheadline.weight(.semibold))
                        }
                        .tint(Theme.mutedInk)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .appCard(padding: 20)

                SectionHeader(title: "Emotions", systemImage: "theatermasks", tint: Theme.coral)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(Emotion.all) { emotion in
                        EmotionCard(emotion: emotion,
                                    isActive: speech.nowPlaying == sentence) {
                            speech.speak(sentence, accent: settings.accent, emotion: emotion)
                        }
                    }
                }
            }
            .padding(20)
        }
        .screenBackground()
        .navigationTitle("Intonation & Emotion")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .topBarTrailing) { AccentMenu() } }
    }
}

private struct EmotionCard: View {
    let emotion: Emotion
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: emotion.systemImage)
                        .font(.title3)
                        .foregroundStyle(Theme.coral)
                    Spacer()
                    Image(systemName: "play.fill")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 28, height: 28)
                        .background(Theme.coral, in: Circle())
                }
                Text(emotion.name)
                    .font(.headline)
                    .foregroundStyle(Theme.ink)
                Text(emotion.cue)
                    .font(.caption)
                    .foregroundStyle(Theme.mutedInk)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
            .appCard(padding: 14)
        }
        .buttonStyle(.plain)
    }
}
