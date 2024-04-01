// ignore_for_file: lines_longer_than_80_chars

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class PlatformOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for fuchsia - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCUwI4_oIZpBUkD7cm1Cshz4bYWL_wLl8s',
    appId: '1:122234726727:android:6ccbc67c86d65d0f484462',
    messagingSenderId: '122234726727',
    projectId: 'qrinnovations-d0b5c',
    storageBucket: 'qrinnovations-d0b5c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAhKnQel8LpCei-H5WgZBoUTrZPckoFZjM',
    appId: '1:122234726727:ios:03dbb429c152537f484462',
    messagingSenderId: '122234726727',
    projectId: 'qrinnovations-d0b5c',
    storageBucket: 'qrinnovations-d0b5c.appspot.com',
    iosClientId:
        '122234726727-89dsfhhs9nac9dnovfgchh2s8bmlchf9.apps.googleusercontent.com',
    iosBundleId: 'com.example.qrInnovations',
  );
}
