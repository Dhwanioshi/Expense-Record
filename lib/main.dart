import 'package:expense_record/screen/list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter/services.dart';

final kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 6, 57, 71),
);
void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [DeviceOrientation.portraitUp],
  // ).then((fn) {
  runApp(
    ProviderScope(
      child: MaterialApp(
        theme: ThemeData().copyWith(
          colorScheme: kColorScheme,
          appBarTheme: const AppBarTheme().copyWith(
              backgroundColor: kColorScheme.onPrimaryContainer,
              foregroundColor: kColorScheme.primaryContainer),
          cardTheme: CardThemeData(
            color: kColorScheme.secondaryContainer,
            margin: const EdgeInsets.symmetric(
              horizontal: 17,
              vertical: 10,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kColorScheme.onPrimary,
            ),
          ),
          textTheme: ThemeData().textTheme.copyWith(
                bodyMedium: TextStyle(
                  color: kColorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                  // fontSize: 15,
                ),
                bodySmall: TextStyle(
                  color: kColorScheme.primary,
                ),
              ),
          scaffoldBackgroundColor: kColorScheme.surface,
        ),
        home: const ListScreen(),
      ),
    ),
  );
  // });
}
