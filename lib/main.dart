import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loan_management_system/features/authentications/sign_in_screen.dart';
import 'package:loan_management_system/features/authentications/sign_up_screen.dart';
import 'package:loan_management_system/navigation/main_screen.dart';

void main() async {
  // Ensures that all necessary Flutter bindings are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase asynchronously
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: "AIzaSyA9d1kYTp6R4Ap_oSyzN8jA2Ouiq5pWap4",
          authDomain: "loan-manager-v1.firebaseapp.com",
          databaseURL: "https://loan-manager-v1-default-rtdb.firebaseio.com",
          projectId: "loan-manager-v1",
          storageBucket: "loan-manager-v1.appspot.com",
          messagingSenderId: "993579334903",
          appId: "1:993579334903:web:03182d5b241c2dfce4a7f2",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    // Handle any errors during Firebase initialization
    print("Error initializing Firebase: $e");
    return; // Stop execution if initialization fails
  }

  runApp(const MyApp()); // Start the app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFf9f9f9),
      ),
       initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(
              onLoginSuccess: () {
                Navigator.pushReplacementNamed(context, '/main');
              },
              onSignUp: () {
                Navigator.pushNamed(context, '/register');
              },
            ),
        '/register': (context) => SignUpScreen(
              onSignUpSuccess: () {
                Navigator.pushReplacementNamed(context, '/main');
              },
              onLogin: () {
                Navigator.pop(context);
              },
            ),
        '/main': (context) => const MainScreen(), 
      },
    );
  }
}

// LoginScreen(
      //   onLoginSuccess: () {
      //     // Navigate to MainScreen on successful login
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(builder: (context) => const MainScreen()),
      //     );
      //   },
      //   onSignUp: () {
      //     // Navigate to SignUpScreen on sign up
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => SignUpScreen(
      //           onSignUpSuccess: () {
      //             // Handle sign-up success (e.g., navigate to main screen)
      //             Navigator.pushReplacement(
      //               context,
      //               MaterialPageRoute(builder: (context) => const MainScreen()),
      //             );
      //           },
      //           onLogin: () {
      //             // Navigate back to login screen
      //             Navigator.pop(context);
      //           },
      //         ),
      //       ),
      //     );
      //   },
      // ),