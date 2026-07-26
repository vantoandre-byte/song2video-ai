// Placeholder Firebase options file.
//
// Generate the real version with the FlutterFire CLI:
//   dart pub global activate flutterfire_cli
//   flutterfire configure
//
// That command creates this file automatically, wired to your actual
// Firebase project (Android + iOS app IDs, API keys, etc).

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
    apiKey: 'REPLACE_WITH_FLUTTERFIRE_CONFIGURE_OUTPUT',
    appId: 'REPLACE_WITH_FLUTTERFIRE_CONFIGURE_OUTPUT',
    messagingSenderId: 'REPLACE_WITH_FLUTTERFIRE_CONFIGURE_OUTPUT',
    projectId: 'REPLACE_WITH_FLUTTERFIRE_CONFIGURE_OUTPUT',
    storageBucket: 'REPLACE_WITH_FLUTTERFIRE_CONFIGURE_OUTPUT',
  );

  static const ios = FirebaseOptions(
    apiKey: 'REPLACE_WITH_FLUTTERFIRE_CONFIGURE_OUTPUT',
    appId: 'REPLACE_WITH_FLUTTERFIRE_CONFIGURE_OUTPUT',
    messagingSenderId: 'REPLACE_WITH_FLUTTERFIRE_CONFIGURE_OUTPUT',
    projectId: 'REPLACE_WITH_FLUTTERFIRE_CONFIGURE_OUTPUT',
    storageBucket: 'REPLACE_WITH_FLUTTERFIRE_CONFIGURE_OUTPUT',
    iosBundleId: 'REPLACE_WITH_FLUTTERFIRE_CONFIGURE_OUTPUT',
  );
}
