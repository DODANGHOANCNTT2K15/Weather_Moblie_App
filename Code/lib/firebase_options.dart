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
        return macos;
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
    apiKey: 'AIzaSyDXoqwFI9VdT0i-x8GepAQrz8s5jCRdOYE',
    appId: '1:913904309933:web:921a41134a1fd784879824',
    messagingSenderId: '913904309933',
    projectId: 'weatherfirebase-f4c61',
    authDomain: 'weatherfirebase-f4c61.firebaseapp.com',
    storageBucket: 'weatherfirebase-f4c61.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBAKEZQ6YaRUEC3aELSMEvUZwZhFiefG_o',
    appId: '1:913904309933:android:25b1c0dca871d0e9879824',
    messagingSenderId: '913904309933',
    projectId: 'weatherfirebase-f4c61',
    storageBucket: 'weatherfirebase-f4c61.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAM62zORFfXyxg3WNpyUlnHWVEAc5roIDk',
    appId: '1:913904309933:ios:826a6ef1a0882015879824',
    messagingSenderId: '913904309933',
    projectId: 'weatherfirebase-f4c61',
    storageBucket: 'weatherfirebase-f4c61.appspot.com',
    iosBundleId: 'com.example.ualo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAM62zORFfXyxg3WNpyUlnHWVEAc5roIDk',
    appId: '1:913904309933:ios:036334332000d039879824',
    messagingSenderId: '913904309933',
    projectId: 'weatherfirebase-f4c61',
    storageBucket: 'weatherfirebase-f4c61.appspot.com',
    iosBundleId: 'com.example.ualo.RunnerTests',
  );
}
