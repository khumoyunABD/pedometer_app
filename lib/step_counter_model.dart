import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class StepCounterModel extends ChangeNotifier {
  int _steps = 0;
  double _distanceInKm = 0.0;
  int _goal = 0;
  bool _isRunning = false;
  final double _stepLength = 0.0008; // Average step length in kilometers
  final Stopwatch _stopwatch = Stopwatch();

  StepCounterModel() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      // Step counting logic (this is a simple example, you need to implement actual step detection logic)
      if (_isRunning && _detectStep(event)) {
        _steps++;
        _distanceInKm += _stepLength;
        notifyListeners();
      }
    });
  }

  bool _detectStep(AccelerometerEvent event) {
    // Simplified step detection logic
    // Replace with actual step detection algorithm
    return event.x > 12.0;
  }

  int get steps => _steps;
  double get distanceInKm => _distanceInKm;
  double get progress => _goal > 0 ? _steps / _goal : 0.0;
  int get stepsLeft => _goal - _steps;
  bool get isRunning => _isRunning;
  int get totalTimeSpent => _stopwatch.elapsed.inMinutes;

  void setGoal(int goal) {
    _goal = goal;
    notifyListeners();
  }

  void toggleStepCounter() {
    if (_isRunning) {
      _stopwatch.stop();
    } else {
      _stopwatch.start();
    }
    _isRunning = !_isRunning;
    notifyListeners();
  }
}
