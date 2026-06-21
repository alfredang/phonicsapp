import SwiftUI

struct FeedbackView: View {
    private let whatsAppNumber = "6588666375"     // +65 8866 6375, no "+"/spaces
    @State private var title = ""
    @State private var message = ""

    private var canSend: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("We'd love your feedback")
                        .font(.title2.bold())
                        .foregroundStyle(Theme.ink)
                    Text("Found a word that sounds off? Have an idea for a new lesson? Send us a note and it'll open in WhatsApp.")
                        .font(.subheadline)
                        .foregroundStyle(Theme.mutedInk)

                    VStack(alignment: .leading, spacing: 14) {
                        Text("TITLE")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Theme.mutedInk)
                        TextField("Short summary", text: $title)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .background(Theme.chip, in: RoundedRectangle(cornerRadius: 12, style: .continuous))

                        Text("MESSAGE")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Theme.mutedInk)
                        ZStack(alignment: .topLeading) {
                            if message.isEmpty {
                                Text("Your message…")
                                    .foregroundStyle(Theme.mutedInk.opacity(0.7))
                                    .padding(.top, 8).padding(.leading, 5)
                            }
                            TextEditor(text: $message)
                                .scrollContentBackground(.hidden)
                                .frame(minHeight: 150)
                        }
                        .padding(8)
                        .background(Theme.chip, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .appCard()

                    Button(action: send) {
                        Label("Send via WhatsApp", systemImage: "paperplane.fill")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(canSend ? Theme.primary : Theme.mutedInk.opacity(0.4),
                                        in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .disabled(!canSend)
                }
                .padding(20)
            }
            .screenBackground()
            .navigationTitle("Feedback")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func send() {
        var body = ""
        let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let m = message.trimmingCharacters(in: .whitespacesAndNewlines)
        if !t.isEmpty { body += "*\(t)*\n" }
        body += m

        var comps = URLComponents()
        comps.scheme = "https"
        comps.host = "wa.me"
        comps.path = "/\(whatsAppNumber)"
        comps.queryItems = [URLQueryItem(name: "text", value: body)]
        if let url = comps.url { UIApplication.shared.open(url) }
    }
}
