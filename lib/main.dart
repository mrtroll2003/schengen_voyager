import 'package:flutter/material.dart';
import 'package:schengen_voyager/screens/trip_planner_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Needed for async main
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schengen Trip Planner',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, // Base color
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
        fontFamily: 'Roboto', // Example font, choose one you like
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 3,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        )
      ),
      home: const TripPlannerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}