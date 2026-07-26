import '../../../models/scene.dart';
import '../../../models/app_settings.dart';

/// Result returned by any video generation provider.
class GenerationResult {
  final bool success;
  final String? videoUrl;
  final String? thumbnailUrl;
  final String? errorMessage;

  const GenerationResult.ok(this.videoUrl, this.thumbnailUrl)
      : success = true,
        errorMessage = null;

  const GenerationResult.error(this.errorMessage)
      : success = false,
        videoUrl = null,
        thumbnailUrl = null;
}

/// Common contract every AI video backend must implement.
/// This is the seam that lets Settings swap providers freely —
/// Kling, Veo, Runway, Pika, Luma, Gemini, Grok, ChatGPT/Sora all
/// plug in here identically.
abstract class VideoProviderService {
  VideoProviderType get type;

  /// Generates exactly one 10-second clip for [scene] using [prompt].
  /// [apiKey] is pulled from AppSettings.apiKeys at call time.
  Future<GenerationResult> generateClip({
    required Scene scene,
    required String prompt,
    required String apiKey,
    required AppResolution resolution,
    required AppAspectRatio aspectRatio,
  });

  /// Whether this provider is configured (has a non-empty API key).
  bool isConfigured(String? apiKey) => apiKey != null && apiKey.trim().isNotEmpty;
}
