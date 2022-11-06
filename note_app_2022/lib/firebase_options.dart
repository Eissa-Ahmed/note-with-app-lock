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
    apiKey: 'AIzaSyCGqeRnU22fmHJBLhPvygxbbxkIg3CB4Bw',
    appId: '1:949679983221:web:2647ced52a8b077a22463c',
    messagingSenderId: '949679983221',
    projectId: 'note-app-4e235',
    authDomain: 'note-app-4e235.firebaseapp.com',
    storageBucket: 'note-app-4e235.appspot.com',
    measurementId: 'G-8M2XCN7Z48',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDKHff6OmpzH3mhLwVQPdg98Cz3RPVgV4M',
    appId: '1:949679983221:android:eb54fcbe9e1c925f22463c',
    messagingSenderId: '949679983221',
    projectId: 'note-app-4e235',
    storageBucket: 'note-app-4e235.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAlxwMIgeBiGDAQQMz240d3o9YXyjxAuM4',
    appId: '1:949679983221:ios:d3b95eece312d80822463c',
    messagingSenderId: '949679983221',
    projectId: 'note-app-4e235',
    storageBucket: 'note-app-4e235.appspot.com',
    iosClientId: '949679983221-d0gl4ugg85fdvaf6k35q6l8vfvfq4pi9.apps.googleusercontent.com',
    iosBundleId: 'com.example.noteApp2022',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAlxwMIgeBiGDAQQMz240d3o9YXyjxAuM4',
    appId: '1:949679983221:ios:d3b95eece312d80822463c',
    messagingSenderId: '949679983221',
    projectId: 'note-app-4e235',
    storageBucket: 'note-app-4e235.appspot.com',
    iosClientId: '949679983221-d0gl4ugg85fdvaf6k35q6l8vfvfq4pi9.apps.googleusercontent.com',
    iosBundleId: 'com.example.noteApp2022',
  );
}