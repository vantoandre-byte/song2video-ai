import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/project.dart';

/// Cloud project saving / project history, per the "Future Features" list.
class FirestoreService {
  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _projects(String uid) =>
      _db.collection('users').doc(uid).collection('projects');

  Future<void> saveProjectMeta(String uid, Project project) {
    return _projects(uid).doc(project.id).set({
      'title': project.title,
      'christianModeEnabled': project.christianModeEnabled,
      'createdAt': project.createdAt.toIso8601String(),
      'updatedAt': project.updatedAt.toIso8601String(),
      'sceneCount': project.scenes.length,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchProjects(String uid) {
    return _projects(uid).orderBy('updatedAt', descending: true).snapshots();
  }

  Future<void> deleteProject(String uid, String projectId) {
    return _projects(uid).doc(projectId).delete();
  }
}
