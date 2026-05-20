import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:firebase_core/firebase_core.dart'; 
import 'package:tao_boost/core/routes/app_router.dart';
import 'package:tao_boost/core/theme/app_theme.dart'; 
import 'package:flutter_web_plugins/url_strategy.dart'; // 👈 1. यह नया इम्पोर्ट जोड़ा भाई!

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ⚡ रिफ्रेश करने पर असर्शन एरर रोकने के लिए सेफचेक
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyB4Iv-ZSh4ZI6J9HswW41_taCqBRSUiXso",
        appId: "1:828180396932:web:10af9362e82832d8e7fbd1",
        messagingSenderId: "828180396932",
        projectId: "tao-boost-web",
        authDomain: "tao-boost-web.firebaseapp.com",
        storageBucket: "tao-boost-web.firebasestorage.app",
        measurementId: "G-0CB57X6L6F",
      ),
    );
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TAO BOOST',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, 
      routerConfig: appRouter, 
    );
  }
}