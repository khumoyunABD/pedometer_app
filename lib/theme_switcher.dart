// import 'package:flutter/material.dart';
// import 'package:adaptive_theme/adaptive_theme.dart';

// class ThemeSwitcher extends StatelessWidget {
//   const ThemeSwitcher({super.key});
//   @override
//   Widget build(BuildContext context) {
//     bool isDarkMode = AdaptiveThemeMode.system == AdaptiveThemeMode.light;
//     return IconButton(
//       icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
//       onPressed: () {
//         if (isDarkMode) {
//           AdaptiveTheme.of(context).setLight();
//         } else {
//           AdaptiveTheme.of(context).setDark();
//         }
//       },
//     );
//   }
// }
