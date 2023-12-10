import 'package:bitirme0/pages/forgotpassword.dart';
import 'package:bitirme0/pages/home.dart';
import 'package:bitirme0/pages/login.dart';
import 'package:bitirme0/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CookApp',
      theme: ThemeData(),
      routes: {
        "/loginPage": (context) => const LoginPage(),
        "/RegistrationPage": (context) => const RegistrationPage(),
        "/ForgetPassword": (context) => const ForgotPasswordPage(),
        "/HomePage": (context) => const HomePage()
      },
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
