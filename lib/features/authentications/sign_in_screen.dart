import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback onSignUp;

  const LoginScreen({Key? key, required this.onLoginSuccess, required this.onSignUp}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '152430873861-9a5oha7n3jbiahi07lcejmq1815j315d.apps.googleusercontent.com',
  );
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = '';
  final Color logoGreen = const Color(0xFF305CDE);
  bool isLoading = false;

  void _signInWithEmailAndPassword() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        errorMessage = "Please fill in all fields.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _usernameController.text,
        password: _passwordController.text,
      );
      _usernameController.clear();
      _passwordController.clear();
      widget.onLoginSuccess();
    } catch (e) {
      setState(() {
        errorMessage = "Invalid credentials";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      if (googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _auth.signInWithCredential(credential);
        widget.onLoginSuccess();
      }
    } catch (e) {
      setState(() {
        errorMessage = "Google Sign-In failed: ${e.toString()}";
      });
    } finally {
      setState(() {
        isLoading = false;
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
                  "Login to your account",
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'User name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                if (isLoading)
                  CircularProgressIndicator()
                else
                  Column(
                    children: [
                      MaterialButton(
                        elevation: 0,
                        minWidth: double.maxFinite,
                        height: 50,
                        onPressed: _signInWithEmailAndPassword,
                        color: logoGreen,
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 20),
                      MaterialButton(
                        elevation: 0,
                        minWidth: double.maxFinite,
                        height: 50,
                        onPressed: _signInWithGoogle,
                        color: Colors.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            // Icon(Icons.golf_course, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              'Sign-in using Google',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                Text(errorMessage, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 100),
                TextButton(
                  onPressed: widget.onSignUp,
                  child: const Text("Don't have an account? Register Now"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
