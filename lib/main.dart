import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:get_storage/get_storage.dart';
import 'package:pedometer_app/home.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 102, 6, 247),
  surface: const Color.fromARGB(178, 229, 224, 236),
);

final theme = ThemeData().copyWith(
  scaffoldBackgroundColor: colorScheme.surface,
  colorScheme: colorScheme,
  textTheme: GoogleFonts.robotoSerifTextTheme().copyWith(
    titleSmall: GoogleFonts.robotoSerif(
      fontWeight: FontWeight.normal,
    ),
    titleMedium: GoogleFonts.robotoSerif(
      fontWeight: FontWeight.normal,
    ),
    titleLarge: GoogleFonts.robotoSerif(
      fontWeight: FontWeight.bold,
    ),
  ),
);

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light(useMaterial3: true),
      dark: ThemeData.dark(useMaterial3: true),
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        //title: 'Adaptive Theme Demo',
        theme: theme,
        darkTheme: darkTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
