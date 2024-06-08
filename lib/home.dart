import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pedometer/pedometer.dart';
import 'package:percent_indicator/percent_indicator.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?';
  int _steps = 0;
  int _initialSteps = 0;
  int _savedSteps = 0;
  bool _isCounting = true;
  int _totalStepsToday = 0;
  int _totalStepsTodayFinal = 0;
  int _dailyGoal = 2500; // Default goal
  double _distanceInKm = 0.0;
  int _walkingDuration = 0; // Duration in seconds
  Timer? _timer;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _loadTotalSteps();
    _loadDailyGoal();
    _loadWalkingDuration();
  }

  Future<void> _loadTotalSteps() async {
    final now = DateTime.now();
    final lastSavedDate = box.read('last_saved_date') ?? '';
    if (lastSavedDate != now.toIso8601String().substring(0, 10)) {
      await box.write('total_steps', 0);
      await box.write(
          'last_saved_date', now.toIso8601String().substring(0, 10));
      await box.write('walking_duration', 0);
    }
    setState(() {
      _totalStepsToday = box.read('total_steps') ?? 0;
      _walkingDuration = box.read('walking_duration') ?? 0;
    });
  }

  Future<void> _saveTotalSteps(int steps) async {
    await box.write('total_steps', steps);
  }

  Future<void> _loadDailyGoal() async {
    setState(() {
      _dailyGoal = box.read('daily_goal') ?? 2500; // Default to 10,000 steps
    });
  }

  Future<void> _saveDailyGoal(int goal) async {
    await box.write('daily_goal', goal);
    setState(() {
      _dailyGoal = goal;
    });
  }

  Future<void> _saveWalkingDuration(int duration) async {
    await box.write('walking_duration', duration);
  }

  Future<void> _loadWalkingDuration() async {
    setState(() {
      _walkingDuration = box.read('walking_duration') ?? 0;
    });
  }

  void onStepCount(StepCount event) {
    //print(event);
    if (_isCounting) {
      setState(() {
        if (_initialSteps == 0) {
          _initialSteps = event.steps;
        }
        _steps = _savedSteps + (event.steps - _initialSteps);
        _totalStepsTodayFinal = _totalStepsToday + _steps;
        _saveTotalSteps(_totalStepsTodayFinal);

        // Update distance walked
        _distanceInKm = _totalStepsTodayFinal *
            0.0008; // Assuming average step length of 0.8 meters
      });
    }
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    //print(event);
    setState(() {
      _status = event.status;
      if (_status == 'walking' && _isCounting) {
        _startTimer();
      } else {
        _stopTimer();
      }
    });
  }

  void onPedestrianStatusError(error) {
    //print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    //print(_status);
  }

  void onStepCountError(error) {
    //print('onStepCountError: $error');
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
        _stopTimer();
      } else {
        _initialSteps = 0; // Reset the initial steps when resuming
        if (_status == 'walking') {
          _startTimer();
        }
      }
      _isCounting = !_isCounting;
    });
  }

  void resetSteps() {
    setState(() {
      _steps = 0;
      _initialSteps = 0;
      _savedSteps = 0;
      _totalStepsToday = 0;
      _totalStepsTodayFinal = 0;
      _distanceInKm = 0.0;
      _walkingDuration = 0;
      _stopTimer();
      _saveTotalSteps(0);
      _saveWalkingDuration(0);
    });
  }

  void _startTimer() {
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        setState(() {
          _walkingDuration++;
          _saveWalkingDuration(_walkingDuration);
        });
      });
    }
  }

  void _stopTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
  }

  void _showGoalDialog() {
    TextEditingController goalController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Daily Step Goal'),
          content: TextField(
            controller: goalController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Enter your goal"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                int goal = int.parse(goalController.text);
                _saveDailyGoal(goal);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = _totalStepsTodayFinal / _dailyGoal;
    int hours = (_walkingDuration / 3600).floor();
    int minutes = ((_walkingDuration % 3600) / 60).floor();
    return Scaffold(
      // appBar: AppBar(
      // backgroundColor: Theme.of(context).colorScheme.surface,
      // title: const Text('Pedometer'),
      // centerTitle: true,
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 20,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // const Text(
                  //   'Steps Taken',
                  //   style: TextStyle(fontSize: 30),
                  // ),
                  // Text(
                  //   _steps == -1 ? 'Step count not available' : _steps.toString(),
                  //   style: const TextStyle(fontSize: 30, color: Colors.green),
                  // ),
                  // const Divider(
                  //   height: 100,
                  //   thickness: 0,
                  //   color: Colors.white,
                  // ),

                  //Total steps for the day
                  // const Text(
                  //   'Total Steps Today',
                  //   style: TextStyle(fontSize: 30),
                  // ),
                  const Text(
                    'Today',
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    _totalStepsTodayFinal.toString(),
                    style: const TextStyle(fontSize: 30, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  LinearPercentIndicator(
                    lineHeight: 30.0,
                    percent: progress > 1.0
                        ? 1.0
                        : progress, // Ensure it doesn't exceed 100%
                    // center: Text(
                    //   '${(progress * 100).toStringAsFixed(1)}%',
                    //   style: const TextStyle(fontSize: 20.0),
                    // ),
                    center: Text(
                      '$_totalStepsTodayFinal / $_dailyGoal',
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    barRadius: const Radius.circular(10),
                    //linearStrokeCap: LinearStrokeCap.roundAll,
                    backgroundColor: Colors.grey,
                    progressColor: Colors.blue,
                  ),
                  Divider(
                    height: 100,
                    thickness: 5,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const Row(
                    children: [
                      Icon(
                        Icons.directions_walk,
                        size: 22,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Exercise',
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            '$hours $minutes',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const Text(
                            'H m',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      // Column(
                      //   children: [
                      //     Text(
                      //       minutes.toString(),
                      //       style: const TextStyle(fontSize: 20),
                      //     ),
                      //     const Text(
                      //       'Minutes',
                      //       style: TextStyle(fontSize: 15),
                      //     ),
                      //   ],
                      // ),
                      Column(
                        children: [
                          Text(
                            _distanceInKm.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 20),
                          ),
                          const Text(
                            'Kl',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            _distanceInKm.toStringAsFixed(2),
                            style: const TextStyle(fontSize: 20),
                          ),
                          const Text(
                            'Km',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Distance Walked (km)',
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    _distanceInKm.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 30, color: Colors.blue),
                  ),
                  const Divider(
                    height: 100,
                    thickness: 0,
                    color: Colors.white,
                  ),
                  const Text(
                    'Time Spent Walking',
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    '${(_walkingDuration / 60).floor()} min ${_walkingDuration % 60} sec',
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
                    child:
                        Text(_isCounting ? 'Stop Counting' : 'Start Counting'),
                  ),
                  ElevatedButton(
                    onPressed: resetSteps,
                    child: const Text('Reset Steps'),
                  ),
                  ElevatedButton(
                    onPressed: _showGoalDialog,
                    child: const Text('Set Daily Goal'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Daily Goal Progress',
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
