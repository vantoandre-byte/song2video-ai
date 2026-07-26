import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/project_provider.dart';
import '../audio_upload/audio_upload_screen.dart';

class LyricsInputScreen extends ConsumerStatefulWidget {
  const LyricsInputScreen({super.key});

  @override
  ConsumerState<LyricsInputScreen> createState() => _LyricsInputScreenState();
}

class _LyricsInputScreenState extends ConsumerState<LyricsInputScreen> {
  final _titleController = TextEditingController();
  final _lyricsController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _lyricsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paste Lyrics')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: 'Song title'),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextField(
                  controller: _lyricsController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText: 'Paste your Suno lyrics here, e.g.\n\n'
                        '[Verse 1]\nWalking through the fields of gold...\n\n'
                        '[Chorus]\nThis is the moment...',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Continue'),
                onPressed: () {
                  final lyrics = _lyricsController.text.trim();
                  if (lyrics.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Paste your lyrics first')),
                    );
                    return;
                  }
                  final title = _titleController.text.trim().isEmpty
                      ? 'Untitled Song'
                      : _titleController.text.trim();
                  ref.read(projectProvider.notifier).startNewProject(title, lyrics);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AudioUploadScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
