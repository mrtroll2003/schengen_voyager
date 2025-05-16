import 'package:flutter/material.dart';
import 'package:schengen_voyager/screens/trip_planner_screen.dart';
import 'package:schengen_voyager/screens/about.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Needed for async main
  runApp(const MyApp());
}
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const TripPlannerScreen();
      },
      // Example for a future details page
      // routes: <RouteBase>[
      //   GoRoute(
      //     path: 'trip/:tripId',
      //     builder: (BuildContext context, GoRouterState state) {
      //       final tripId = state.pathParameters['tripId']!;
      //       return TripDetailsScreen(tripId: tripId);
      //     },
      //   ),
      // ],
    ),
    GoRoute(
      path: '/about',
      builder: (BuildContext context, GoRouterState state) {
        return const AboutScreen();
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Page Not Found')),
    body: Center(child: Text('Oops! Page not found: ${state.error}')),
  ),
);
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
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
      debugShowCheckedModeBanner: false,
    );
  }
}