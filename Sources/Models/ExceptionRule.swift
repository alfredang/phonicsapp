import Foundation

/// An irregular-spelling / exception rule, with worked examples the learner can hear.
struct ExceptionRule: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let summary: String
    let explanation: String
    let examples: [RuleExample]
    let systemImage: String
}

struct RuleExample: Identifiable, Hashable {
    let id = UUID()
    let word: String
    let note: String        // why it's irregular / how it's said
}
