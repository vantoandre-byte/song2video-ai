import 'scene.dart';
import 'character.dart';
import 'song.dart';

class Project {
  final String id;
  final String title;
  final String rawLyrics;
  final SongAnalysis? songAnalysis;
  final List<CharacterProfile> characters;
  final List<Scene> scenes;
  final bool christianModeEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Project({
    required this.id,
    required this.title,
    required this.rawLyrics,
    this.songAnalysis,
    this.characters = const [],
    this.scenes = const [],
    this.christianModeEnabled = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Project copyWith({
    String? title,
    SongAnalysis? songAnalysis,
    List<CharacterProfile>? characters,
    List<Scene>? scenes,
    bool? christianModeEnabled,
  }) {
    return Project(
      id: id,
      title: title ?? this.title,
      rawLyrics: rawLyrics,
      songAnalysis: songAnalysis ?? this.songAnalysis,
      characters: characters ?? this.characters,
      scenes: scenes ?? this.scenes,
      christianModeEnabled: christianModeEnabled ?? this.christianModeEnabled,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
