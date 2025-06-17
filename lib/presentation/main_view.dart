import 'package:flutter/material.dart';
import 'package:get/get.dart';
//widgets
import '../widgets/master/bg.dart';
import '../widgets/glass/glass_container.dart';
import '../widgets/welcome/logo.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 0;

  // Estados para los toggles del perfil
  bool _darkMode = true;
  bool _notifications = true;
  bool _saveHistory = true;
  bool _privacyMode = true;

  @override
  void initState() {
    super.initState();
    // Detectar la ruta inicial
    if (Get.currentRoute == '/profile') {
      _currentIndex = 1;
    } else {
      _currentIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: Bg.decoration,
        child: SafeArea(
          child: Column(
            children: [
              // Contenido que cambia
              Expanded(
                child: _currentIndex == 0
                    ? _buildHomeContent()
                    : _buildProfileContent(),
              ),

              // Navigation Bar fijo
              _buildFixedNavBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
      child: Column(
        children: [
          // Header con logo
          Column(
            children: [
              // Logo más pequeño y en esquina izquierda
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Transform.scale(
                  scale: 0.6,
                  alignment: Alignment.centerLeft,
                  child: Logo.buildLogo(),
                ),
              ),

              // Descripción
              GlassContainer(
                borderRadius: 20,
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Utiliza inteligencia artificial avanzada para analizar las líneas de tu mano y obtener insights únicos sobre tu personalidad y futuro.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Lista de lecturas
          ...List.generate(
            5,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassContainer(
                height: 60,
                borderRadius: 30,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    // Icono de mano
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.back_hand_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Texto
                    const Expanded(
                      child: Text(
                        'Título de la Lectura',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    // Flecha
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título "Cuenta"
          _buildSectionTitle("Cuenta"),

          const SizedBox(height: 16),

          // Mi Perfil
          _buildProfileItem(
            icon: Icons.person_outline,
            title: "Mi Perfil",
            subtitle: "Administra tu información Personal",
            onTap: () {
              // Navegación a editar perfil
            },
          ),

          const SizedBox(height: 32),

          // Título "Preferencias"
          _buildSectionTitle("Preferencias"),

          const SizedBox(height: 16),

          // Modo Oscuro
          _buildToggleItem(
            icon: Icons.dark_mode_outlined,
            title: "Modo Oscuro",
            subtitle: "Cambia entre el modo claro y oscuro",
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
            },
          ),

          const SizedBox(height: 12),

          // Notificaciones
          _buildToggleItem(
            icon: Icons.notifications_outlined,
            title: "Notificaciones",
            subtitle: "Recibe alertas y recordatorios",
            value: _notifications,
            onChanged: (value) {
              setState(() {
                _notifications = value;
              });
            },
          ),

          const SizedBox(height: 12),

          // Guardar el Historial
          _buildToggleItem(
            icon: Icons.history,
            title: "Guardar el Historial",
            subtitle: "Conserva tus análisis anteriores",
            value: _saveHistory,
            onChanged: (value) {
              setState(() {
                _saveHistory = value;
              });
            },
          ),

          const SizedBox(height: 32),

          // Título "Políticas de Privacidad"
          _buildSectionTitle("Políticas de Privacidad"),

          const SizedBox(height: 16),

          // Privacidad
          _buildToggleItem(
            icon: Icons.privacy_tip_outlined,
            title: "Modo Privado",
            subtitle: "Cambia entre el modo claro y oscuro",
            value: _privacyMode,
            onChanged: (value) {
              setState(() {
                _privacyMode = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFixedNavBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
              isActive: _currentIndex == 0,
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),

            // Add button (destacado)
            Container(
              width: 75,
              height: 75,
              decoration: const BoxDecoration(
                color: Color(0xFF6366F1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),

            // Profile button
            _buildNavButton(
              icon: Icons.person,
              isActive: _currentIndex == 1,
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
          ],
        ),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        borderRadius: 20,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icono
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),

            const SizedBox(width: 16),

            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GlassContainer(
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Icono
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),

          const SizedBox(width: 16),

          // Textos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),

          // Toggle Switch
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF6366F1),
              inactiveThumbColor: Colors.white.withValues(alpha: 0.7),
              inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }
}
