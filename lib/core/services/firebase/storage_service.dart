import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Handles uploads of source audio, reference images, and final exports.
class StorageService {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadAudio(String uid, String projectId, File file) async {
    final ref = _storage.ref('users/$uid/projects/$projectId/audio/${file.uri.pathSegments.last}');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }

  Future<String> uploadReferenceImage(String uid, String projectId, File file, int index) async {
    final ref = _storage.ref('users/$uid/projects/$projectId/images/ref_$index.jpg');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }

  Future<String> uploadFinalExport(String uid, String projectId, File file) async {
    final ref = _storage.ref('users/$uid/projects/$projectId/exports/${DateTime.now().millisecondsSinceEpoch}.mp4');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }
}
