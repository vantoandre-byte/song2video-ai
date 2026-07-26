import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/project_provider.dart';
import '../../core/services/export/video_export_service.dart';

class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  final _exportService = VideoExportService();
  ExportResolution _resolution = ExportResolution.p1080;
  int _fps = 30;
  bool _watermark = true;
  bool _exporting = false;
  String? _outputPath;

  Future<void> _export() async {
    final project = ref.read(projectProvider);
    if (project == null) return;
    setState(() {
      _exporting = true;
      _outputPath = null;
    });
    try {
      final path = await _exportService.concatenateClips(
        orderedScenes: project.scenes,
        resolution: _resolution,
        fps: _fps,
        watermark: _watermark,
      );
      setState(() => _outputPath = path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Resolution', style: Theme.of(context).textTheme.titleMedium),
            SegmentedButton<ExportResolution>(
              segments: const [
                ButtonSegment(value: ExportResolution.p1080, label: Text('1080p')),
                ButtonSegment(value: ExportResolution.k4, label: Text('4K')),
              ],
              selected: {_resolution},
              onSelectionChanged: (s) => setState(() => _resolution = s.first),
            ),
            const SizedBox(height: 20),
            Text('Frame rate', style: Theme.of(context).textTheme.titleMedium),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 30, label: Text('30 FPS')),
                ButtonSegment(value: 60, label: Text('60 FPS')),
              ],
              selected: {_fps},
              onSelectionChanged: (s) => setState(() => _fps = s.first),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Watermark'),
              value: _watermark,
              onChanged: (v) => setState(() => _watermark = v),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: _exporting
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.movie_creation_outlined),
              label: Text(_exporting ? 'Exporting…' : 'Create Full Video (MP4)'),
              onPressed: _exporting ? null : _export,
            ),
            if (_outputPath != null) ...[
              const SizedBox(height: 20),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.greenAccent),
                  title: const Text('Export complete'),
                  subtitle: Text(_outputPath!, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      // TODO: wire share_plus to share _outputPath
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
