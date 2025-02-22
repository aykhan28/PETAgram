import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:petagram/firebase_options.dart';
import 'package:petagram/views/auth/login_screen.dart';
import 'package:petagram/views/auth/register_screen.dart';
import 'package:petagram/views/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Petagram',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: LoginScreen(),
      getPages: [
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
      ],
    );
  }
}