// File generated by FlutterFire CLI.
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
    apiKey: 'AIzaSyCBTBp5Qbp1UMPlcR8e2C-hbnMhdO1bf-c',
    appId: '1:401083242593:web:4654fba61841595f5ab220',
    messagingSenderId: '401083242593',
    projectId: 'soccerapp-38603',
    authDomain: 'soccerapp-38603.firebaseapp.com',
    storageBucket: 'soccerapp-38603.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB7gq58kzkF1nf9K_Hm0mZOE5fxsBKBSMk',
    appId: '1:401083242593:android:6f48888577b714035ab220',
    messagingSenderId: '401083242593',
    projectId: 'soccerapp-38603',
    storageBucket: 'soccerapp-38603.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBJFeGPug37neJ3RemmHOFbH_-slA4im78',
    appId: '1:401083242593:ios:fd9eaa3582bec3905ab220',
    messagingSenderId: '401083242593',
    projectId: 'soccerapp-38603',
    storageBucket: 'soccerapp-38603.appspot.com',
    iosBundleId: 'com.example.soccerApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBJFeGPug37neJ3RemmHOFbH_-slA4im78',
    appId: '1:401083242593:ios:fd9eaa3582bec3905ab220',
    messagingSenderId: '401083242593',
    projectId: 'soccerapp-38603',
    storageBucket: 'soccerapp-38603.appspot.com',
    iosBundleId: 'com.example.soccerApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCBTBp5Qbp1UMPlcR8e2C-hbnMhdO1bf-c',
    appId: '1:401083242593:web:44715aa79b16b76b5ab220',
    messagingSenderId: '401083242593',
    projectId: 'soccerapp-38603',
    authDomain: 'soccerapp-38603.firebaseapp.com',
    storageBucket: 'soccerapp-38603.appspot.com',
  );
}
