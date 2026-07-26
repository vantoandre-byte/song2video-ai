import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/project_provider.dart';
import '../../models/scene.dart';
import '../timeline_editor/timeline_editor_screen.dart';

class SceneReviewScreen extends ConsumerWidget {
  const SceneReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(projectProvider);
    final scenes = project?.scenes ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('Scenes (${scenes.length})')),
      body: scenes.isEmpty
          ? const Center(child: Text('No scenes generated yet'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: scenes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) => _SceneCard(scene: scenes[i]),
            ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.movie_creation_outlined),
        label: const Text('Open Timeline'),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const TimelineEditorScreen()),
        ),
      ),
    );
  }
}

class _SceneCard extends ConsumerWidget {
  final Scene scene;
  const _SceneCard({required this.scene});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(label: Text('Scene ${scene.index + 1}')),
                const SizedBox(width: 8),
                Chip(label: Text(scene.section.name)),
                const Spacer(),
                Text('${scene.startTimeSeconds.toInt()}s–${scene.endTimeSeconds.toInt()}s',
                    style: const TextStyle(color: Colors.white54)),
              ],
            ),
            const SizedBox(height: 10),
            Text(scene.lyricSnippet, maxLines: 3, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              children: [
                if (scene.mood.isNotEmpty) Chip(label: Text('mood: ${scene.mood}'), visualDensity: VisualDensity.compact),
                if (scene.location.isNotEmpty)
                  Chip(label: Text('loc: ${scene.location}'), visualDensity: VisualDensity.compact),
                if (scene.timeOfDay.isNotEmpty)
                  Chip(label: Text(scene.timeOfDay), visualDensity: VisualDensity.compact),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => ref.read(projectProvider.notifier).generatePromptForScene(scene.id),
                    child: const Text('Generate Prompt'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: scene.status == ClipStatus.generating
                        ? null
                        : () => ref.read(projectProvider.notifier).generateClipForScene(scene.id),
                    child: scene.status == ClipStatus.generating
                        ? const SizedBox(
                            height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(scene.status == ClipStatus.ready ? 'Regenerate Clip' : 'Generate Clip'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
