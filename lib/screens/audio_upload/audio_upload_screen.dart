import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../providers/project_provider.dart';
import '../scene_review/scene_review_screen.dart';

class AudioUploadScreen extends ConsumerStatefulWidget {
  const AudioUploadScreen({super.key});

  @override
  ConsumerState<AudioUploadScreen> createState() => _AudioUploadScreenState();
}

class _AudioUploadScreenState extends ConsumerState<AudioUploadScreen> {
  String? _fileName;
  bool _analyzing = false;

  Future<void> _pickAudio() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a'],
    );
    if (result == null || result.files.single.path == null) return;

    setState(() {
      _fileName = result.files.single.name;
      _analyzing = true;
    });

    await ref.read(projectProvider.notifier).attachAudio(result.files.single.path!);

    setState(() => _analyzing = false);
  }

  @override
  Widget build(BuildContext context) {
    final project = ref.watch(projectProvider);
    final analysis = project?.songAnalysis;

    return Scaffold(
      appBar: AppBar(title: const Text('Upload Audio')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Upload the song audio', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              const Text('Supported formats: MP3, WAV, M4A', style: TextStyle(color: Colors.white60)),
              const SizedBox(height: 24),
              Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: _analyzing ? null : _pickAudio,
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.audiotrack, size: 48, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(height: 12),
                        Text(_fileName ?? 'Tap to select an audio file'),
                        if (_analyzing) ...[
                          const SizedBox(height: 16),
                          const CircularProgressIndicator(),
                          const SizedBox(height: 8),
                          const Text('Detecting BPM, chorus, verses...', style: TextStyle(color: Colors.white60)),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              if (analysis != null) ...[
                const SizedBox(height: 24),
                Text('Detected structure', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('Duration: ${analysis.duration.inMinutes}m ${analysis.duration.inSeconds % 60}s   '
                    'BPM: ${analysis.bpm.toStringAsFixed(0)}'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: analysis.segments
                      .map((s) => Chip(label: Text('${s.label} (${s.startSeconds.toInt()}s-${s.endSeconds.toInt()}s)')))
                      .toList(),
                ),
              ],
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Generate Scenes'),
                onPressed: analysis == null
                    ? null
                    : () async {
                        await ref.read(projectProvider.notifier).generateScenes();
                        if (context.mounted) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const SceneReviewScreen()),
                          );
                        }
                      },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Image Mode: upload up to 10 images (coming to this screen)')),
                  );
                },
                child: const Text('Skip — use Image Mode instead'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
