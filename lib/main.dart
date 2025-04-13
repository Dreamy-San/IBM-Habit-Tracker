import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login.dart';
import 'screens/home.dart'; // Assume Home screen exists
import 'screens/sign_up.dart'; // Import SignUpPage

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings =
      InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

 // await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Retrieve shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('loggedIn') ?? false;
  String username = prefs.getString('username') ?? "No Username Available";

  runApp(MyApp(isLoggedIn: isLoggedIn, username: username));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String username;

  const MyApp({super.key, required this.isLoggedIn, required this.username});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habitt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8772FF),
          primary: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: isLoggedIn 
          ? HabitTrackerScreen(username: username) 
          : LoginPage(), // Show appropriate screen
      routes: {
        '/signup': (context) => SignUpPage(), // Route for SignUpPage
        '/login': (context) => LoginPage(),   // Route for LoginPage
        '/home': (context) => HabitTrackerScreen(username: username), // Route for HomeScreen
      },
    );
  }
}
