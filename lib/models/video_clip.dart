class VideoClip {
  final String sceneId;
  final String url;
  final String provider;
  final Duration length;
  final String resolution; // 720p / 1080p / 4K
  final String aspectRatio; // 16:9, 9:16, 1:1

  const VideoClip({
    required this.sceneId,
    required this.url,
    required this.provider,
    required this.length,
    required this.resolution,
    required this.aspectRatio,
  });
}
