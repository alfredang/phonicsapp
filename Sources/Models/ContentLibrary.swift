import Foundation

/// All static learning content. Curriculum follows standard synthetic-phonics
/// structure (see en.wikipedia.org/wiki/Phonics): phonemes grouped by type,
/// exception/irregular rules, and graded practice material.
enum ContentLibrary {

    // MARK: - Phonemes

    static let phonemes: [Phoneme] = consonants + shortVowels + longVowels
        + digraphs + blends + vowelTeams + diphthongs + rControlled + softSounds

    static func phonemes(in category: PhonicsCategory) -> [Phoneme] {
        phonemes.filter { $0.category == category }
    }

    static let consonants: [Phoneme] = [
        .init(grapheme: "b", ipa: "/b/", soundDescription: "Lips together, then a voiced pop.", exampleWords: ["bat", "rabbit", "tub"], category: .consonant),
        .init(grapheme: "k", ipa: "/k/", soundDescription: "Back of the tongue lifts, short hard click.", exampleWords: ["cat", "kite", "duck"], category: .consonant),
        .init(grapheme: "d", ipa: "/d/", soundDescription: "Tongue taps behind the teeth, voiced.", exampleWords: ["dog", "ladder", "bed"], category: .consonant),
        .init(grapheme: "f", ipa: "/f/", soundDescription: "Top teeth on bottom lip, blow air.", exampleWords: ["fish", "coffee", "leaf"], category: .consonant),
        .init(grapheme: "g", ipa: "/ɡ/", soundDescription: "Hard throat sound, voiced.", exampleWords: ["goat", "wagon", "bag"], category: .consonant),
        .init(grapheme: "h", ipa: "/h/", soundDescription: "A soft breath of air.", exampleWords: ["hat", "ahead", "hop"], category: .consonant),
        .init(grapheme: "j", ipa: "/dʒ/", soundDescription: "Tongue to roof, voiced jump.", exampleWords: ["jam", "jet", "jump"], category: .consonant),
        .init(grapheme: "l", ipa: "/l/", soundDescription: "Tongue tip up, sides open, voiced.", exampleWords: ["leg", "yellow", "ball"], category: .consonant),
        .init(grapheme: "m", ipa: "/m/", soundDescription: "Lips closed, hum through the nose.", exampleWords: ["map", "hammer", "drum"], category: .consonant),
        .init(grapheme: "n", ipa: "/n/", soundDescription: "Tongue up, hum through the nose.", exampleWords: ["net", "dinner", "sun"], category: .consonant),
        .init(grapheme: "p", ipa: "/p/", soundDescription: "Lips together, then a quiet pop.", exampleWords: ["pig", "apple", "cup"], category: .consonant),
        .init(grapheme: "r", ipa: "/r/", soundDescription: "Tongue curls back, voiced growl.", exampleWords: ["red", "carrot", "car"], category: .consonant),
        .init(grapheme: "s", ipa: "/s/", soundDescription: "Tongue near teeth, hiss like a snake.", exampleWords: ["sun", "messy", "bus"], category: .consonant),
        .init(grapheme: "t", ipa: "/t/", soundDescription: "Tongue taps behind teeth, crisp.", exampleWords: ["top", "butter", "hat"], category: .consonant),
        .init(grapheme: "v", ipa: "/v/", soundDescription: "Teeth on lip like /f/, but voiced.", exampleWords: ["van", "river", "five"], category: .consonant),
        .init(grapheme: "w", ipa: "/w/", soundDescription: "Round the lips, then glide.", exampleWords: ["win", "away", "we"], category: .consonant),
        .init(grapheme: "y", ipa: "/j/", soundDescription: "Tongue high, glides into the vowel.", exampleWords: ["yes", "yellow", "yarn"], category: .consonant),
        .init(grapheme: "z", ipa: "/z/", soundDescription: "Like /s/ but with voice buzzing.", exampleWords: ["zip", "buzzer", "zoo"], category: .consonant)
    ]

    static let shortVowels: [Phoneme] = [
        .init(grapheme: "a", ipa: "/æ/", soundDescription: "Open mouth — 'a' as in apple.", exampleWords: ["apple", "cat", "hat"], category: .shortVowel),
        .init(grapheme: "e", ipa: "/ɛ/", soundDescription: "Relaxed — 'e' as in egg.", exampleWords: ["egg", "bed", "pen"], category: .shortVowel),
        .init(grapheme: "i", ipa: "/ɪ/", soundDescription: "Short and crisp — 'i' as in igloo.", exampleWords: ["igloo", "sit", "pin"], category: .shortVowel),
        .init(grapheme: "o", ipa: "/ɒ/", soundDescription: "Round mouth — 'o' as in octopus.", exampleWords: ["octopus", "dog", "pot"], category: .shortVowel),
        .init(grapheme: "u", ipa: "/ʌ/", soundDescription: "Relaxed grunt — 'u' as in umbrella.", exampleWords: ["umbrella", "cup", "bus"], category: .shortVowel)
    ]

    static let longVowels: [Phoneme] = [
        .init(grapheme: "a_e", ipa: "/eɪ/", soundDescription: "Magic-e makes 'a' say its name.", exampleWords: ["cake", "name", "gate"], category: .longVowel),
        .init(grapheme: "e_e", ipa: "/iː/", soundDescription: "Long e — 'ee' sound.", exampleWords: ["these", "theme", "Pete"], category: .longVowel),
        .init(grapheme: "i_e", ipa: "/aɪ/", soundDescription: "Magic-e makes 'i' say its name.", exampleWords: ["bike", "time", "kite"], category: .longVowel),
        .init(grapheme: "o_e", ipa: "/oʊ/", soundDescription: "Magic-e makes 'o' say its name.", exampleWords: ["home", "rose", "note"], category: .longVowel),
        .init(grapheme: "u_e", ipa: "/juː/", soundDescription: "Magic-e makes 'u' say its name.", exampleWords: ["cube", "mute", "tube"], category: .longVowel)
    ]

    static let digraphs: [Phoneme] = [
        .init(grapheme: "sh", ipa: "/ʃ/", soundDescription: "Quiet 'shhh' — finger to lips.", exampleWords: ["ship", "fish", "shop"], category: .digraph),
        .init(grapheme: "ch", ipa: "/tʃ/", soundDescription: "Like a sneezing train — 'ch-ch'.", exampleWords: ["chip", "lunch", "chair"], category: .digraph),
        .init(grapheme: "th", ipa: "/θ/", soundDescription: "Tongue between teeth, unvoiced.", exampleWords: ["thin", "bath", "thumb"], category: .digraph),
        .init(grapheme: "th", ipa: "/ð/", soundDescription: "Tongue between teeth, voiced.", exampleWords: ["this", "mother", "them"], category: .digraph),
        .init(grapheme: "wh", ipa: "/w/", soundDescription: "Breathy 'w' — as in question words.", exampleWords: ["when", "wheel", "whale"], category: .digraph),
        .init(grapheme: "ph", ipa: "/f/", soundDescription: "'ph' makes the /f/ sound.", exampleWords: ["phone", "graph", "dolphin"], category: .digraph),
        .init(grapheme: "ck", ipa: "/k/", soundDescription: "Hard /k/ at the end of short words.", exampleWords: ["duck", "sock", "kick"], category: .digraph),
        .init(grapheme: "ng", ipa: "/ŋ/", soundDescription: "Hum through the nose, back of tongue up.", exampleWords: ["ring", "song", "long"], category: .digraph)
    ]

    static let blends: [Phoneme] = [
        .init(grapheme: "bl", ipa: "/bl/", soundDescription: "Blend /b/ and /l/ smoothly.", exampleWords: ["blue", "black", "blink"], category: .blend),
        .init(grapheme: "cl", ipa: "/kl/", soundDescription: "Blend /k/ and /l/.", exampleWords: ["clap", "clock", "cloud"], category: .blend),
        .init(grapheme: "fl", ipa: "/fl/", soundDescription: "Blend /f/ and /l/.", exampleWords: ["flag", "flip", "fly"], category: .blend),
        .init(grapheme: "gr", ipa: "/ɡr/", soundDescription: "Blend /g/ and /r/.", exampleWords: ["green", "grab", "grow"], category: .blend),
        .init(grapheme: "tr", ipa: "/tr/", soundDescription: "Blend /t/ and /r/.", exampleWords: ["tree", "train", "trip"], category: .blend),
        .init(grapheme: "st", ipa: "/st/", soundDescription: "Blend /s/ and /t/.", exampleWords: ["stop", "star", "best"], category: .blend),
        .init(grapheme: "sp", ipa: "/sp/", soundDescription: "Blend /s/ and /p/.", exampleWords: ["spin", "spot", "wasp"], category: .blend),
        .init(grapheme: "sn", ipa: "/sn/", soundDescription: "Blend /s/ and /n/.", exampleWords: ["snap", "snow", "snail"], category: .blend),
        .init(grapheme: "str", ipa: "/str/", soundDescription: "Three-sound blend /s/+/t/+/r/.", exampleWords: ["street", "strong", "string"], category: .blend)
    ]

    static let vowelTeams: [Phoneme] = [
        .init(grapheme: "ai", ipa: "/eɪ/", soundDescription: "Two vowels, one long-a sound.", exampleWords: ["rain", "train", "paint"], category: .vowelTeam),
        .init(grapheme: "ay", ipa: "/eɪ/", soundDescription: "Long-a, usually at word ends.", exampleWords: ["play", "day", "stay"], category: .vowelTeam),
        .init(grapheme: "ee", ipa: "/iː/", soundDescription: "Long-e — 'see' sound.", exampleWords: ["see", "tree", "green"], category: .vowelTeam),
        .init(grapheme: "ea", ipa: "/iː/", soundDescription: "Often long-e (but see exceptions!).", exampleWords: ["eat", "team", "leaf"], category: .vowelTeam),
        .init(grapheme: "oa", ipa: "/oʊ/", soundDescription: "Long-o — 'boat' sound.", exampleWords: ["boat", "road", "coat"], category: .vowelTeam),
        .init(grapheme: "ie", ipa: "/aɪ/", soundDescription: "Long-i — 'pie' sound.", exampleWords: ["pie", "tie", "lie"], category: .vowelTeam),
        .init(grapheme: "igh", ipa: "/aɪ/", soundDescription: "Three letters, one long-i sound.", exampleWords: ["light", "night", "high"], category: .vowelTeam)
    ]

    static let diphthongs: [Phoneme] = [
        .init(grapheme: "oi", ipa: "/ɔɪ/", soundDescription: "Glide from 'o' to 'ee'.", exampleWords: ["coin", "oil", "boil"], category: .diphthong),
        .init(grapheme: "oy", ipa: "/ɔɪ/", soundDescription: "Same as 'oi', usually at word ends.", exampleWords: ["boy", "toy", "joy"], category: .diphthong),
        .init(grapheme: "ou", ipa: "/aʊ/", soundDescription: "Glide 'ah' to 'oo' — 'ouch!'.", exampleWords: ["out", "house", "cloud"], category: .diphthong),
        .init(grapheme: "ow", ipa: "/aʊ/", soundDescription: "Same as 'ou' — 'cow' sound.", exampleWords: ["cow", "now", "down"], category: .diphthong),
        .init(grapheme: "au", ipa: "/ɔː/", soundDescription: "Open 'aw' sound.", exampleWords: ["sauce", "haul", "August"], category: .diphthong),
        .init(grapheme: "aw", ipa: "/ɔː/", soundDescription: "Same 'aw' sound, often at word ends.", exampleWords: ["saw", "paw", "draw"], category: .diphthong)
    ]

    static let rControlled: [Phoneme] = [
        .init(grapheme: "ar", ipa: "/ɑːr/", soundDescription: "'ar' as in car — the bossy r.", exampleWords: ["car", "star", "farm"], category: .rControlled),
        .init(grapheme: "or", ipa: "/ɔːr/", soundDescription: "'or' as in fork.", exampleWords: ["fork", "born", "storm"], category: .rControlled),
        .init(grapheme: "er", ipa: "/ɜːr/", soundDescription: "'er' as in her — schwa-r.", exampleWords: ["her", "fern", "term"], category: .rControlled),
        .init(grapheme: "ir", ipa: "/ɜːr/", soundDescription: "Same 'er' sound, spelt 'ir'.", exampleWords: ["bird", "girl", "shirt"], category: .rControlled),
        .init(grapheme: "ur", ipa: "/ɜːr/", soundDescription: "Same 'er' sound, spelt 'ur'.", exampleWords: ["turn", "hurt", "burn"], category: .rControlled)
    ]

    static let softSounds: [Phoneme] = [
        .init(grapheme: "c → /s/", ipa: "/s/", soundDescription: "Soft c before e, i, or y.", exampleWords: ["city", "cent", "ice"], category: .softSound),
        .init(grapheme: "g → /dʒ/", ipa: "/dʒ/", soundDescription: "Soft g before e, i, or y.", exampleWords: ["giant", "gem", "cage"], category: .softSound)
    ]

    // MARK: - Exception / irregular rules

    static let exceptionRules: [ExceptionRule] = [
        .init(title: "Silent Letters",
              summary: "Letters that are written but not pronounced.",
              explanation: "Many English words carry letters that have gone silent over centuries. The spelling preserves a word's history even though the sound has dropped. Learn the common silent-letter patterns rather than sounding every letter out.",
              examples: [
                .init(word: "knee", note: "Silent k before n — say 'nee'."),
                .init(word: "write", note: "Silent w before r — say 'rite'."),
                .init(word: "lamb", note: "Silent b after m — say 'lam'."),
                .init(word: "calf", note: "Silent l — say 'caf'."),
                .init(word: "listen", note: "Silent t — say 'lissen'."),
                .init(word: "hour", note: "Silent h — say 'our'.")
              ], systemImage: "speaker.slash"),

        .init(title: "The Many Sounds of 'ough'",
              summary: "One spelling, many pronunciations.",
              explanation: "'ough' is famous for being read several different ways. There is no single rule — these are best memorised as whole words.",
              examples: [
                .init(word: "though", note: "Sounds like 'oh'."),
                .init(word: "through", note: "Sounds like 'oo'."),
                .init(word: "rough", note: "Sounds like 'uff'."),
                .init(word: "cough", note: "Sounds like 'off'."),
                .init(word: "bought", note: "Sounds like 'awt'."),
                .init(word: "plough", note: "Sounds like 'ow'.")
              ], systemImage: "questionmark.diamond"),

        .init(title: "Soft C and Soft G",
              summary: "c and g soften before e, i, or y.",
              explanation: "Before the vowels e, i, or y, the letter c usually says /s/ and g usually says /j/. Before a, o, u (or a consonant) they keep their hard sounds /k/ and /g/. A handful of words break even this rule.",
              examples: [
                .init(word: "city", note: "Soft c → /s/ before i."),
                .init(word: "cat", note: "Hard c → /k/ before a."),
                .init(word: "giant", note: "Soft g → /j/ before i."),
                .init(word: "got", note: "Hard g → /g/ before o."),
                .init(word: "girl", note: "Exception — hard g before i."),
                .init(word: "get", note: "Exception — hard g before e.")
              ], systemImage: "arrow.triangle.branch"),

        .init(title: "'i' before 'e', except after 'c'",
              summary: "A spelling guide with notable exceptions.",
              explanation: "The classic rhyme: 'i before e, except after c, or when sounding like \"ay\" as in neighbour and weigh.' It helps often — but English keeps a list of stubborn exceptions.",
              examples: [
                .init(word: "believe", note: "i before e — follows the rule."),
                .init(word: "receive", note: "e before i after c — follows the rule."),
                .init(word: "weigh", note: "'ay' sound — e before i."),
                .init(word: "weird", note: "Exception — e before i, no c."),
                .init(word: "science", note: "Exception — i before e after c."),
                .init(word: "their", note: "Exception — common sight word.")
              ], systemImage: "textformat.abc"),

        .init(title: "Tricky Sight Words",
              summary: "High-frequency words that defy phonics.",
              explanation: "Some of the most common words in English cannot be sounded out reliably. Because we read them so often, it is most efficient to recognise them instantly by sight.",
              examples: [
                .init(word: "the", note: "Schwa vowel — 'thuh'."),
                .init(word: "said", note: "Reads as 'sed', not 'say-id'."),
                .init(word: "was", note: "Reads as 'wuz'."),
                .init(word: "one", note: "Reads as 'wun'."),
                .init(word: "two", note: "Silent w — 'too'."),
                .init(word: "of", note: "f reads as /v/ — 'ov'.")
              ], systemImage: "eye"),

        .init(title: "The Schwa — the lazy vowel",
              summary: "Unstressed vowels relax to 'uh'.",
              explanation: "The schwa /ə/ is the most common vowel sound in English. In unstressed syllables, almost any vowel can collapse into a quick, neutral 'uh'. It is why spelling and sound drift apart in longer words.",
              examples: [
                .init(word: "banana", note: "The a's reduce to 'buh-NA-nuh'."),
                .init(word: "pencil", note: "The i reduces — 'pen-suhl'."),
                .init(word: "about", note: "The first a is a schwa — 'uh-bout'."),
                .init(word: "problem", note: "The e reduces — 'prob-luhm'."),
                .init(word: "sofa", note: "The final a is a schwa — 'so-fuh'.")
              ], systemImage: "waveform.path.ecg"),

        .init(title: "Doubling & Drop-the-e",
              summary: "How endings change a word's spelling.",
              explanation: "When adding endings like -ing or -ed: double the final consonant after a short stressed vowel (run → running); and drop a silent e before a vowel ending (make → making). These keep the vowel sound consistent.",
              examples: [
                .init(word: "running", note: "Double n — keeps the short u."),
                .init(word: "hoping", note: "Drop e — keeps the long o."),
                .init(word: "hopping", note: "Double p — keeps the short o."),
                .init(word: "making", note: "Drop e before -ing."),
                .init(word: "stopped", note: "Double p before -ed.")
              ], systemImage: "plus.forwardslash.minus")
    ]

    // MARK: - Practice content

    static let minimalPairs: [MinimalPair] = [
        .init(first: "ship", second: "sheep", contrast: "short i /ɪ/ vs long e /iː/"),
        .init(first: "bit", second: "beat", contrast: "short i /ɪ/ vs long e /iː/"),
        .init(first: "pen", second: "pan", contrast: "short e /ɛ/ vs short a /æ/"),
        .init(first: "cot", second: "caught", contrast: "short o /ɒ/ vs 'aw' /ɔː/"),
        .init(first: "thin", second: "this", contrast: "unvoiced /θ/ vs voiced /ð/"),
        .init(first: "vine", second: "fine", contrast: "voiced /v/ vs unvoiced /f/"),
        .init(first: "rice", second: "rise", contrast: "unvoiced /s/ vs voiced /z/"),
        .init(first: "cap", second: "cab", contrast: "unvoiced /p/ vs voiced /b/"),
        .init(first: "wet", second: "vet", contrast: "/w/ vs /v/"),
        .init(first: "light", second: "right", contrast: "/l/ vs /r/")
    ]

    static let tongueTwisters: [PracticeLine] = [
        .init(text: "She sells sea shells by the sea shore.", focus: "/ʃ/ and /s/ contrast"),
        .init(text: "Red lorry, yellow lorry, red lorry, yellow lorry.", focus: "/l/ and /r/ blends"),
        .init(text: "The thirty-three thieves thought they thrilled the throne.", focus: "/θ/ digraph"),
        .init(text: "Peter Piper picked a peck of pickled peppers.", focus: "/p/ plosive"),
        .init(text: "Six slippery snails slid slowly seaward.", focus: "/s/ blends"),
        .init(text: "Fresh fried fish, fish fresh fried.", focus: "/f/ and /r/ blends")
    ]

    static let shortMessages: [PracticeLine] = [
        .init(text: "Good morning! How are you today?", focus: "greeting intonation"),
        .init(text: "Thank you so much for your help.", focus: "gratitude, soft tone"),
        .init(text: "Can you please say that again?", focus: "polite request, rising end"),
        .init(text: "I'll be there in five minutes.", focus: "contractions and linking"),
        .init(text: "That sounds like a great idea.", focus: "long vowel teams"),
        .init(text: "Let's catch up later this week.", focus: "blends and short vowels"),
        .init(text: "Have a wonderful weekend!", focus: "warm closing tone"),
        .init(text: "No worries, take your time.", focus: "reassuring, calm pace")
    ]

    static let sentenceDrills: [PracticeLine] = [
        .init(text: "The quick brown fox jumps over the lazy dog.", focus: "all-letter warm-up"),
        .init(text: "Sarah parked her car in the dark farmyard.", focus: "r-controlled 'ar'"),
        .init(text: "Bright lights at night give me a fright.", focus: "'igh' long-i team"),
        .init(text: "The boy enjoyed the noisy toy.", focus: "/ɔɪ/ diphthong"),
        .init(text: "Please leave the green peas on the plate.", focus: "long-e vowel teams"),
        .init(text: "Three thin thieves thanked the theatre.", focus: "/θ/ in connected speech")
    ]

    static func lines(for kind: PracticeKind) -> [PracticeLine] {
        switch kind {
        case .tongueTwisters: return tongueTwisters
        case .shortMessages:  return shortMessages
        case .sentences:      return sentenceDrills
        case .minimalPairs:   return []   // handled via minimalPairs
        }
    }

    // MARK: - Emotion / intonation scripts

    static let emotionScripts: [String] = [
        "We won the game!",
        "I can't believe it's already over.",
        "Are you coming to the party?",
        "Everything is going to be okay.",
        "Please don't touch that.",
        "That was the best day of my life.",
        "I really need to talk to you.",
        "Look at how big it has grown."
    ]
}
