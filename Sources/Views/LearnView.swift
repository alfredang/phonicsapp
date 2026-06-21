import SwiftUI

struct LearnView: View {
    @EnvironmentObject private var settings: AppSettings
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    header

                    ForEach(PhonicsCategory.allCases) { category in
                        NavigationLink(value: category) {
                            NavTile(
                                title: category.rawValue,
                                subtitle: category.blurb,
                                systemImage: category.systemImage,
                                tint: Theme.accent(for: category)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
            }
            .screenBackground()
            .navigationTitle("Learn")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: PhonicsCategory.self) { category in
                PhonemeListView(category: category)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { AccentMenu() }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showSettings = true } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showSettings) { SettingsView() }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Sound it out")
                .font(.largeTitle.bold())
                .foregroundStyle(Theme.ink)
            Text("Tap any sound to hear it in your chosen \(settings.accent.rawValue) accent. Work through each group at your own pace.")
                .font(.subheadline)
                .foregroundStyle(Theme.mutedInk)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 4)
    }
}

// MARK: - Phoneme list for one category

struct PhonemeListView: View {
    let category: PhonicsCategory
    @EnvironmentObject private var settings: AppSettings
    @EnvironmentObject private var speech: SpeechManager

    private var phonemes: [Phoneme] { ContentLibrary.phonemes(in: category) }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                Text(category.blurb)
                    .font(.subheadline)
                    .foregroundStyle(Theme.mutedInk)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 4)

                ForEach(phonemes) { phoneme in
                    NavigationLink(value: phoneme) {
                        PhonemeRow(phoneme: phoneme)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
        }
        .screenBackground()
        .navigationTitle(category.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Phoneme.self) { PhonemeDetailView(phoneme: $0) }
        .toolbar { ToolbarItem(placement: .topBarTrailing) { AccentMenu() } }
    }
}

struct PhonemeRow: View {
    let phoneme: Phoneme
    @EnvironmentObject private var settings: AppSettings
    @EnvironmentObject private var speech: SpeechManager

    private var tint: Color { Theme.accent(for: phoneme.category) }

    var body: some View {
        HStack(spacing: 14) {
            Text(phoneme.grapheme)
                .font(.system(.title2, design: .rounded).weight(.bold))
                .foregroundStyle(tint)
                .frame(width: 56, height: 56)
                .background(tint.opacity(0.12), in: RoundedRectangle(cornerRadius: 14, style: .continuous))

            VStack(alignment: .leading, spacing: 3) {
                Text(phoneme.ipa)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.ink)
                Text(phoneme.exampleWords.joined(separator: " · "))
                    .font(.footnote)
                    .foregroundStyle(Theme.mutedInk)
                    .lineLimit(1)
            }
            Spacer(minLength: 4)
            SpeakButton(isActive: speech.nowPlaying == phoneme.soundKey, tint: tint) {
                speech.speakPhoneme(phoneme, accent: settings.accent)
            }
        }
        .appCard()
    }
}
