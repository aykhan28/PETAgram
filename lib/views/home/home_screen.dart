import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'form_screen.dart';
import 'map_screen.dart';
import 'veterinar_screen.dart';
import 'account_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Widget> pages = [
    FormScreen(),
    MapScreen(),
    Center(child: Text("🐾 Petagram", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
    VeterinarScreen(),
    AccountScreen(),
  ];

  final RxInt _selectedIndex = 2.obs;

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[_selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: _selectedIndex.value,
          onTap: (index) => _selectedIndex.value = index,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.pets), label: "Adopt"),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.local_hospital), label: "Vets"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
          ],
        ),
      ),
    );
  }
}