import 'package:dio/dio.dart';
import '../../../../models/scene.dart';
import '../../../../models/app_settings.dart';
import '../video_provider_service.dart';

/// OpenAI / ChatGPT video (Sora). Docs: https://platform.openai.com/docs
class OpenAiSoraService implements VideoProviderService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.openai.com/v1'));

  @override
  VideoProviderType get type => VideoProviderType.chatgpt;

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
      // TODO: POST /videos with model sora-2 / sora-2-pro, then poll job status.
      return _mockResult(scene);
    } catch (e) {
      return GenerationResult.error('Sora generation failed: $e');
    }
  }

  GenerationResult _mockResult(Scene scene) => GenerationResult.ok(
        'https://mock.song2video.ai/clips/${scene.id}.mp4',
        'https://mock.song2video.ai/thumbs/${scene.id}.jpg',
      );
}
