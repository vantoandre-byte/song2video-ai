class SongAnalysis {
  final String filePath;
  final Duration duration;
  final double bpm;
  final List<SongSegment> segments; // intro/verse/chorus timing map

  const SongAnalysis({
    required this.filePath,
    required this.duration,
    required this.bpm,
    required this.segments,
  });
}

class SongSegment {
  final String label; // "Verse 1", "Chorus", "Intro"...
  final double startSeconds;
  final double endSeconds;

  const SongSegment({
    required this.label,
    required this.startSeconds,
    required this.endSeconds,
  });
}
