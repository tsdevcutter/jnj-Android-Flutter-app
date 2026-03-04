import 'package:flutter/material.dart';
import 'package:jnjversion01windows/handlers/database_helper.dart';
import 'package:jnjversion01windows/models/user.dart';
import 'package:jnjversion01windows/screens/home_screen.dart';
import 'package:jnjversion01windows/screens/sign_in_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool isOnline       = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sqldetailsCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Loading..."),
      ),
    );
  }


  void sqldetailsCheck() async {
    User client = await DatabaseHelper.instance.getUser();
    // 2. Check if the widget is still in the tree before navigating
    if (!mounted) return;

    if (client.accessToken != null && client.accessToken!.isNotEmpty) {
      // Navigate to Home and remove the Start screen from the stack
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      // Navigate to Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    }

  }
}