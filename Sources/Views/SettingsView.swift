import SwiftUI

/// A compact accent toggle used in navigation toolbars across the app.
struct AccentMenu: View {
    @EnvironmentObject private var settings: AppSettings

    var body: some View {
        Menu {
            Picker("Accent", selection: Binding(
                get: { settings.accent },
                set: { settings.accent = $0 }
            )) {
                ForEach(Accent.allCases) { accent in
                    Text("\(accent.flag)  \(accent.rawValue)").tag(accent)
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(settings.accent.flag)
                Text(settings.accent == .british ? "UK" : "US")
                    .font(.subheadline.weight(.semibold))
            }
            .foregroundStyle(Theme.primary)
        }
        .accessibilityLabel("Choose accent, currently \(settings.accent.rawValue)")
    }
}

struct SettingsView: View {
    @EnvironmentObject private var settings: AppSettings
    @EnvironmentObject private var speech: SpeechManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Accent") {
                    ForEach(Accent.allCases) { accent in
                        Button {
                            settings.accent = accent
                            speech.speak("Hello, this is the \(accent.rawValue) voice.",
                                         accent: accent)
                        } label: {
                            HStack {
                                Text(accent.flag).font(.title2)
                                VStack(alignment: .leading) {
                                    Text(accent.rawValue).foregroundStyle(Theme.ink)
                                    Text(accent.subtitle)
                                        .font(.caption)
                                        .foregroundStyle(Theme.mutedInk)
                                }
                                Spacer()
                                if settings.accent == accent {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Theme.primary)
                                }
                            }
                        }
                    }
                }

                Section("Speaking speed") {
                    VStack(alignment: .leading) {
                        Slider(value: $settings.speechRate, in: 0.30...0.60, step: 0.02) {
                            Text("Speed")
                        } minimumValueLabel: {
                            Image(systemName: "tortoise")
                        } maximumValueLabel: {
                            Image(systemName: "hare")
                        }
                        Button("Test voice") {
                            speech.speak("The quick brown fox jumps over the lazy dog.",
                                         accent: settings.accent, rate: settings.speechRate)
                        }
                        .font(.subheadline.weight(.semibold))
                        .tint(Theme.primary)
                    }
                }

                Section {
                    Text("Voice-over uses your device's built-in \(settings.accent.subtitle) voice. For the highest quality, download an enhanced voice in iOS Settings › Accessibility › Spoken Content › Voices.")
                        .font(.footnote)
                        .foregroundStyle(Theme.mutedInk)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
