import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/project.dart';
import '../models/scene.dart';
import '../models/song.dart';
import '../models/app_settings.dart';
import '../core/services/lyrics/lyric_analysis_service.dart';
import '../core/services/lyrics/prompt_generator_service.dart';
import '../core/services/audio/audio_analysis_service.dart';
import '../core/services/api/provider_factory.dart';
import 'settings_provider.dart';

/// Holds the single active project (lyrics, audio analysis, scenes,
/// characters) as the user moves through the workflow.
class ProjectNotifier extends StateNotifier<Project?> {
  final Ref ref;
  final _uuid = const Uuid();
  final _lyricService = LyricAnalysisService();
  final _promptGenerator = PromptGeneratorService();
  final _audioService = AudioAnalysisService();

  ProjectNotifier(this.ref) : super(null);

  void startNewProject(String title, String rawLyrics) {
    final now = DateTime.now();
    state = Project(
      id: _uuid.v4(),
      title: title,
      rawLyrics: rawLyrics,
      createdAt: now,
      updatedAt: now,
    );
  }

  Future<void> attachAudio(String filePath) async {
    if (state == null) return;
    final analysis = await _audioService.analyze(filePath);
    state = state!.copyWith(songAnalysis: analysis);
  }

  Future<void> generateScenes() async {
    if (state == null) return;
    final scenes = await _lyricService.generateScenes(
      rawLyrics: state!.rawLyrics,
      audio: state!.songAnalysis,
      christianMode: state!.christianModeEnabled,
    );
    state = state!.copyWith(scenes: scenes);
  }

  Future<void> generatePromptForScene(String sceneId) async {
    if (state == null) return;
    final idx = state!.scenes.indexWhere((s) => s.id == sceneId);
    if (idx == -1) return;
    final scene = state!.scenes[idx];
    final prompt = _promptGenerator.buildPrompt(
      scene: scene,
      characters: state!.characters,
      christianMode: state!.christianModeEnabled,
    );
    final updatedScenes = [...state!.scenes];
    updatedScenes[idx] = scene.copyWith(generatedPrompt: prompt);
    state = state!.copyWith(scenes: updatedScenes);
  }

  Future<void> generateClipForScene(String sceneId) async {
    if (state == null) return;
    final settings = ref.read(settingsProvider);
    final idx = state!.scenes.indexWhere((s) => s.id == sceneId);
    if (idx == -1) return;

    var scene = state!.scenes[idx];
    if (scene.generatedPrompt.isEmpty) {
      await generatePromptForScene(sceneId);
      scene = state!.scenes.firstWhere((s) => s.id == sceneId);
    }

    var updated = [...state!.scenes];
    final generatingIdx = updated.indexWhere((s) => s.id == sceneId);
    updated[generatingIdx] = scene.copyWith(status: ClipStatus.generating);
    state = state!.copyWith(scenes: updated);

    final service = VideoProviderFactory.resolve(settings.videoProvider);
    final apiKey = settings.apiKeys[settings.videoProvider] ?? '';
    final result = await service.generateClip(
      scene: scene,
      prompt: scene.generatedPrompt,
      apiKey: apiKey,
      resolution: settings.resolution,
      aspectRatio: settings.aspectRatio,
    );

    updated = [...state!.scenes];
    final finalIdx = updated.indexWhere((s) => s.id == sceneId);
    updated[finalIdx] = result.success
        ? scene.copyWith(
            status: ClipStatus.ready,
            videoUrl: result.videoUrl,
            thumbnailUrl: result.thumbnailUrl,
          )
        : scene.copyWith(status: ClipStatus.failed);
    state = state!.copyWith(scenes: updated);
  }

  /// One-button "Create Full Video": generates every scene's clip in order.
  Future<void> generateAllClips() async {
    if (state == null) return;
    for (final scene in state!.scenes) {
      await generateClipForScene(scene.id);
    }
  }

  void reorderScenes(int oldIndex, int newIndex) {
    if (state == null) return;
    final scenes = [...state!.scenes];
    if (newIndex > oldIndex) newIndex -= 1;
    final item = scenes.removeAt(oldIndex);
    scenes.insert(newIndex, item);
    state = state!.copyWith(scenes: scenes);
  }

  void deleteScene(String sceneId) {
    if (state == null) return;
    state = state!.copyWith(scenes: state!.scenes.where((s) => s.id != sceneId).toList());
  }

  void toggleChristianMode(bool value) {
    if (state == null) return;
    state = state!.copyWith(christianModeEnabled: value);
  }
}

final projectProvider = StateNotifierProvider<ProjectNotifier, Project?>(
  (ref) => ProjectNotifier(ref),
);
