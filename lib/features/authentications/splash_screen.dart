import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loan_management_system/features/authentications/sign_in_screen.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onLoginSuccess; // Define callback for login success
  final VoidCallback onSignUp; // Define callback for sign-up

  const SplashPage({Key? key, required this.onLoginSuccess, required this.onSignUp}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 5),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(
            onLoginSuccess: widget.onLoginSuccess, // Use the passed callback
            onSignUp: widget.onSignUp, // Use the passed callback
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Changed to white
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace Icon with Image.asset
            Image.asset(
              'assets/icons/logo.png',
              height: 200, 
              fit: BoxFit.contain, 
            ),
            const SizedBox(height: 20), 
            const Text(
              "TGC",
              style: TextStyle(
                color: Colors.blue, 
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
