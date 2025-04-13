import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'country_list.dart';
import 'login.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  double _age = 25; // Default age set to 25
  String _country = 'United States';
  List<String> _countries = [];
  List<String> selectedHabits = [];
  List<String> availableHabits = [
    'Wake Up Early',
    'Workout',
    'Drink Water',
    'Meditate',
    'Read a Book',
    'Practice Gratitude',
    'Sleep 8 Hours',
    'Eat Healthy',
    'Journal',
    'Walk 10,000 Steps'
  ];

  final Map<String, Color> _habitColors = {
    'Amber': Colors.amber,
    'Red Accent': Colors.redAccent,
    'Light Blue': Colors.lightBlue,
    'Light Green': Colors.lightGreen,
    'Purple Accent': Colors.purpleAccent,
    'Orange': Colors.orange,
    'Teal': Colors.teal,
    'Deep Purple': Colors.deepPurple,
  };

  @override
  void initState() {
    super.initState();
    _fetchCountries();
    selectedHabits.add('Wake Up Early'); // Add a sample habit
  }

  Future<void> _fetchCountries() async {
    List<String> subsetCountries = [
      'United States',
      'Canada',
      'United Kingdom',
      'Australia',
      'India',
      'Germany',
      'France',
      'Japan',
      'China',
      'Brazil',
      'South Africa'
    ];
    setState(() {
      _countries = subsetCountries;
      _countries.sort();
      _country = _countries.isNotEmpty ? _countries[0] : 'United States';
    });
  }

  Future<void> _loadCountries() async {
    try {
      List<String> countries = await fetchCountries();
      setState(() {
        _countries = countries;
      });
    } catch (e) {
      // Handle error
      _showToast('Error fetching countries');
    }
  }

  bool validateForm() {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Assign random colors to selected habits.
    Map<String, String> selectedHabitsMap = {};
    final random = Random();
    final colorKeys = _habitColors.keys.toList();
    for (var habit in selectedHabits) {
      var randomColor =
          _habitColors[colorKeys[random.nextInt(colorKeys.length)]]!;
      selectedHabitsMap[habit] = randomColor.value.toRadixString(16);
    }

    // Save user information and habits to shared preferences.
    await prefs.setString('username', usernameController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('password', passwordController.text);
    await prefs.setDouble('age', _age);
    await prefs.setString('country', _country);
    await prefs.setString('selectedHabitsMap', jsonEncode(selectedHabitsMap));
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Container(
        color: Color(0xFF8772FF), // Set background color
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Enter your username'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Enter your email'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Enter your password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              Text('Age: ${_age.round()}',
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
              Slider(
                value: _age,
                min: 21,
                max: 100,
                divisions: 79,
                onChanged: (double value) {
                  setState(() {
                    _age = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: DropdownButton<String>(
                  value: _country,
                  icon: const Icon(Icons.arrow_drop_down),
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: _countries.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _country = newValue!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Text('Select Your Habits',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: availableHabits.map((habit) {
                  final isSelected = selectedHabits.contains(habit);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedHabits.remove(habit);
                        } else {
                          selectedHabits.add(habit);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color.fromARGB(255, 159, 143, 248) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF8772FF)),
                      ),
                      child: Text(
                        habit,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF8772FF),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (validateForm()) {
                    await saveUserData();
                    Navigator.pushNamed(context, '/login'); // Navigate to login
                  } else {
                    _showToast('Please fill in all fields');
                    /* showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Sign Up Failed'),
                        content: Text('All fields are required.'),
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
                    ); */
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Set button color to black
                  foregroundColor: Colors.white, // Set text color to white
                ),
                child: Text('Sign Up'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}