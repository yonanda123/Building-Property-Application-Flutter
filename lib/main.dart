import 'package:flutter/material.dart';
import 'package:propertyapplication/login_page.dart';
import 'package:propertyapplication/register_page.dart';
import 'package:propertyapplication/dashboard_page.dart';
import 'package:propertyapplication/shared_pref_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  String _loggedInUsername = '';

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final isLoggedIn = await SharedPrefHelper.instance.isLoggedIn();
    final prefs = await SharedPreferences.getInstance();
    final loggedInUsername = prefs.getString('username') ?? '';

    setState(() {
      _isLoggedIn = isLoggedIn;
      _loggedInUsername = loggedInUsername;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: _isLoggedIn
          ? DashboardPage(username: _loggedInUsername)
          : LoginPage(),
      routes: {
        '/dashboard': (context) => DashboardPage(username: _loggedInUsername),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
