import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?';
  int _steps = 0;
  int _initialSteps = 0;
  int _savedSteps = 0;
  bool _isCounting = true;
  int _totalStepsToday = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _loadTotalSteps();
  }

  Future<void> _loadTotalSteps() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final lastSavedDate = prefs.getString('last_saved_date') ?? '';
    if (lastSavedDate != now.toIso8601String().substring(0, 10)) {
      await prefs.setInt('total_steps', 0);
      await prefs.setString(
          'last_saved_date', now.toIso8601String().substring(0, 10));
    }
    setState(() {
      _totalStepsToday = prefs.getInt('total_steps') ?? 0;
    });
  }

  Future<void> _saveTotalSteps(int steps) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('total_steps', steps);
  }

  void onStepCount(StepCount event) {
    print(event);
    if (_isCounting) {
      setState(() {
        if (_initialSteps == 0) {
          _initialSteps = event.steps;
        }
        _steps = _savedSteps + (event.steps - _initialSteps);
        _totalStepsToday += _steps;
        _saveTotalSteps(_totalStepsToday);
      });
    }
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = -1;
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  void toggleCounting() {
    setState(() {
      if (_isCounting) {
        _savedSteps = _steps; // Save the steps when stopping
      } else {
        _initialSteps = 0; // Reset the initial steps when resuming
      }
      _isCounting = !_isCounting;
    });
  }

  void resetSteps() {
    setState(() {
      _steps = 0;
      _initialSteps = 0;
      _savedSteps = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pedometer Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Steps Taken',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                _steps == -1 ? 'Step count not available' : _steps.toString(),
                style: const TextStyle(fontSize: 30, color: Colors.green),
              ),
              const Divider(
                height: 100,
                thickness: 0,
                color: Colors.white,
              ),
              const Text(
                'Total Steps Today',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                _totalStepsToday.toString(),
                style: const TextStyle(fontSize: 30, color: Colors.blue),
              ),
              const Divider(
                height: 100,
                thickness: 0,
                color: Colors.white,
              ),
              const Text(
                'Pedestrian Status',
                style: TextStyle(fontSize: 30),
              ),
              Icon(
                _status == 'walking'
                    ? Icons.directions_walk
                    : _status == 'stopped'
                        ? Icons.accessibility_new
                        : Icons.error,
                size: 100,
              ),
              Center(
                child: Text(
                  _status,
                  style: _status == 'walking' || _status == 'stopped'
                      ? const TextStyle(fontSize: 30)
                      : const TextStyle(fontSize: 20, color: Colors.red),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: toggleCounting,
                child: Text(_isCounting ? 'Stop Counting' : 'Start Counting'),
              ),
              ElevatedButton(
                onPressed: resetSteps,
                child: const Text('Reset Steps'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
