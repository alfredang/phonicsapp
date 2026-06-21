import SwiftUI

/// A circular play button that demonstrates a sound / line via the speech engine.
struct SpeakButton: View {
    let isActive: Bool
    var tint: Color = Theme.primary
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isActive ? "speaker.wave.3.fill" : "play.fill")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(tint, in: Circle())
                .symbolEffect(.bounce, value: isActive)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isActive ? "Stop" : "Play sound")
    }
}

/// A small pill label.
struct Pill: View {
    let text: String
    var color: Color = Theme.chip
    var textColor: Color = Theme.mutedInk

    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundStyle(textColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color, in: Capsule())
    }
}

/// Section header with an SF Symbol.
struct SectionHeader: View {
    let title: String
    let systemImage: String
    var tint: Color = Theme.primary

    var body: some View {
        Label(title, systemImage: systemImage)
            .font(.headline)
            .foregroundStyle(Theme.ink)
            .labelStyle(.titleAndIcon)
            .padding(.bottom, 2)
    }
}

/// A large tappable category / navigation tile.
struct NavTile: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let tint: Color

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(tint, in: RoundedRectangle(cornerRadius: 14, style: .continuous))

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Theme.ink)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Theme.mutedInk)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 4)
            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Theme.mutedInk.opacity(0.6))
        }
        .appCard()
    }
}
