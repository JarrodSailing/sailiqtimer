import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'timer_provider.dart';

class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  late final timerService = ref.read(timerServiceProvider);
  int _selectedSeconds = 600; // default to 10 min

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SailIQ Timer')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<int>(
            stream: timerService.timerStream,
            builder: (context, snapshot) {
              final remaining = snapshot.data ?? _selectedSeconds;
              final minutes = remaining ~/ 60;
              final seconds = remaining % 60;

              return Text(
                '$minutes:${seconds.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => setState(() => _selectedSeconds = 600),
                child: const Text('10 min'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => setState(() => _selectedSeconds = 300),
                child: const Text('5 min'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => setState(() => _selectedSeconds = 60),
                child: const Text('1 min'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => timerService.start(_selectedSeconds),
                child: const Text('Start'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => timerService.reset(),
                child: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
