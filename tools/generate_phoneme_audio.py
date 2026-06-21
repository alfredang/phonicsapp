#!/usr/bin/env python3
"""Pre-render isolated phoneme audio with macOS `say` phoneme notation, trim silence,
and emit per-accent .m4a clips embedded in the app bundle. Run from the project root:
    python3 tools/generate_phoneme_audio.py
Requires: macOS `say`, `afconvert`/`afinfo`, and `ffmpeg` (brew install ffmpeg).
"""
import os, subprocess, tempfile, sys

OUT = "Resources/Sounds"
# Reed ships as matched UK + US variants and honours `[[inpt PHON]]` cleanly
# (modern "Siri" voices like Daniel/Samantha break the phoneme into artefacts).
VOICES = {"uk": "Reed (English (UK))", "us": "Reed (English (US))"}

# (IPA key — matches Phoneme.soundIPA, file code, Apple phoneme string for `say`)
# Continuant consonants render pure; stops/affricates/glides take a light schwa (1AX);
# vowels render by definition (IY → /iː/), so they are correct regardless of accent.
PHONEMES = [
    # consonants
    ("b","b","b1AX"), ("d","d","d1AX"), ("ɡ","g","g1AX"), ("k","k","k1AX"),
    ("p","p","p1AX"), ("t","t","t1AX"), ("dʒ","j","J1AX"), ("tʃ","ch","C1AX"),
    ("h","h","h1AX"), ("w","w","w1AX"), ("j","y","y1AX"),
    ("f","f","f"), ("v","v","v"), ("s","s","s"), ("z","z","z"),
    ("ʃ","sh","S"), ("m","m","m"), ("n","n","n"), ("l","l","l"), ("r","r","r"),
    ("θ","th","T"), ("ð","dh","D"), ("ŋ","ng","1AXN"),
    # short vowels
    ("æ","ae","1AE"), ("ɛ","eh","1EH"), ("ɪ","ih","1IH"), ("ɒ","aa","1AA"), ("ʌ","ah","1AH"),
    # long vowels & vowel teams
    ("eɪ","ay","1EY"), ("iː","ee","1IY"), ("aɪ","eye","1AY"), ("oʊ","oh","1OW"),
    ("juː","yoo","y1UW"), ("uː","oo","1UW"),
    # diphthongs
    ("ɔɪ","oy","1OY"), ("aʊ","ow","1AW"), ("ɔː","aw","1AO"),
    # r-controlled (the British voice naturally drops the r, the US voice keeps it)
    ("ɑːr","ar","1AAr"), ("ɔːr","or","1AOr"), ("ɜːr","er","1ER"),
    # blends
    ("bl","bl","bl1AX"), ("kl","cl","kl1AX"), ("fl","fl","fl1AX"), ("ɡr","gr","gr1AX"),
    ("tr","tr","tr1AX"), ("st","st","st1AX"), ("sp","sp","sp1AX"), ("sn","sn","sn1AX"),
    ("str","str","str1AX"),
]

# Trim leading + trailing silence, cap held vowels at 1.2s, and fade the tail.
TRIM = ("silenceremove=start_periods=1:start_duration=0:start_threshold=-45dB:detection=peak,"
        "areverse,"
        "silenceremove=start_periods=1:start_duration=0:start_threshold=-45dB:detection=peak,"
        "areverse,"
        "atrim=0:1.2,"
        "afade=t=out:st=1.0:d=0.2")

def main():
    os.makedirs(OUT, exist_ok=True)
    made = 0
    for ipa, code, phon in PHONEMES:
        for acc, voice in VOICES.items():
            with tempfile.NamedTemporaryFile(suffix=".aiff", delete=False) as tf:
                raw = tf.name
            text = f"[[inpt PHON]]{phon}[[inpt TEXT]]"
            subprocess.run(["say", "-v", voice, text, "-o", raw], check=True)
            out = f"{OUT}/{code}_{acc}.m4a"
            subprocess.run(
                ["ffmpeg", "-y", "-loglevel", "error", "-i", raw, "-af", TRIM,
                 "-ar", "22050", "-ac", "1", "-c:a", "aac", "-b:a", "64k", out],
                check=True)
            os.unlink(raw)
            made += 1
    print(f"generated {made} clips ({len(PHONEMES)} phonemes × {len(VOICES)} accents) in {OUT}/")

    # Emit the Swift audioCode map so the app and this script never drift.
    codes = ",\n".join(f'        "{ipa}": "{code}"' for ipa, code, _ in PHONEMES)
    print("\n--- paste into Phoneme.swift (static audioCodes) ---")
    print("    static let audioCodes: [String: String] = [\n" + codes + "\n    ]")

if __name__ == "__main__":
    main()
