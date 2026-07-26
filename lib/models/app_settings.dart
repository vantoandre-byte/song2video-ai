enum VideoProviderType {
  kling,     // cheapest / default
  veo,
  runway,
  pika,
  luma,
  gemini,    // Google Gemini/Veo API route
  grok,      // xAI Grok Imagine Video
  chatgpt,   // OpenAI Sora
}

extension VideoProviderTypeX on VideoProviderType {
  String get label {
    switch (this) {
      case VideoProviderType.kling:
        return 'Kling (cheapest)';
      case VideoProviderType.veo:
        return 'Google Veo';
      case VideoProviderType.runway:
        return 'Runway';
      case VideoProviderType.pika:
        return 'Pika';
      case VideoProviderType.luma:
        return 'Luma';
      case VideoProviderType.gemini:
        return 'Gemini (Veo via Google AI)';
      case VideoProviderType.grok:
        return 'Grok Imagine Video';
      case VideoProviderType.chatgpt:
        return 'ChatGPT (Sora)';
    }
  }

  /// Rough $/10-second-clip, for display only. Update periodically —
  /// provider pricing changes frequently.
  String get approxCostPerClip {
    switch (this) {
      case VideoProviderType.kling:
        return '~\$0.70 – \$1.00';
      case VideoProviderType.veo:
        return '~\$0.50 (lite) – \$7.50 (standard+audio)';
      case VideoProviderType.runway:
        return '~\$0.50 – \$1.50';
      case VideoProviderType.pika:
        return 'Subscription, ~\$15–28/mo';
      case VideoProviderType.luma:
        return '~\$0.60 – \$1.50';
      case VideoProviderType.gemini:
        return '~\$0.50 – \$7.50 (same Veo backend)';
      case VideoProviderType.grok:
        return '~\$0.50 (est.)';
      case VideoProviderType.chatgpt:
        return 'Varies, premium tier';
    }
  }
}

enum AppResolution { p720, p1080, k4 }

enum AppAspectRatio { widescreen, vertical, square }

class AppSettings {
  final VideoProviderType videoProvider;
  final AppResolution resolution;
  final AppAspectRatio aspectRatio;
  final bool developerMode;
  final bool christianMode;
  final bool watermarkEnabled;
  final bool darkMode;
  final Map<VideoProviderType, String> apiKeys;

  const AppSettings({
    this.videoProvider = VideoProviderType.kling, // default: cheapest
    this.resolution = AppResolution.p1080,
    this.aspectRatio = AppAspectRatio.widescreen,
    this.developerMode = false,
    this.christianMode = false,
    this.watermarkEnabled = true,
    this.darkMode = true,
    this.apiKeys = const {},
  });

  AppSettings copyWith({
    VideoProviderType? videoProvider,
    AppResolution? resolution,
    AppAspectRatio? aspectRatio,
    bool? developerMode,
    bool? christianMode,
    bool? watermarkEnabled,
    bool? darkMode,
    Map<VideoProviderType, String>? apiKeys,
  }) {
    return AppSettings(
      videoProvider: videoProvider ?? this.videoProvider,
      resolution: resolution ?? this.resolution,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      developerMode: developerMode ?? this.developerMode,
      christianMode: christianMode ?? this.christianMode,
      watermarkEnabled: watermarkEnabled ?? this.watermarkEnabled,
      darkMode: darkMode ?? this.darkMode,
      apiKeys: apiKeys ?? this.apiKeys,
    );
  }
}
