import SwiftUI

struct AboutView: View {
    private let developerURL = URL(string: "https://www.tertiaryinfotech.com")!
    private let referenceURL = URL(string: "https://en.wikipedia.org/wiki/Phonics")!

    private var versionString: String {
        let i = Bundle.main.infoDictionary
        let s = i?["CFBundleShortVersionString"] as? String ?? "1.0"
        let b = i?["CFBundleVersion"] as? String ?? "1"
        return "\(s) (\(b))"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    // App card
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 12) {
                            Image(systemName: "waveform.and.mic")
                                .font(.title)
                                .foregroundStyle(.white)
                                .frame(width: 52, height: 52)
                                .background(Theme.primary, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                            Text("Phonics")
                                .font(.title2.bold())
                                .foregroundStyle(Theme.ink)
                        }
                        Text("A pronunciation and phonics trainer for adults. Learn every English sound, master the irregular spelling rules, and practise intonation that expresses real emotion — all with British or American voice-over.")
                            .font(.subheadline)
                            .foregroundStyle(Theme.mutedInk)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .appCard()

                    // Developer card
                    VStack(alignment: .leading, spacing: 0) {
                        Text("DEVELOPER")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Theme.mutedInk)
                            .padding(.bottom, 8)
                        Label("Tertiary Infotech Academy Pte Ltd", systemImage: "building.2.fill")
                            .foregroundStyle(Theme.ink)
                            .padding(.vertical, 12)
                        Divider()
                        Link(destination: developerURL) {
                            Label("tertiaryinfotech.com", systemImage: "globe")
                                .foregroundStyle(Theme.secondary)
                        }
                        .padding(.vertical, 12)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .appCard()

                    // Reference / data source card
                    VStack(alignment: .leading, spacing: 0) {
                        Text("LEARNING REFERENCE")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Theme.mutedInk)
                            .padding(.bottom, 8)
                        Text("Curriculum structure follows standard synthetic-phonics practice.")
                            .font(.footnote)
                            .foregroundStyle(Theme.mutedInk)
                            .padding(.vertical, 8)
                        Divider()
                        Link(destination: referenceURL) {
                            Label("Phonics — Wikipedia", systemImage: "book")
                                .foregroundStyle(Theme.secondary)
                        }
                        .padding(.vertical, 12)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .appCard()

                    // Voice-over note
                    VStack(alignment: .leading, spacing: 6) {
                        Text("VOICE-OVER")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Theme.mutedInk)
                        Text("Speech uses Apple's on-device en-GB / en-US voices and works offline. No account, no tracking.")
                            .font(.footnote)
                            .foregroundStyle(Theme.mutedInk)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .appCard()

                    // Version
                    HStack {
                        Text("Version").foregroundStyle(Theme.ink)
                        Spacer()
                        Text(versionString).foregroundStyle(Theme.mutedInk)
                    }
                    .appCard()
                }
                .padding(20)
            }
            .screenBackground()
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
