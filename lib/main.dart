import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nust_students/views/capture_page.dart';
import 'package:nust_students/views/login.dart';
import 'package:nust_students/views/sccess_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'controller/my_provider.dart';


void main() {
  // Add error handling for initialization
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Add a timeout for initialization
    await Future.wait([
      // Add any async initializations here, like Firebase, SharedPreferences, etc.
    ]).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        // Fallback if initialization takes too long
        return [];
      },
    );
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MyProvider(),
            // Add lazy loading to improve initial load time
            lazy: true,
          ),
        ],
        child: Sizer(
          builder: (context, orientation, deviceType) {
            return MyApp();
          },
        ),
      ),
    );
  }, (error, stackTrace) {
    // Log errors and show a user-friendly error screen
    print('Initialization Error: $error');
    runApp(ErrorApp(error: error));
  });
}
// Add an error fallback app
class ErrorApp extends StatelessWidget {
  final dynamic error;

  const ErrorApp({Key? key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Something went wrong', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              Text('$error', style: TextStyle(color: Colors.red)),
              ElevatedButton(
                child: Text('Retry'),
                onPressed: () {
                  // Implement app restart logic
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => LoginView(),
    ),
    GoRoute(
      path: '/capture',
      builder: (context, state) {
        return ImageScreen(); // Your capture page
      },
    ),
    GoRoute(
      path: '/success',
      builder: (context, state) => SuccessPage(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: _router.routerDelegate,
      routeInformationParser: _router.routeInformationParser,
      routeInformationProvider: _router.routeInformationProvider,
    );
  }
}