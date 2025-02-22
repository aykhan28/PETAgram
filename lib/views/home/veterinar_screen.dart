import 'package:flutter/material.dart';

class VeterinarScreen extends StatelessWidget {
  const VeterinarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("🩺 Vet Reviews & Ratings", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
    );
  }
}