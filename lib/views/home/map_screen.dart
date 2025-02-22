import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("📍 Find Nearby Vets", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
    );
  }
}