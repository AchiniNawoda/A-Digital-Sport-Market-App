import 'package:dspapp/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAiwJ_ms1HVwhbLD4kJ6Bbg_fq8VdxR5F0",
          appId: "1:148066986462:android:c16101c2b8f7365df1d54f",
          messagingSenderId: "148066986462",
          projectId: "digital-sport-market",
          storageBucket: "gs://digital-sport-market.appspot.com"),
    );
    runApp(const MyApp());
  } catch (e) {
    print('Firebase initialization error: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme myTextTheme = GoogleFonts.poppinsTextTheme(
      Theme.of(context).textTheme,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter ',
      theme: ThemeData(
        textTheme: myTextTheme,
        useMaterial3: true,
      ),
      home: WelcomePage(),
    );
  }
}
