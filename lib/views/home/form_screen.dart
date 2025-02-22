import 'package:flutter/material.dart';

class FormScreen extends StatelessWidget {
  const FormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("🐶 Adoption Forms", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
    );
  }
}