import '../../../models/song.dart';

/// Analyzes an uploaded audio file for duration, BPM, and section timing
/// (intro/verse/chorus/outro). Real BPM/onset detection typically runs
/// through a native FFI lib or a backend job; this class defines the
/// contract and a lightweight fallback so the rest of the app can be
/// built and tested against it immediately.
class AudioAnalysisService {
  Future<SongAnalysis> analyze(String filePath) async {
    // TODO: replace with real duration/BPM/section detection, e.g. via
    // an FFmpeg probe for duration + an onset/tempo-detection library
    // or backend service (Essentia, librosa via a Cloud Function, etc).
    await Future.delayed(const Duration(milliseconds: 300));

    const mockDuration = Duration(minutes: 3, seconds: 20);
    const mockBpm = 96.0;

    final segments = [
      const SongSegment(label: 'Intro', startSeconds: 0, endSeconds: 15),
      const SongSegment(label: 'Verse 1', startSeconds: 15, endSeconds: 45),
      const SongSegment(label: 'Chorus', startSeconds: 45, endSeconds: 75),
      const SongSegment(label: 'Verse 2', startSeconds: 75, endSeconds: 105),
      const SongSegment(label: 'Chorus', startSeconds: 105, endSeconds: 135),
      const SongSegment(label: 'Bridge', startSeconds: 135, endSeconds: 165),
      const SongSegment(label: 'Chorus', startSeconds: 165, endSeconds: 190),
      const SongSegment(label: 'Outro', startSeconds: 190, endSeconds: 200),
    ];

    return SongAnalysis(
      filePath: filePath,
      duration: mockDuration,
      bpm: mockBpm,
      segments: segments,
    );
  }
}
