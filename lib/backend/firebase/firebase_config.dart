import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAj-Fv2mz_bDpBLqYAbyTm2lqq4FVBJNdw",
            authDomain: "marketplace-treads-soci-612o7d.firebaseapp.com",
            projectId: "marketplace-treads-soci-612o7d",
            storageBucket: "marketplace-treads-soci-612o7d.appspot.com",
            messagingSenderId: "538379106091",
            appId: "1:538379106091:web:5fbf874bcc903bc8c1376e"));
  } else {
    await Firebase.initializeApp();
  }
}
