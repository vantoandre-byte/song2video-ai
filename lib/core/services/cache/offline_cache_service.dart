import 'package:hive_flutter/hive_flutter.dart';
import '../../../models/project.dart';

/// Local offline caching so a project survives app restarts / no connection,
/// synced to Firestore opportunistically when back online.
class OfflineCacheService {
  static const _boxName = 'projects_cache';

  Future<Box> _box() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  Future<void> cacheProjectDraft(String projectId, Map<String, dynamic> data) async {
    final box = await _box();
    await box.put(projectId, data);
  }

  Future<Map<String, dynamic>?> getCachedDraft(String projectId) async {
    final box = await _box();
    final data = box.get(projectId);
    return data == null ? null : Map<String, dynamic>.from(data);
  }

  Future<void> clearDraft(String projectId) async {
    final box = await _box();
    await box.delete(projectId);
  }
}
