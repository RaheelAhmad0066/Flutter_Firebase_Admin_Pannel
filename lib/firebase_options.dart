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
    apiKey: 'AIzaSyCaXEGM-YJwuptvdC9c_-fwsHiB57agjes',
    appId: '1:771713231928:web:b1d4c55d21fb153a924acd',
    messagingSenderId: '771713231928',
    projectId: 'multitesting-26a7d',
    authDomain: 'multitesting-26a7d.firebaseapp.com',
    databaseURL: 'https://multitesting-26a7d-default-rtdb.firebaseio.com',
    storageBucket: 'multitesting-26a7d.appspot.com',
    measurementId: 'G-252YJ57131',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAY3dVFoYxryqwssHuCxI5NMSJwkCNplNo',
    appId: '1:771713231928:android:6b503e20905d9f71924acd',
    messagingSenderId: '771713231928',
    projectId: 'multitesting-26a7d',
    databaseURL: 'https://multitesting-26a7d-default-rtdb.firebaseio.com',
    storageBucket: 'multitesting-26a7d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCvJ3XjE6PBc0QkPRlaCWCxXPPkvb_7m3M',
    appId: '1:771713231928:ios:25398f459dd62faf924acd',
    messagingSenderId: '771713231928',
    projectId: 'multitesting-26a7d',
    databaseURL: 'https://multitesting-26a7d-default-rtdb.firebaseio.com',
    storageBucket: 'multitesting-26a7d.appspot.com',
    iosClientId: '771713231928-mpmcecv1nresdv2gauc97gc2tntuek73.apps.googleusercontent.com',
    iosBundleId: 'com.example.pannel',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCvJ3XjE6PBc0QkPRlaCWCxXPPkvb_7m3M',
    appId: '1:771713231928:ios:25398f459dd62faf924acd',
    messagingSenderId: '771713231928',
    projectId: 'multitesting-26a7d',
    databaseURL: 'https://multitesting-26a7d-default-rtdb.firebaseio.com',
    storageBucket: 'multitesting-26a7d.appspot.com',
    iosClientId: '771713231928-mpmcecv1nresdv2gauc97gc2tntuek73.apps.googleusercontent.com',
    iosBundleId: 'com.example.pannel',
  );
}
