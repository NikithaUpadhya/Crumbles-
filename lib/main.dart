import 'package:crumbles/app.dart';
import 'package:crumbles/data/repositories/authencation/authentication_repo.dart';
import 'package:crumbles/features/authentication/screens/chatbot/const.dart';
import 'package:crumbles/firebase/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  // widgets binding
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((FirebaseApp value) => Get.put(AuthenticationRepository()));

  Gemini.init(
    apiKey: GEMINI_API_KEY,
  );

  // init local storage
  await GetStorage.init();

  // await rect splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Log all documents and their fields in users collection
  print('Fetching all documents in users collection:');
  await FirebaseFirestore.instance.collection('users').get().then((querySnapshot) {
    if (querySnapshot.docs.isEmpty) {
      print('No documents found in users collection.');
    } else {
      for (var doc in querySnapshot.docs) {
        print('Document ID: ${doc.id}, Data: ${doc.data()}');
      }
    }
  });

  // initialization of Authentication
  runApp(const App());
}
