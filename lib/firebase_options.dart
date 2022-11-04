// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAh_83UTULG9VEH_aCdvWa78yX4pCKq2BU',
    appId: '1:611481013011:web:f09b4c497671d939df28e6',
    messagingSenderId: '611481013011',
    projectId: 'meditrack-93726',
    authDomain: 'meditrack-93726.firebaseapp.com',
    storageBucket: 'meditrack-93726.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB_VlwaaS3_DrlwQ43VZP--bJVd0rcLjcg',
    appId: '1:611481013011:android:a6d3b227fc346e9ddf28e6',
    messagingSenderId: '611481013011',
    projectId: 'meditrack-93726',
    storageBucket: 'meditrack-93726.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC3Fb4ZkQd5HWfP2DdROlKZYwJ8hnfSgpE',
    appId: '1:611481013011:ios:e9a24e31f6bc162adf28e6',
    messagingSenderId: '611481013011',
    projectId: 'meditrack-93726',
    storageBucket: 'meditrack-93726.appspot.com',
    iosClientId: '611481013011-p8ujl7chm94iedjus776hahuvm4hco21.apps.googleusercontent.com',
    iosBundleId: 'com.jafar.mediTrack',
  );
}