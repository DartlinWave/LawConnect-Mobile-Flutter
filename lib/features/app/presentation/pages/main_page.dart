import 'package:flutter/material.dart';

// Páginas principales
import 'package:lawconnect_mobile_flutter/features/home/presentation/pages/home_page.dart';
import 'package:lawconnect_mobile_flutter/features/lawyers/presentation/pages/lawyers_page.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/pages/cases_page.dart';
import 'package:lawconnect_mobile_flutter/features/profiles/presentation/pages/profile_page.dart';

// Tema
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  // Orden de pestañas: Home · Lawyers · Cases · Profile
  final List<Widget> _pages = [
    const HomePage(),
    const LawyersPage(),
    const CasesPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: ColorPalette.primaryColor,
        selectedItemColor: ColorPalette.secondaryColor,
        unselectedItemColor: ColorPalette.whiteColor,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.gavel),
            icon: Icon(Icons.gavel_outlined),
            label: 'Lawyers',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.assignment),
            icon: Icon(Icons.assignment_outlined),
            label: 'Cases',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
