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
    apiKey: 'AIzaSyCOsFUFDSYk4IhEXxjTJ-wUCXp40G5V1Yw',
    appId: '1:427516758522:web:7fe65cf41d42b760127c43',
    messagingSenderId: '427516758522',
    projectId: 'offside-d1a25',
    authDomain: 'offside-d1a25.firebaseapp.com',
    storageBucket: 'offside-d1a25.appspot.com',
    measurementId: 'G-JWSH3ZPQ2R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCcZipES5kZ9pdjDKSVuzkwfa7XQ5NWReA',
    appId: '1:427516758522:android:f46df06bcf7768b5127c43',
    messagingSenderId: '427516758522',
    projectId: 'offside-d1a25',
    storageBucket: 'offside-d1a25.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBVA2fSAjDxJ9WxKxVkoPozG_fcmKTLCHs',
    appId: '1:427516758522:ios:c3f5b298e79849ee127c43',
    messagingSenderId: '427516758522',
    projectId: 'offside-d1a25',
    storageBucket: 'offside-d1a25.appspot.com',
    iosClientId: '427516758522-n9lnsbroa8ccjbrns3h8a9o66ghj59pt.apps.googleusercontent.com',
    iosBundleId: 'com.example.offside',
  );
}