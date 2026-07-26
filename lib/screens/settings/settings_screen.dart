import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';
import '../../models/app_settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader('Video Generation Provider'),
          Card(
            child: Column(
              children: VideoProviderType.values.map((type) {
                final selected = settings.videoProvider == type;
                return RadioListTile<VideoProviderType>(
                  value: type,
                  groupValue: settings.videoProvider,
                  onChanged: (v) => notifier.setProvider(v!),
                  title: Text(type.label),
                  subtitle: Text(type.approxCostPerClip, style: const TextStyle(color: Colors.white54)),
                  secondary: type == VideoProviderType.kling
                      ? const Icon(Icons.savings_outlined, color: Colors.greenAccent)
                      : null,
                  selected: selected,
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Kling is set as default — it currently offers the best cost-per-clip. '
              'Prices change often across providers; switch anytime.',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeader('API Keys'),
          Card(
            child: Column(
              children: VideoProviderType.values
                  .map((type) => _ApiKeyTile(type: type, settings: settings, notifier: notifier))
                  .toList(),
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeader('Output'),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Resolution'),
                  trailing: DropdownButton<AppResolution>(
                    value: settings.resolution,
                    items: const [
                      DropdownMenuItem(value: AppResolution.p720, child: Text('720p')),
                      DropdownMenuItem(value: AppResolution.p1080, child: Text('1080p')),
                      DropdownMenuItem(value: AppResolution.k4, child: Text('4K')),
                    ],
                    onChanged: (v) => notifier.setResolution(v!),
                  ),
                ),
                ListTile(
                  title: const Text('Aspect Ratio'),
                  trailing: DropdownButton<AppAspectRatio>(
                    value: settings.aspectRatio,
                    items: const [
                      DropdownMenuItem(value: AppAspectRatio.widescreen, child: Text('16:9')),
                      DropdownMenuItem(value: AppAspectRatio.vertical, child: Text('9:16')),
                      DropdownMenuItem(value: AppAspectRatio.square, child: Text('1:1')),
                    ],
                    onChanged: (v) => notifier.setAspectRatio(v!),
                  ),
                ),
                SwitchListTile(
                  title: const Text('Watermark'),
                  value: settings.watermarkEnabled,
                  onChanged: notifier.toggleWatermark,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeader('Modes'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Christian Mode'),
                  subtitle: const Text('Recognizes biblical references and adjusts visuals'),
                  value: settings.christianMode,
                  onChanged: notifier.toggleChristianMode,
                ),
                SwitchListTile(
                  title: const Text('Developer Mode'),
                  subtitle: const Text('Show raw AI prompts for each scene'),
                  value: settings.developerMode,
                  onChanged: notifier.toggleDeveloperMode,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white70)),
    );
  }
}

class _ApiKeyTile extends StatefulWidget {
  final VideoProviderType type;
  final AppSettings settings;
  final SettingsNotifier notifier;

  const _ApiKeyTile({required this.type, required this.settings, required this.notifier});

  @override
  State<_ApiKeyTile> createState() => _ApiKeyTileState();
}

class _ApiKeyTileState extends State<_ApiKeyTile> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.settings.apiKeys[widget.type] ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.type.label),
      subtitle: TextField(
        controller: _controller,
        obscureText: true,
        decoration: const InputDecoration(hintText: 'API key', isDense: true),
        onSubmitted: (v) => widget.notifier.setApiKey(widget.type, v),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.save_outlined),
        onPressed: () => widget.notifier.setApiKey(widget.type, _controller.text),
      ),
    );
  }
}
