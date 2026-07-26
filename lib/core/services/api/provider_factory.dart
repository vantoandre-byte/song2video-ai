import '../../../models/app_settings.dart';
import 'video_provider_service.dart';
import 'providers/kling_service.dart';
import 'providers/veo_service.dart';
import 'providers/runway_service.dart';
import 'providers/pika_service.dart';
import 'providers/luma_service.dart';
import 'providers/gemini_service.dart';
import 'providers/grok_service.dart';
import 'providers/openai_sora_service.dart';

/// Single place that maps a [VideoProviderType] to its concrete
/// implementation. Add new providers here and in app_settings.dart.
class VideoProviderFactory {
  static final Map<VideoProviderType, VideoProviderService> _services = {
    VideoProviderType.kling: KlingService(),
    VideoProviderType.veo: VeoService(),
    VideoProviderType.runway: RunwayService(),
    VideoProviderType.pika: PikaService(),
    VideoProviderType.luma: LumaService(),
    VideoProviderType.gemini: GeminiService(),
    VideoProviderType.grok: GrokService(),
    VideoProviderType.chatgpt: OpenAiSoraService(),
  };

  static VideoProviderService resolve(VideoProviderType type) {
    return _services[type] ?? _services[VideoProviderType.kling]!;
  }
}
