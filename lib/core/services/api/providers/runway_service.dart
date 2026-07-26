import 'package:dio/dio.dart';
import '../../../../models/scene.dart';
import '../../../../models/app_settings.dart';
import '../video_provider_service.dart';

/// Runway ML (Gen-4 / Gen-4.5). Docs: https://docs.dev.runwayml.com
class RunwayService implements VideoProviderService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.dev.runwayml.com/v1'));

  @override
  VideoProviderType get type => VideoProviderType.runway;

  @override
  bool isConfigured(String? apiKey) => apiKey != null && apiKey.trim().isNotEmpty;

  @override
  Future<GenerationResult> generateClip({
    required Scene scene,
    required String prompt,
    required String apiKey,
    required AppResolution resolution,
    required AppAspectRatio aspectRatio,
  }) async {
    if (!isConfigured(apiKey)) return _mockResult(scene);
    try {
      // TODO: POST /text_to_video with model gen4_turbo / gen4.5 + poll task id.
      return _mockResult(scene);
    } catch (e) {
      return GenerationResult.error('Runway generation failed: $e');
    }
  }

  GenerationResult _mockResult(Scene scene) => GenerationResult.ok(
        'https://mock.song2video.ai/clips/${scene.id}.mp4',
        'https://mock.song2video.ai/thumbs/${scene.id}.jpg',
      );
}
