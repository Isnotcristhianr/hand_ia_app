import 'package:flutter/material.dart';

//widgets
import '../../widgets/glass/glass_container.dart';

class NavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavBar({super.key, this.currentIndex = 0, required this.onTap});

  static Widget buildNavBar({
    int currentIndex = 0,
    required Function(int) onTap,
  }) {
    return NavBar(currentIndex: currentIndex, onTap: onTap);
  }

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _breathingAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Repetir la animación infinitamente
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Nav bar base
          GlassContainer(
            height: 70,
            borderRadius: 35,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Home button
                _buildNavButton(
                  icon: Icons.home,
                  isActive: widget.currentIndex == 0,
                  onTap: () => widget.onTap(0),
                ),

                // Espacio para el botón flotante
                const SizedBox(width: 75),

                // Profile button
                _buildNavButton(
                  icon: Icons.person,
                  isActive: widget.currentIndex == 1,
                  onTap: () => widget.onTap(1),
                ),
              ],
            ),
          ),

          // Botón flotante central con animación de respiración
          Positioned(
            top: -5, // Elevado por encima del nav bar
            child: AnimatedBuilder(
              animation: _breathingAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _breathingAnimation.value,
                  child: Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      gradient: const RadialGradient(
                        colors: [
                          Color(0xFF6366F1),
                          Color.fromARGB(255, 47, 48, 113),
                        ],
                        center: Alignment.center,
                        radius: 1.0,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                          blurRadius: 20 * _breathingAnimation.value,
                          offset: const Offset(0, 10),
                          spreadRadius: 2 * (_breathingAnimation.value - 1),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // Acción del botón flotante
                        },
                        customBorder: const CircleBorder(),
                        child: const Icon(
                          Icons.back_hand,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        color: isActive
            ? Colors.white.withValues(alpha: 0.2)
            : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
