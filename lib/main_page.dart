import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/color_palette.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Text("Home"),
    Text("Lawyers"),
    Text("Cases"),
    Text("Profile"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        currentIndex: _selectedIndex,
        backgroundColor: ColorPalette.primaryColor,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: ColorPalette.whiteColor,
        selectedItemColor: ColorPalette.secondaryColor,
        items: const [
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home), 
            icon: Icon(Icons.home_outlined), 
            label: "Home"
            ),

          BottomNavigationBarItem(
            activeIcon: Icon(Icons.gavel), 
            icon: Icon(Icons.gavel_outlined), 
            label: "Lawyers"
          ),

          BottomNavigationBarItem(
            activeIcon: Icon(Icons.assignment), 
            icon: Icon(Icons.assignment_outlined), 
            label: "Cases"
          ),

          BottomNavigationBarItem(
            activeIcon: Icon(Icons.person), 
            icon: Icon(Icons.person_outline), 
            label: "Profile"
          ),
        ],
      ),
    );
  }
}
