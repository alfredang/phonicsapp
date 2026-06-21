import SwiftUI

struct RulesView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("When phonics breaks")
                            .font(.largeTitle.bold())
                            .foregroundStyle(Theme.ink)
                        Text("English is full of exceptions. These rules cover the irregular spellings that don't sound out the way you'd expect — hear each one to lock it in.")
                            .font(.subheadline)
                            .foregroundStyle(Theme.mutedInk)
                    }

                    ForEach(ContentLibrary.exceptionRules) { rule in
                        NavigationLink(value: rule) {
                            NavTile(
                                title: rule.title,
                                subtitle: rule.summary,
                                systemImage: rule.systemImage,
                                tint: Theme.highlight
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
            }
            .screenBackground()
            .navigationTitle("Rules")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: ExceptionRule.self) { RuleDetailView(rule: $0) }
            .toolbar { ToolbarItem(placement: .topBarTrailing) { AccentMenu() } }
        }
    }
}

struct RuleDetailView: View {
    let rule: ExceptionRule
    @EnvironmentObject private var settings: AppSettings
    @EnvironmentObject private var speech: SpeechManager

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Image(systemName: rule.systemImage)
                        .font(.title)
                        .foregroundStyle(.white)
                        .frame(width: 52, height: 52)
                        .background(Theme.highlight, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    Text(rule.explanation)
                        .font(.body)
                        .foregroundStyle(Theme.ink)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .appCard()

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "Examples", systemImage: "list.bullet", tint: Theme.highlight)
                    ForEach(rule.examples) { ex in
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(ex.word)
                                    .font(.title3.weight(.semibold))
                                    .foregroundStyle(Theme.ink)
                                Text(ex.note)
                                    .font(.footnote)
                                    .foregroundStyle(Theme.mutedInk)
                            }
                            Spacer(minLength: 8)
                            SpeakButton(isActive: speech.nowPlaying == ex.word, tint: Theme.highlight) {
                                speech.speakWord(ex.word, accent: settings.accent)
                            }
                        }
                        if ex.id != rule.examples.last?.id { Divider() }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .appCard()
            }
            .padding(20)
        }
        .screenBackground()
        .navigationTitle(rule.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .topBarTrailing) { AccentMenu() } }
    }
}
