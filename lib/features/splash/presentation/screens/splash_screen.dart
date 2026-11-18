import 'package:flutter/material.dart';

/// The route the router holds on while the session restores. It shows
/// nothing itself: `SplashHost` (app.dart) draws the splash over it, and over
/// the first real screen while handing over.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold();
}
