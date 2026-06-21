import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            LearnView()
                .tabItem { Label("Learn", systemImage: "book.fill") }
            PracticeView()
                .tabItem { Label("Practice", systemImage: "mic.fill") }
            RulesView()
                .tabItem { Label("Rules", systemImage: "exclamationmark.triangle.fill") }
            FeedbackView()
                .tabItem { Label("Feedback", systemImage: "bubble.left.and.bubble.right.fill") }
            AboutView()
                .tabItem { Label("About", systemImage: "info.circle.fill") }
        }
        .tint(Theme.primary)
    }
}

#Preview {
    MainTabView()
        .environmentObject(SpeechManager())
        .environmentObject(AppSettings())
}
