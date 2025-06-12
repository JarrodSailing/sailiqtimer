import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/timer/timer_screen.dart';
import 'features/startline/startline_screen.dart';

class SailIQTimerApp extends ConsumerStatefulWidget {
  const SailIQTimerApp({super.key});

  @override
  ConsumerState<SailIQTimerApp> createState() => _SailIQTimerAppState();
}

class _SailIQTimerAppState extends ConsumerState<SailIQTimerApp> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    TimerScreen(),
    StartLineScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SailIQ Timer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Timer'),
            BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Start Line'),
          ],
        ),
      ),
    );
  }
}
