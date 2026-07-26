import 'package:uuid/uuid.dart';
import '../../../models/scene.dart';
import '../../../models/song.dart';

/// Splits raw lyrics into structural sections, then further into
/// ~10-second scenes aligned to song timing. In production this calls
/// an LLM (story/mood/character/object extraction); here the parsing
/// logic and data flow are fully wired, with the LLM call abstracted
/// behind [_analyzeSectionWithLlm] so you can drop in your API of choice
/// (Claude, GPT, Gemini) for the semantic understanding step.
class LyricAnalysisService {
  final _uuid = const Uuid();

  /// Splits raw pasted lyrics into labeled sections using common
  /// markers like [Verse], [Chorus], blank-line breaks, etc.
  List<SongSegment> splitIntoSections(String rawLyrics) {
    final lines = rawLyrics.split('\n');
    final sections = <SongSegment>[];
    String currentLabel = 'Verse 1';
    final buffer = <String>[];

    void flush() {
      if (buffer.isNotEmpty) {
        sections.add(SongSegment(
          label: currentLabel,
          startSeconds: 0, // filled in later once matched to audio
          endSeconds: 0,
        ));
        buffer.clear();
      }
    }

    final sectionTag = RegExp(r'^\[(.+)\]$');
    for (final line in lines) {
      final trimmed = line.trim();
      final match = sectionTag.firstMatch(trimmed);
      if (match != null) {
        flush();
        currentLabel = match.group(1)!;
      } else if (trimmed.isNotEmpty) {
        buffer.add(trimmed);
      }
    }
    flush();
    return sections;
  }

  /// Breaks lyrics + song timing into 10-second scenes with story metadata.
  /// [audio] provides section timing; if null, scenes are spaced evenly.
  Future<List<Scene>> generateScenes({
    required String rawLyrics,
    SongAnalysis? audio,
    bool christianMode = false,
  }) async {
    final lines = rawLyrics
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty && !RegExp(r'^\[.+\]$').hasMatch(l))
        .toList();

    final totalDuration = audio?.duration.inSeconds.toDouble() ?? (lines.length * 5);
    final clipCount = (totalDuration / 10).ceil().clamp(1, 200);
    final linesPerClip = (lines.length / clipCount).ceil().clamp(1, lines.length);

    final scenes = <Scene>[];
    for (int i = 0; i < clipCount; i++) {
      final start = lines.length > i * linesPerClip ? i * linesPerClip : lines.length;
      final end = ((i + 1) * linesPerClip).clamp(0, lines.length);
      if (start >= end) break;
      final snippet = lines.sublist(start, end).join(' ');

      final analysis = await _analyzeSectionWithLlm(snippet, christianMode);

      scenes.add(Scene(
        id: _uuid.v4(),
        index: i,
        section: _inferSection(i, clipCount),
        lyricSnippet: snippet,
        startTimeSeconds: i * 10,
        endTimeSeconds: i * 10 + 10,
        mood: analysis['mood'] ?? '',
        location: analysis['location'] ?? '',
        timeOfDay: analysis['timeOfDay'] ?? '',
        objects: List<String>.from(analysis['objects'] ?? const []),
      ));
    }
    return scenes;
  }

  SceneSection _inferSection(int index, int total) {
    if (index == 0) return SceneSection.intro;
    if (index == total - 1) return SceneSection.outro;
    if (index % 4 == 3) return SceneSection.chorus;
    return SceneSection.verse;
  }

  /// Placeholder for the actual story/mood/character/object extraction
  /// call to an LLM. Swap this implementation for a real API call
  /// (e.g. Claude or GPT with a structured-JSON system prompt).
  Future<Map<String, dynamic>> _analyzeSectionWithLlm(
    String snippet,
    bool christianMode,
  ) async {
    // TODO: replace with a real LLM call returning structured JSON:
    // { "mood": ..., "location": ..., "timeOfDay": ..., "objects": [...] }
    await Future.delayed(const Duration(milliseconds: 50));
    final biblicalHit = christianMode &&
        RegExp(r'\b(jesus|david|moses|noah|shepherd|cross|angel|heaven|worship)\b',
                caseSensitive: false)
            .hasMatch(snippet);
    return {
      'mood': biblicalHit ? 'reverent, hopeful' : 'reflective',
      'location': biblicalHit ? 'golden pastoral landscape' : 'undefined',
      'timeOfDay': 'golden hour',
      'objects': biblicalHit ? ['staff', 'robe', 'light rays'] : <String>[],
    };
  }
}
