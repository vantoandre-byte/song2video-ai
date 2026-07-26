import 'package:dio/dio.dart';
import '../../../../models/scene.dart';
import '../../../../models/app_settings.dart';
import '../video_provider_service.dart';

/// Luma Dream Machine (Ray models). Docs: https://docs.lumalabs.ai
class LumaService implements VideoProviderService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.lumalabs.ai/dream-machine/v1'));

  @override
  VideoProviderType get type => VideoProviderType.luma;

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
      // TODO: POST /generations with model ray-3 + poll generation id.
      return _mockResult(scene);
    } catch (e) {
      return GenerationResult.error('Luma generation failed: $e');
    }
  }

  GenerationResult _mockResult(Scene scene) => GenerationResult.ok(
        'https://mock.song2video.ai/clips/${scene.id}.mp4',
        'https://mock.song2video.ai/thumbs/${scene.id}.jpg',
      );
}
