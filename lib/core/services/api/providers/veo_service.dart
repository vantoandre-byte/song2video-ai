import 'package:dio/dio.dart';
import '../../../../models/scene.dart';
import '../../../../models/app_settings.dart';
import '../video_provider_service.dart';

/// Google Veo (via Vertex AI / Google AI Studio).
class VeoService implements VideoProviderService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://generativelanguage.googleapis.com/v1beta'));

  @override
  VideoProviderType get type => VideoProviderType.veo;

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
      // TODO: wire real Veo text-to-video call, e.g.
      // POST /models/veo-3.1:generateVideo?key=$apiKey
      return _mockResult(scene);
    } catch (e) {
      return GenerationResult.error('Veo generation failed: $e');
    }
  }

  GenerationResult _mockResult(Scene scene) => GenerationResult.ok(
        'https://mock.song2video.ai/clips/${scene.id}.mp4',
        'https://mock.song2video.ai/thumbs/${scene.id}.jpg',
      );
}
