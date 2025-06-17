import 'package:flutter/material.dart';
//widgets
import '../../widgets/welcome/logo.dart';
import '../../widgets/glass/glass_container.dart';
//services
import '../../services/mensajes_daily_service.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header fijo con logo y descripción
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10.0),
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

              // Mensaje del día en glass container
              GlassContainer(
                height: 125,
                borderRadius: 20,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Etiqueta "Mensaje del día"
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.white.withValues(alpha: 0.8),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Mensaje del día',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Mensaje del día dinámico
                    Text(
                      MensajesDailyService.getMensajeDelDia(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Lista scrollable de lecturas
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
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
      ],
    );
  }
}
