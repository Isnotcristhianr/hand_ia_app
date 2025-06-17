import 'package:flutter/material.dart';
import 'package:get/get.dart';

//widgets
import '../../widgets/glass/glass_container.dart';

class NavBar {
  static Widget buildNavBar() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: GlassContainer(
        height: 70,
        borderRadius: 35,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Home button
            _buildNavButton(
              icon: Icons.home,
              isActive: true,
              onTap: () => Get.toNamed('/home'),
            ),

            // Add button (destacado)
            Container(
              width: 75,
              height: 75,
              decoration: const BoxDecoration(
                color: Color(
                  0xFF6366F1,
                ), // Color morado similar al de la imagen
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),

            // Profile button
            _buildNavButton(
              icon: Icons.person,
              isActive: false,
              onTap: () => Get.toNamed('/profile'),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildNavButton({
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
