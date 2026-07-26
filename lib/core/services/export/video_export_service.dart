import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:path_provider/path_provider.dart';
import '../../../models/scene.dart';

enum ExportResolution { p1080, k4 }

/// Stitches ordered clips into a single MP4 using FFmpeg, matching the
/// "Create Full Video" one-button flow and the Export screen's format
/// choices (1080p/4K, 30/60fps, watermark on/off).
class VideoExportService {
  Future<String> concatenateClips({
    required List<Scene> orderedScenes,
    required ExportResolution resolution,
    required int fps,
    required bool watermark,
  }) async {
    final clipPaths = orderedScenes
        .where((s) => s.videoUrl != null)
        .map((s) => s.videoUrl!)
        .toList();

    if (clipPaths.isEmpty) {
      throw StateError('No ready clips to export.');
    }

    final tempDir = await getTemporaryDirectory();
    final listFile = File('${tempDir.path}/concat_list.txt');
    await listFile.writeAsString(
      clipPaths.map((p) => "file '$p'").join('\n'),
    );

    final outputPath =
        '${tempDir.path}/song2video_export_${DateTime.now().millisecondsSinceEpoch}.mp4';

    final scale = resolution == ExportResolution.k4 ? '3840:2160' : '1920:1080';
    final watermarkFilter = watermark
        ? ",drawtext=text='Song2Video AI':x=w-tw-20:y=h-th-20:fontsize=24:fontcolor=white@0.6"
        : '';

    final command = "-f concat -safe 0 -i '${listFile.path}' "
        "-vf 'scale=$scale$watermarkFilter' -r $fps -c:v libx264 -preset medium "
        "-c:a aac -movflags +faststart '$outputPath'";

    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      return outputPath;
    } else {
      throw Exception('FFmpeg export failed with code $returnCode');
    }
  }
}
