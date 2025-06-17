import 'package:flutter/material.dart';
//widgets
import '../widgets/master/bg.dart';
//views
import 'home/home_content.dart';
import 'profile/profile_content.dart';
import 'home/nav_bar.dart';

class MainLayout extends StatefulWidget {
  final int initialIndex;

  const MainLayout({super.key, this.initialIndex = 0});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: Bg.decoration,
        child: SafeArea(
          child: Column(
            children: [
              // Contenido que cambia dinámicamente
              Expanded(
                child: _currentIndex == 0
                    ? const HomeContent()
                    : const ProfileContent(),
              ),

              // Navigation Bar fijo
              NavBar.buildNavBar(currentIndex: _currentIndex, onTap: _onNavTap),
            ],
          ),
        ),
      ),
    );
  }
}
