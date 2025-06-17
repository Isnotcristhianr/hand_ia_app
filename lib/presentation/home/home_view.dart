import 'package:flutter/material.dart';
//widgets
import '../../widgets/master/bg.dart';
import '../../widgets/welcome/logo.dart';
import '../../widgets/glass/glass_container.dart';
import 'nav_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: Bg.decoration,
        child: SafeArea(
          child: Column(
            children: [
              // Header con logo
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 20.0,
                ),
                child: Column(
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
              ),

              const SizedBox(height: 20),

              // Lista de lecturas
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: ListView.separated(
                    itemCount: 5,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return GlassContainer(
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
                      );
                    },
                  ),
                ),
              ),

              // Navigation Bar
              NavBar.buildNavBar(),
            ],
          ),
        ),
      ),
    );
  }
}
