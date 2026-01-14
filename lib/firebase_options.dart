// File generated using FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyCbY8FzNfHiQprsZZgx9gD1pYM8v3Efvfw',
    appId: '1:781020799222:web:00a91ffae8c304e4a9ccd7',
    messagingSenderId: '781020799222',
    projectId: 'smartphone-rec',
    authDomain: 'smartphone-rec.firebaseapp.com',
    storageBucket: 'smartphone-rec.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCbY8FzNfHiQprsZZgx9gD1pYM8v3Efvfw',
    appId: '1:781020799222:android:00a91ffae8c304e4a9ccd7',
    messagingSenderId: '781020799222',
    projectId: 'smartphone-rec',
    storageBucket: 'smartphone-rec.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCbY8FzNfHiQprsZZgx9gD1pYM8v3Efvfw',
    appId: '1:781020799222:ios:00a91ffae8c304e4a9ccd7',
    messagingSenderId: '781020799222',
    projectId: 'smartphone-rec',
    storageBucket: 'smartphone-rec.firebasestorage.app',
    iosBundleId: 'com.example.myapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCbY8FzNfHiQprsZZgx9gD1pYM8v3Efvfw',
    appId: '1:781020799222:macos:00a91ffae8c304e4a9ccd7',
    messagingSenderId: '781020799222',
    projectId: 'smartphone-rec',
    storageBucket: 'smartphone-rec.firebasestorage.app',
    iosBundleId: 'com.example.myapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCbY8FzNfHiQprsZZgx9gD1pYM8v3Efvfw',
    appId: '1:781020799222:windows:00a91ffae8c304e4a9ccd7',
    messagingSenderId: '781020799222',
    projectId: 'smartphone-rec',
    storageBucket: 'smartphone-rec.firebasestorage.app',
  );
}
