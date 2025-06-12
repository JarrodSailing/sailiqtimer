import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/startline/startline_screen.dart';

class SailIQTimerApp extends ConsumerStatefulWidget {
  const SailIQTimerApp({super.key});

  @override
  ConsumerState<SailIQTimerApp> createState() => _SailIQTimerAppState();
}

class _SailIQTimerAppState extends ConsumerState<SailIQTimerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SailIQ Timer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const StartLineScreen(),
    );
  }
}