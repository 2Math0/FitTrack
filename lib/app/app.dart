import 'package:fit_track/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class FitTrackApp extends StatelessWidget {
  const FitTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitTrack',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blueGrey,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
