import 'package:flutter/material.dart';
import 'package:get/get.dart';
//widgets
import '../../widgets/glass/glass_container.dart';

//controllers
import '../../bloc/controllers/auth_controller.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  bool _notifications = false;

  void _handleProfileTap() {
    try {
      final authController = Get.find<AuthController>();

      if (authController.authStatus.value == AuthStatus.authenticated) {
        // Usuario autenticado: ir a información de cuenta
        Get.toNamed('/account-info');
      } else {
        // Usuario no autenticado: mostrar diálogo para iniciar sesión
        _showLoginDialog();
      }
    } catch (e) {
      // Si no se puede encontrar el AuthController, asumir que no está autenticado
      _showLoginDialog();
    }
  }

  void _showLoginDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Iniciar Sesión',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Para acceder a tu perfil, necesitas iniciar sesión.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.toNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C4DFF),
              foregroundColor: Colors.white,
            ),
            child: const Text('Iniciar Sesión'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              _handleProfileTap();
            },
          ),

          const SizedBox(height: 32),

          // Título "Preferencias"
          _buildSectionTitle("Preferencias"),

          const SizedBox(height: 16),

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

          const SizedBox(height: 32),

          // Título "Políticas de Privacidad"
          _buildSectionTitle("Políticas de Privacidad"),

          const SizedBox(height: 16),

          // Privacidad
          _buildProfileItem(
            icon: Icons.privacy_tip_outlined,
            title: "Políticas de Privacidad",
            subtitle: "Consulta nuestras políticas de privacidad",
            onTap: () {},
          ),

          const SizedBox(height: 32),

          // Botón cerrar sesión (solo visible si está autenticado)
          Builder(
            builder: (context) {
              try {
                Get.find<AuthController>();
                return GetBuilder<AuthController>(
                  builder: (controller) {
                    if (controller.authStatus.value ==
                        AuthStatus.authenticated) {
                      return Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.dialog(
                              AlertDialog(
                                backgroundColor: const Color(0xFF1A1A2E),
                                title: const Text(
                                  'Cerrar Sesión',
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: const Text(
                                  '¿Estás seguro de que deseas cerrar sesión?',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text(
                                      'Cancelar',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                      controller.logout();
                                      Get.offAllNamed('/');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Cerrar Sesión'),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text("Cerrar Sesión"),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                );
              } catch (e) {
                // Si no hay AuthController, no mostrar el botón
                return const SizedBox.shrink();
              }
            },
          ),
        ],
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
