# Song2Video AI

Turn Suno-generated song lyrics into a cinematic, character-consistent
music video with minimal manual editing.

## What this project is

A production-oriented Flutter scaffold implementing the full workflow:

1. Paste lyrics → AI story/mood/character/object analysis
2. Upload audio (MP3/WAV/M4A) → duration/BPM/section detection
3. Lyrics auto-split into ~10-second scenes
4. Each scene becomes a cinematic AI video prompt (Character Memory keeps
   people/objects/environments consistent across scenes)
5. Prompts sent to a selectable AI video provider
6. Scenes reorderable in a Timeline Editor
7. One-button "Create Full Video" → FFmpeg concatenation → MP4 export

## Video generation providers

Implemented behind one common interface (`VideoProviderService`) so you can
switch providers from Settings without touching the rest of the app:

| Provider | Notes | Approx. cost / 10s clip* |
|---|---|---|
| **Kling** (default) | Best cost-per-clip overall | ~$0.70–$1.00 |
| Google Veo | Lite tier is cheapest per-second; Standard+audio is premium | $0.50–$7.50 |
| Runway (Gen-4/4.5) | Best editing control | $0.50–$1.50 |
| Pika | Subscription-based | $15–28/mo |
| Luma (Ray) | Strong for natural motion | $0.60–$1.50 |
| Gemini | Google's Veo models via the Gemini API route | $0.50–$7.50 |
| Grok (xAI) | Grok Imagine Video | ~$0.50 (est.) |
| ChatGPT (Sora) | OpenAI's video model | Varies, premium |

\* Pricing shifts frequently across all providers — verify current rates on
each provider's site before relying on these numbers for budgeting.

**Important:** none of these API calls are live yet. Every provider service
in `lib/core/services/api/providers/` currently returns a mock clip URL so
you can exercise the entire app (lyrics → scenes → timeline → export) without
spending money or holding live keys. Each file has a clearly marked `TODO`
where the real HTTP call goes — swap it in once you're ready to go live with
a given provider.

## Project structure

```
lib/
  core/
    services/
      api/                  # VideoProviderService interface + 8 providers + factory
      lyrics/                # Lyric analysis, scene splitting, prompt generation
      audio/                  # BPM / section detection
      firebase/                # Auth, Firestore, Storage
      export/                   # FFmpeg-based MP4 stitching
      cache/                     # Offline draft caching (Hive)
    theme/                        # Material 3 dark theme
  models/                          # Project, Scene, CharacterProfile, Song, AppSettings
  providers/                        # Riverpod state (settings, active project)
  screens/                          # One folder per screen
  widgets/                          # Shared UI components
```

## Getting started

1. Install Flutter (3.22+) and the FlutterFire CLI.
2. `flutter pub get`
3. `flutterfire configure` — this generates the real `lib/firebase_options.dart`,
   replacing the placeholder committed here.
4. Copy `.env.example` to `.env` and fill in whichever provider API keys you
   have (or leave blank and enter them later from the in-app Settings screen —
   both paths are wired).
5. `flutter run`

## What's stubbed vs. real right now

**Real, working logic:**
- Full navigation flow across all screens
- Lyric section parsing + scene splitting (10s scene boundaries, section
  labeling)
- Prompt generation (character consistency clauses, mood/location/time-of-day)
- Riverpod state management across the whole project lifecycle
- Timeline reordering, delete, regenerate
- FFmpeg concatenation command construction for export
- Firebase Auth / Firestore / Storage service wrappers
- Settings persistence (SharedPreferences) incl. per-provider API keys

**Stubbed, marked with `TODO`, ready for you to wire real APIs:**
- Actual HTTP calls to each of the 8 video providers (currently return a
  mock `.mp4` URL after a short simulated delay)
- LLM-backed story/mood/character/object extraction in
  `LyricAnalysisService._analyzeSectionWithLlm` (currently rule-based)
- Real BPM/onset audio analysis (currently returns representative mock
  timing)
- `firebase_options.dart` (needs `flutterfire configure`)

## Future features (not yet scaffolded)

Thumbnail/Shorts/Reels/TikTok generation, subtitles/captions, SEO
title/description/tags, lyric videos, album covers, AI voice narration,
batch generation — noted in the original spec but intentionally left out of
this pass to keep the core pipeline solid first.

## Tech stack

Flutter · Dart · Riverpod · Firebase (Auth/Firestore/Storage) · FFmpeg
(ffmpeg_kit_flutter) · Hive (offline cache) · Dio/http
