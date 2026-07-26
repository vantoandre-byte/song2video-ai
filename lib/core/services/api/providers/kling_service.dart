import 'package:dio/dio.dart';
import '../../../../models/scene.dart';
import '../../../../models/app_settings.dart';
import '../video_provider_service.dart';

/// Kling AI — default provider (cheapest per-clip cost, ~$0.70-$1.00/10s).
/// Docs: https://klingai.com (API uses prepaid resource-unit packages).
class KlingService implements VideoProviderService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.klingai.com/v1'));

  @override
  VideoProviderType get type => VideoProviderType.kling;

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
    if (!isConfigured(apiKey)) {
      // No key set yet -> return a mock placeholder so the UI/timeline
      // can still be exercised end-to-end without live billing.
      return _mockResult(scene);
    }
    try {
      // TODO: replace with real Kling text-to-video endpoint + polling.
      // final response = await _dio.post('/videos/text2video', data: {
      //   'prompt': prompt,
      //   'duration': 10,
      //   'aspect_ratio': _mapAspectRatio(aspectRatio),
      // }, options: Options(headers: {'Authorization': 'Bearer $apiKey'}));
      return _mockResult(scene);
    } catch (e) {
      return GenerationResult.error('Kling generation failed: $e');
    }
  }

  GenerationResult _mockResult(Scene scene) => GenerationResult.ok(
        'https://mock.song2video.ai/clips/${scene.id}.mp4',
        'https://mock.song2video.ai/thumbs/${scene.id}.jpg',
      );
}
