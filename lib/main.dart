import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 👈 1. रिवरपॉड इम्पोर्ट किया
import 'package:tao_boost/core/routes/app_router.dart';

void main() {
  runApp(
    // 👈 2. पूरी ऐप को ProviderScope के अंदर डाल दिया भाई
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
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      routerConfig: appRouter, // हमारा पुराना गो-राउटर
    );
  }
}