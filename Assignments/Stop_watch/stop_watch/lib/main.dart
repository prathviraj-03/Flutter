import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const StopWatchApp());

class StopWatchApp extends StatelessWidget {
  const StopWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stopwatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      home: const StopWatchScreen(),
    );
  }
}

class StopWatchScreen extends StatefulWidget {
  const StopWatchScreen({super.key});

  @override
  State<StopWatchScreen> createState() => _StopWatchScreenState();
}

class _StopWatchScreenState extends State<StopWatchScreen> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  String _displayTime = "00:00:00";
  List<String> _laps = [];

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_stopwatch.isRunning) {
        setState(() {
          _displayTime = _formatDuration(_stopwatch.elapsed);
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final millis = twoDigits((duration.inMilliseconds.remainder(1000)) ~/ 10);
    return "$minutes:$seconds:$millis";
  }

  void _startStop() {
    setState(() {
      if (_stopwatch.isRunning) {
        _stopwatch.stop();
      } else {
        _stopwatch.start();
      }
    });
  }

  void _reset() {
    setState(() {
      _stopwatch.reset();
      _displayTime = "00:00:00";
      _laps.clear();
    });
  }

  void _lap() {
    setState(() {
      _laps.insert(0, _displayTime);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  Widget _buildButton(String text, IconData icon, VoidCallback onPressed,
      {Color? color}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        backgroundColor: color ?? Colors.deepPurple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Center(
              child: Text(
                _displayTime,
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildButton(
                  _stopwatch.isRunning ? "Pause" : "Start",
                  _stopwatch.isRunning ? Icons.pause : Icons.play_arrow,
                  _startStop,
                  color: _stopwatch.isRunning ? Colors.orange : Colors.green,
                ),
                _buildButton("Lap", Icons.flag, _lap),
                _buildButton("Reset", Icons.refresh, _reset, color: Colors.red),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: _laps.isEmpty
                  ? const Center(child: Text("No laps recorded"))
                  : ListView.builder(
                      itemCount: _laps.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple,
                            child: Text(
                              "${index + 1}",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text("Lap ${index + 1}"),
                          trailing: Text(_laps[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
