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
    apiKey: 'AIzaSyBvOhwm2LlYW-ZM7V8yGuSPk1eihc2Kdd4',
    appId: '1:587688525593:web:02b6e74d3d50aebb5c4f88',
    messagingSenderId: '587688525593',
    projectId: 'gothic-agility-344213',
    authDomain: 'gothic-agility-344213.firebaseapp.com',
    storageBucket: 'gothic-agility-344213.appspot.com',
    measurementId: 'G-BXYDP17YJD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDlgRMrsC_LTR59ltNCmdf6z6VRJVyuH90',
    appId: '1:587688525593:android:3001df2783c495395c4f88',
    messagingSenderId: '587688525593',
    projectId: 'gothic-agility-344213',
    storageBucket: 'gothic-agility-344213.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA3SoyuE2laBbIw1Z8z7k43aBbg6D3yVgg',
    appId: '1:587688525593:ios:d9a0d74f99db21975c4f88',
    messagingSenderId: '587688525593',
    projectId: 'gothic-agility-344213',
    storageBucket: 'gothic-agility-344213.appspot.com',
    androidClientId: '587688525593-bn64n6lm8v5lnue4ikjr79iv68jqtilk.apps.googleusercontent.com',
    iosClientId: '587688525593-ha9k8069kg6asbe4lvkjt99bttsbbtsg.apps.googleusercontent.com',
    iosBundleId: 'com.company.fooma',
  );
}
