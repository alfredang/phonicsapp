import SwiftUI

struct PracticeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Practice out loud")
                            .font(.largeTitle.bold())
                            .foregroundStyle(Theme.ink)
                        Text("Listen first, then read each line aloud and compare. A few minutes a day builds clear, confident speech.")
                            .font(.subheadline)
                            .foregroundStyle(Theme.mutedInk)
                    }

                    // Intonation & emotion gets pride of place.
                    NavigationLink(value: PracticeRoute.emotion) {
                        NavTile(
                            title: "Intonation & Emotion",
                            subtitle: "Hear how one sentence changes with feeling — happy, sad, angry, a question, and more.",
                            systemImage: "theatermasks.fill",
                            tint: Theme.coral
                        )
                    }
                    .buttonStyle(.plain)

                    ForEach(PracticeKind.allCases) { kind in
                        NavigationLink(value: PracticeRoute.kind(kind)) {
                            NavTile(
                                title: kind.rawValue,
                                subtitle: kind.blurb,
                                systemImage: kind.systemImage,
                                tint: Theme.secondary
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
            }
            .screenBackground()
            .navigationTitle("Practice")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: PracticeRoute.self) { route in
                switch route {
                case .emotion:          EmotionPracticeView()
                case .kind(let kind):
                    if kind == .minimalPairs { MinimalPairsView() }
                    else { PracticeLinesView(kind: kind) }
                }
            }
            .toolbar { ToolbarItem(placement: .topBarTrailing) { AccentMenu() } }
        }
    }
}

enum PracticeRoute: Hashable {
    case emotion
    case kind(PracticeKind)
}

// MARK: - Line-based drills (tongue twisters, short messages, sentences)

struct PracticeLinesView: View {
    let kind: PracticeKind
    @EnvironmentObject private var settings: AppSettings
    @EnvironmentObject private var speech: SpeechManager

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text(kind.blurb)
                    .font(.subheadline)
                    .foregroundStyle(Theme.mutedInk)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ForEach(ContentLibrary.lines(for: kind)) { line in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(line.text)
                            .font(.title3.weight(.medium))
                            .foregroundStyle(Theme.ink)
                            .fixedSize(horizontal: false, vertical: true)
                        HStack {
                            Pill(text: line.focus, color: Theme.secondary.opacity(0.12), textColor: Theme.secondary)
                            Spacer()
                            SpeakButton(isActive: speech.nowPlaying == line.text, tint: Theme.secondary) {
                                speech.speak(line.text, accent: settings.accent, rate: settings.speechRate)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .appCard()
                }
            }
            .padding(20)
        }
        .screenBackground()
        .navigationTitle(kind.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .topBarTrailing) { AccentMenu() } }
    }
}

// MARK: - Minimal pairs

struct MinimalPairsView: View {
    @EnvironmentObject private var settings: AppSettings
    @EnvironmentObject private var speech: SpeechManager

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text(PracticeKind.minimalPairs.blurb)
                    .font(.subheadline)
                    .foregroundStyle(Theme.mutedInk)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ForEach(ContentLibrary.minimalPairs) { pair in
                    VStack(spacing: 10) {
                        HStack(spacing: 12) {
                            wordTile(pair.first)
                            Image(systemName: "arrow.left.arrow.right")
                                .foregroundStyle(Theme.mutedInk)
                            wordTile(pair.second)
                        }
                        Text(pair.contrast)
                            .font(.footnote)
                            .foregroundStyle(Theme.mutedInk)
                    }
                    .frame(maxWidth: .infinity)
                    .appCard()
                }
            }
            .padding(20)
        }
        .screenBackground()
        .navigationTitle("Minimal Pairs")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .topBarTrailing) { AccentMenu() } }
    }

    private func wordTile(_ word: String) -> some View {
        Button {
            speech.speakWord(word, accent: settings.accent)
        } label: {
            HStack(spacing: 8) {
                Text(word)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Theme.ink)
                Image(systemName: speech.nowPlaying == word ? "speaker.wave.2.fill" : "speaker.wave.1")
                    .foregroundStyle(Theme.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Theme.chip, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
