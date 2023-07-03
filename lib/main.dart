import 'package:flutter/material.dart';
import 'package:propertyapplication/login_page.dart';
import 'package:propertyapplication/register_page.dart';
import 'package:propertyapplication/AdminDashboardPage.dart';
import 'package:propertyapplication/UserDashboardPage.dart';
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
  int _loggedInUserRole = 0; // Tambahkan variabel untuk menyimpan nilai role

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final isLoggedIn = await SharedPrefHelper.instance.isLoggedIn();
    final prefs = await SharedPreferences.getInstance();
    final loggedInUsername = prefs.getString('username') ?? '';
    final loggedInUserRole =
        prefs.getInt('role') ?? 0; // Mendapatkan nilai role

    setState(() {
      _isLoggedIn = isLoggedIn;
      _loggedInUsername = loggedInUsername;
      _loggedInUserRole = loggedInUserRole; // Mengatur nilai role
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: _isLoggedIn
          ? (_loggedInUserRole == 1
              ? AdminDashboardPage(username: _loggedInUsername)
              : UserDashboardPage(username: _loggedInUsername))
          : LoginPage(),
      routes: {
        '/admin_dashboard': (context) =>
            AdminDashboardPage(username: _loggedInUsername),
        '/user_dashboard': (context) =>
            UserDashboardPage(username: _loggedInUsername),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
      },
    );
  }
}
