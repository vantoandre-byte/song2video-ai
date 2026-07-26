enum SceneSection { intro, verse, preChorus, chorus, bridge, outro }

enum ClipStatus { pending, generating, ready, failed }

class Scene {
  final String id;
  final int index;
  final SceneSection section;
  final String lyricSnippet;
  final double startTimeSeconds;
  final double endTimeSeconds; // always startTime + 10 in video mode
  final String mood;
  final String location;
  final String timeOfDay;
  final List<String> characterIds;
  final List<String> objects;
  final String generatedPrompt;
  final String? videoUrl;
  final String? thumbnailUrl;
  final ClipStatus status;

  const Scene({
    required this.id,
    required this.index,
    required this.section,
    required this.lyricSnippet,
    required this.startTimeSeconds,
    required this.endTimeSeconds,
    this.mood = '',
    this.location = '',
    this.timeOfDay = '',
    this.characterIds = const [],
    this.objects = const [],
    this.generatedPrompt = '',
    this.videoUrl,
    this.thumbnailUrl,
    this.status = ClipStatus.pending,
  });

  Scene copyWith({
    String? generatedPrompt,
    String? videoUrl,
    String? thumbnailUrl,
    ClipStatus? status,
  }) {
    return Scene(
      id: id,
      index: index,
      section: section,
      lyricSnippet: lyricSnippet,
      startTimeSeconds: startTimeSeconds,
      endTimeSeconds: endTimeSeconds,
      mood: mood,
      location: location,
      timeOfDay: timeOfDay,
      characterIds: characterIds,
      objects: objects,
      generatedPrompt: generatedPrompt ?? this.generatedPrompt,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      status: status ?? this.status,
    );
  }
}
