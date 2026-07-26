// Auto-generated from google-services.json for the song2video-ai
// Firebase project. iOS values are placeholders until an iOS app is
// registered in Firebase.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for this platform.');
    }
  }

  static const android = FirebaseOptions(
    apiKey: 'AIzaSyCFkprjlNGNySJ1AszDUI8zAIhVcsVRM9s',
    appId: '1:597612192038:android:ffd2cecc2eedb73b2761e7',
    messagingSenderId: '597612192038',
    projectId: 'song2video-ai',
    storageBucket: 'song2video-ai.firebasestorage.app',
  );

  static const ios = FirebaseOptions(
    apiKey: 'REPLACE_WHEN_IOS_APP_REGISTERED',
    appId: 'REPLACE_WHEN_IOS_APP_REGISTERED',
    messagingSenderId: '597612192038',
    projectId: 'song2video-ai',
    storageBucket: 'song2video-ai.firebasestorage.app',
    iosBundleId: 'REPLACE_WHEN_IOS_APP_REGISTERED',
  );
}
