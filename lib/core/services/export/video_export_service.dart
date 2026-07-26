import '../../../models/scene.dart';

enum ExportResolution { p1080, k4 }

/// Stitches ordered clips into a single MP4.
///
/// NOTE: ffmpeg_kit_flutter was removed from this build because its
/// packages were pulled from Maven and can no longer be resolved.
/// Replace this with a working video-processing solution before using
/// the Export screen for real — e.g. a server-side FFmpeg job, or an
/// actively maintained Flutter FFmpeg wrapper.
class VideoExportService {
  Future<String> concatenateClips({
    required List<Scene> orderedScenes,
    required ExportResolution resolution,
    required int fps,
    required bool watermark,
  }) async {
    throw UnimplementedError(
      'Video export is not wired up yet — ffmpeg_kit_flutter was removed '
      'because it is no longer available. See the comment in this file.',
    );
  }
}
