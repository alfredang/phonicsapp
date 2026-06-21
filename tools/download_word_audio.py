#!/usr/bin/env python3
"""Download real human pronunciation audio for the app's example words from the
Free Dictionary API (audio sourced from Wiktionary / Wikimedia Commons, CC-BY-SA).
Saves per-accent .m4a clips into Resources/WordAudio/. Run from project root.
Requires: ffmpeg. Network access.
"""
import json, os, re, subprocess, urllib.request

OUT = "Resources/WordAudio"
API = "https://api.dictionaryapi.dev/api/v2/entries/en/"

def words():
    src = open("Sources/Models/ContentLibrary.swift").read()
    s = set()
    for m in re.finditer(r'exampleWords:\s*\[([^\]]*)\]', src):
        for w in re.findall(r'"([^"]+)"', m.group(1)):
            s.add(w.lower())
    return sorted(s)

def fetch(url):
    req = urllib.request.Request(url, headers={"User-Agent": "phonics-app/1.0"})
    return urllib.request.urlopen(req, timeout=20).read()

def main():
    os.makedirs(OUT, exist_ok=True)
    got, missing = {}, []
    for w in words():
        try:
            data = json.loads(fetch(API + urllib.parse.quote(w)).decode())
        except Exception:
            missing.append(w); continue
        auds = [p["audio"] for e in data for p in e.get("phonetics", []) if p.get("audio")]
        # accent -> url (prefer uk/us/au order, ignore others)
        picked = {}
        for a in auds:
            for acc in ("uk", "us", "au"):
                if a.endswith(f"-{acc}.mp3") and acc not in picked:
                    picked[acc] = a
        if not picked:
            missing.append(w); continue
        for acc, url in picked.items():
            try:
                mp3 = fetch(url if url.startswith("http") else "https:" + url)
            except Exception:
                continue
            tmp = f"/tmp/{w}.mp3"; open(tmp, "wb").write(mp3)
            out = f"{OUT}/{w}_{acc}.m4a"
            subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-i", tmp,
                            "-af", "silenceremove=start_periods=1:start_duration=0:start_threshold=-45dB:"
                                   "detection=peak,areverse,silenceremove=start_periods=1:start_duration=0:"
                                   "start_threshold=-45dB:detection=peak,areverse,loudnorm",
                            "-ar", "22050", "-ac", "1", "-c:a", "aac", "-b:a", "64k", out], check=False)
            os.unlink(tmp)
            got.setdefault(w, []).append(acc)
    print(f"downloaded audio for {len(got)}/{len(words())} words")
    print(f"missing (TTS fallback): {len(missing)} -> {', '.join(missing)}")
    open("/tmp/word_audio_missing.txt", "w").write("\n".join(missing))

if __name__ == "__main__":
    import urllib.parse
    main()
