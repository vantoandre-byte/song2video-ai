import 'package:dio/dio.dart';
import '../../../../models/scene.dart';
import '../../../../models/app_settings.dart';
import '../video_provider_service.dart';

/// Gemini API route to Google's video generation (Veo models exposed
/// through the Gemini/Google AI Studio API rather than Vertex AI).
/// Docs: https://ai.google.dev
class GeminiService implements VideoProviderService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://generativelanguage.googleapis.com/v1beta'));

  @override
  VideoProviderType get type => VideoProviderType.gemini;

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
      // TODO: POST /models/veo-3.1-generate-preview:predictLongRunning?key=$apiKey
      // then poll the operation until done, per Gemini API video docs.
      return _mockResult(scene);
    } catch (e) {
      return GenerationResult.error('Gemini video generation failed: $e');
    }
  }

  GenerationResult _mockResult(Scene scene) => GenerationResult.ok(
        'https://mock.song2video.ai/clips/${scene.id}.mp4',
        'https://mock.song2video.ai/thumbs/${scene.id}.jpg',
      );
}
