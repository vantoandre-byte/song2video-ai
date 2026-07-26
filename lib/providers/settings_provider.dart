import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final providerName = prefs.getString('videoProvider');
    if (providerName != null) {
      final match = VideoProviderType.values.where((e) => e.name == providerName);
      if (match.isNotEmpty) {
        state = state.copyWith(videoProvider: match.first);
      }
    }
    state = state.copyWith(
      developerMode: prefs.getBool('developerMode') ?? false,
      christianMode: prefs.getBool('christianMode') ?? false,
      watermarkEnabled: prefs.getBool('watermarkEnabled') ?? true,
      darkMode: prefs.getBool('darkMode') ?? true,
    );
  }

  Future<void> setProvider(VideoProviderType type) async {
    state = state.copyWith(videoProvider: type);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('videoProvider', type.name);
  }

  Future<void> setApiKey(VideoProviderType type, String key) async {
    final updated = Map<VideoProviderType, String>.from(state.apiKeys)..[type] = key;
    state = state.copyWith(apiKeys: updated);
    // NOTE: for production, store API keys in secure storage
    // (flutter_secure_storage) rather than SharedPreferences.
  }

  Future<void> toggleDeveloperMode(bool value) async {
    state = state.copyWith(developerMode: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('developerMode', value);
  }

  Future<void> toggleChristianMode(bool value) async {
    state = state.copyWith(christianMode: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('christianMode', value);
  }

  Future<void> toggleWatermark(bool value) async {
    state = state.copyWith(watermarkEnabled: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('watermarkEnabled', value);
  }

  Future<void> setResolution(AppResolution res) async {
    state = state.copyWith(resolution: res);
  }

  Future<void> setAspectRatio(AppAspectRatio ratio) async {
    state = state.copyWith(aspectRatio: ratio);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) => SettingsNotifier(),
);
