import 'package:dio/dio.dart';
import '../../../../models/scene.dart';
import '../../../../models/app_settings.dart';
import '../video_provider_service.dart';

/// Pika Labs. Docs: https://pika.art/api-docs (subscription/credit based).
class PikaService implements VideoProviderService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.pika.art/v1'));

  @override
  VideoProviderType get type => VideoProviderType.pika;

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
      // TODO: wire real Pika generate + status-poll endpoints.
      return _mockResult(scene);
    } catch (e) {
      return GenerationResult.error('Pika generation failed: $e');
    }
  }

  GenerationResult _mockResult(Scene scene) => GenerationResult.ok(
        'https://mock.song2video.ai/clips/${scene.id}.mp4',
        'https://mock.song2video.ai/thumbs/${scene.id}.jpg',
      );
}
