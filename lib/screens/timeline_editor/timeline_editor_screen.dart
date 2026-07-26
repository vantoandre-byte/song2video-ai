import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/project_provider.dart';
import '../../models/scene.dart';
import '../export/export_screen.dart';

class TimelineEditorScreen extends ConsumerWidget {
  const TimelineEditorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(projectProvider);
    final scenes = project?.scenes ?? [];
    final readyCount = scenes.where((s) => s.status == ClipStatus.ready).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Timeline')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: scenes.isEmpty ? 0 : readyCount / scenes.length,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                Text('$readyCount/${scenes.length} ready'),
              ],
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: scenes.length,
              onReorder: (oldIndex, newIndex) =>
                  ref.read(projectProvider.notifier).reorderScenes(oldIndex, newIndex),
              itemBuilder: (context, i) {
                final scene = scenes[i];
                return Card(
                  key: ValueKey(scene.id),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${i + 1}')),
                    title: Text('${scene.section.name} · ${scene.lyricSnippet}',
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(_statusLabel(scene.status)),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'delete':
                            ref.read(projectProvider.notifier).deleteScene(scene.id);
                            break;
                          case 'regenerate':
                            ref.read(projectProvider.notifier).generateClipForScene(scene.id);
                            break;
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'regenerate', child: Text('Regenerate')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.bolt),
                  label: const Text('Create Full Video (generate all clips)'),
                  onPressed: scenes.isEmpty
                      ? null
                      : () => ref.read(projectProvider.notifier).generateAllClips(),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.file_download_outlined),
                  label: const Text('Go to Export'),
                  onPressed: readyCount == 0
                      ? null
                      : () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ExportScreen()),
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(ClipStatus status) {
    switch (status) {
      case ClipStatus.pending:
        return 'Not generated';
      case ClipStatus.generating:
        return 'Generating…';
      case ClipStatus.ready:
        return 'Ready';
      case ClipStatus.failed:
        return 'Failed — tap regenerate';
    }
  }
}
