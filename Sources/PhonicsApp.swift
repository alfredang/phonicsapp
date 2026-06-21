import SwiftUI

@main
struct PhonicsApp: App {
    @StateObject private var speech = SpeechManager()
    @StateObject private var settings = AppSettings()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(speech)
                .environmentObject(settings)
                .tint(Theme.primary)
        }
    }
}
