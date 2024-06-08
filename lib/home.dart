import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pedometer/pedometer.dart';
import 'package:pedometer_app/theme_switcher.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:restart_app/restart_app.dart';

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
    _checkPermission();
    _loadTotalSteps();
    _loadDailyGoal();
    _loadWalkingDuration();
  }

  //checking permissions
  Future<void> _checkPermission() async {
    if (await Permission.activityRecognition.isGranted) {
      // Permission is granted
    } else {
      // Permission is not granted, request permission
      PermissionStatus status = await Permission.activityRecognition.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        // Permission is denied or permanently denied, prompt to go to settings
        _showSettingsDialog();
      } else if (status.isGranted) {
        // Permission is granted after request, restart the app
        Restart.restartApp();
      }
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Required'),
          content: const Text(
              'This app requires permission to access physical activity. Please enable it in the settings.'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await openAppSet();
              },
              child: const Text('Go to Settings'),
            ),
          ],
        );
      },
    );
  }

  Future<void> openAppSet() async {
    if (await Permission.activityRecognition.isPermanentlyDenied) {
      openAppSettings();
    } else {
      await Permission.activityRecognition.request();
      if (await Permission.activityRecognition.isGranted) {
        Restart.restartApp();
      }
    }
  }

  // Future<void> openAppSettings() async {
  //   if (await canLaunch('app-settings:')) {
  //     await launch('app-settings:');
  //   } else {
  //     print('Could not open settings');
  //   }
  // }

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
    int minutes = ((_walkingDuration % 3600) / 60).ceil();
    double caloriesBurned = _totalStepsTodayFinal * 0.04;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      // appBar: AppBar(
      // backgroundColor: Theme.of(context).colorScheme.surface,
      // title: const Text('Pedometer'),
      // centerTitle: true,
      // actions: [
      // IconButton(
      //   onPressed: () {},
      //   icon: const Icon(Icons.dark_mode),
      // ),
      //ThemeSwitcher(),
      //],
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      'Today',
                      style: TextStyle(
                          fontSize: 30,
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      _steps == -1
                          ? 'Not available'
                          : _totalStepsTodayFinal.toString(),
                      style: TextStyle(
                          fontSize: 60,
                          color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(
                      bottom: 10,
                      right: 15,
                    ),
                    child: Text(
                        _dailyGoal == 2500 ? 'Daily average' : 'Your goal'),
                  ),
                  LinearPercentIndicator(
                    lineHeight: 30.0,
                    percent: progress > 1.0
                        ? 1.0
                        : progress, // Ensure it doesn't exceed 100%

                    center: Text(
                      '$_totalStepsTodayFinal / $_dailyGoal',
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    barRadius: const Radius.circular(10),
                    //linearStrokeCap: LinearStrokeCap.roundAll,
                    backgroundColor: Colors.grey,
                    progressColor: Colors.blue,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Divider(
                    height: 30,
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
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${hours}h ${minutes}m',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const Text(
                            'Min',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            caloriesBurned.toStringAsFixed(2),
                            style: const TextStyle(fontSize: 20),
                          ),
                          const Text(
                            'Kcal',
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
                    height: 10,
                  ),
                  Divider(
                    height: 40,
                    thickness: 5,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const Row(
                    children: [
                      Icon(
                        Icons.track_changes_outlined,
                        size: 22,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Set a daily goal',
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Those who set specific goals are 10 times more likely to achieve their desired outcomes.',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple),
                      onPressed: _showGoalDialog,
                      child: Text(
                        'Set Daily Goal',
                        style: TextStyle(color: Colors.grey.shade200),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleCounting,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        child: Icon(
          _isCounting ? Icons.pause : Icons.play_arrow,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        // Adjust the size of the button if needed
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 50,
        //color: Colors.purple.shade200,
        color: Theme.of(context).colorScheme.outlineVariant,
        //shadowColor: Colors.purpleAccent,
        shape: const CircularNotchedRectangle(),
        //shape: const ,
        notchMargin: 12.0,
        child: Container(
          height: 20.0,
        ),
      ),
    );
  }
}
