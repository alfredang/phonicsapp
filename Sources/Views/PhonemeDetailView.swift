import SwiftUI

struct PhonemeDetailView: View {
    let phoneme: Phoneme
    @EnvironmentObject private var settings: AppSettings
    @EnvironmentObject private var speech: SpeechManager

    private var tint: Color { Theme.accent(for: phoneme.category) }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Hero
                VStack(spacing: 12) {
                    Text(phoneme.grapheme)
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .foregroundStyle(tint)
                    Text(phoneme.ipa)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(Theme.mutedInk)
                    Pill(text: phoneme.category.rawValue, color: tint.opacity(0.14), textColor: tint)

                    Button {
                        speech.speakSound(ipa: phoneme.ipa, accent: settings.accent, key: phoneme.soundKey)
                    } label: {
                        Label("Hear the sound", systemImage: "speaker.wave.2.fill")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 22).padding(.vertical, 12)
                            .background(tint, in: Capsule())
                    }
                    .padding(.top, 4)
                }
                .frame(maxWidth: .infinity)
                .appCard(padding: 24)

                // How to say it
                VStack(alignment: .leading, spacing: 8) {
                    SectionHeader(title: "How to say it", systemImage: "mouth", tint: tint)
                    Text(phoneme.soundDescription)
                        .font(.body)
                        .foregroundStyle(Theme.ink)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .appCard()

                // Example words
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "Example words", systemImage: "text.word.spacing", tint: tint)
                    ForEach(phoneme.exampleWords, id: \.self) { word in
                        HStack {
                            Text(word)
                                .font(.title3.weight(.medium))
                                .foregroundStyle(Theme.ink)
                            Spacer()
                            SpeakButton(isActive: speech.nowPlaying == word, tint: tint) {
                                speech.speak(word, accent: settings.accent, rate: settings.speechRate)
                            }
                        }
                        if word != phoneme.exampleWords.last { Divider() }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .appCard()
            }
            .padding(20)
        }
        .screenBackground()
        .navigationTitle(phoneme.grapheme)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .topBarTrailing) { AccentMenu() } }
    }
}
