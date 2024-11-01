import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onSignUpSuccess;
  final VoidCallback onLogin;

  const SignUpScreen({Key? key, required this.onSignUpSuccess, required this.onLogin}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String username = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String errorMessage = '';

  Future<void> _register() async {
    if (username.isEmpty) {
      setState(() => errorMessage = "User name cannot be empty");
      return;
    }
    if (email.isEmpty) {
      setState(() => errorMessage = "Email cannot be empty");
      return;
    }
    if (password != confirmPassword) {
      setState(() => errorMessage = "Passwords do not match");
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      widget.onSignUpSuccess();
    } catch (e) {
      setState(() {
        errorMessage = e.toString();  // Show the specific Firebase error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Create an Account",
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 24),
                TextField(
                  onChanged: (value) => username = value,
                  decoration: const InputDecoration(labelText: 'User name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  onChanged: (value) => email = value,
                  decoration: const InputDecoration(labelText: 'Email ID'),
                ),
                const SizedBox(height: 12),
                TextField(
                  onChanged: (value) => password = value,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                TextField(
                  onChanged: (value) => confirmPassword = value,
                  decoration: const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: _register,
                  child: const Text("Register"),
                ),
                Text(errorMessage, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 24),
                const Text("Have an Account?"),
                TextButton(
                  onPressed: widget.onLogin,
                  child: const Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
