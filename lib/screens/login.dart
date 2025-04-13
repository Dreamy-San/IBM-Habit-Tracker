import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool validateForm() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      print('All fields are required');
      return false;
    }
    return true;
  }

  Future<void> authenticateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (emailController.text == savedEmail &&
        passwordController.text == savedPassword) {
      await prefs.setBool('loggedIn', true); // Set loggedIn to true
      Navigator.pushNamed(context, '/home'); // Navigate to home screen
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Failed'),
          content: Text('Invalid email or password. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Set button color to black
                  foregroundColor: Colors.white, // Set text color to white
                ),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void handleLogin() {
    if (validateForm()) {
      authenticateUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        color: Color(0xFF8772FF), // Set background color
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Enter your email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Enter your password'),
                obscureText: true,
              ),
              SizedBox(height: 45), // Push the following widgets to the bottom
              ElevatedButton(
                onPressed: handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Set button color to black
                  foregroundColor: Colors.white, // Set text color to white
                ),
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}