import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_app/ui/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      // data ambil dari file google-services.json
      apiKey: 'AIzaSyDMzk9857dkCWrzPHGaxwKDanBV3GofUE4', // current_key
      appId: '1:243811762198:android:c141e381bd64f228d07537', // mobilesdk_app_id 
      messagingSenderId: '243811762198', // project_number 
      projectId: 'test-app-eeadf' // project_id
    ),
  );
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        cardTheme: CardTheme(surfaceTintColor: Colors.white),
        dialogTheme: DialogTheme(surfaceTintColor: Colors.white, backgroundColor: Colors.white),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true
      ),
      home: const HomeScreen(),
    );
  }
}