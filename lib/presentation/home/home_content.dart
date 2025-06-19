import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

//widgets
import '../../widgets/welcome/logo.dart';
import '../../widgets/glass/glass_container.dart';
//services
import '../../services/mensajes_daily_service.dart';
//controllers
import '../../bloc/controllers/ocr_controller.dart';

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
          child: Column(
            children: [
              // Header de lecturas con botón "Ver todas"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mis Lecturas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed('/lecturas'),
                      child: const Text(
                        'Ver todas',
                        style: TextStyle(
                          color: Color(0xFF6366F1),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Lista de lecturas
              Expanded(
                child: GetBuilder<OcrController>(
                  init: Get.put(OcrController()),
                  builder: (ocrController) {
                    return Obx(() {
                      final lecturas = ocrController.lecturas;

                      if (ocrController.isLoading.value) {
                        return _buildLoadingState();
                      }

                      if (lecturas.isEmpty) {
                        return _buildEmptyState();
                      }

                      // Mostrar solo las primeras 5 lecturas
                      final lecturasLimitadas = lecturas.take(5).toList();

                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        itemCount: lecturasLimitadas.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final lectura = lecturasLimitadas[index];
                          final dateFormat = DateFormat('dd/MM/yyyy');

                          return GestureDetector(
                            onTap: () => Get.toNamed('/lecturas'),
                            child: GlassContainer(
                              height: 70,
                              borderRadius: 30,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  // Icono de mano con indicador de estado
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: lectura.response.isEmpty
                                          ? Colors.orange.withValues(alpha: 0.3)
                                          : Colors.green.withValues(alpha: 0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.back_hand,
                                      color: lectura.response.isEmpty
                                          ? Colors.orange
                                          : Colors.green,
                                      size: 20,
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  // Información de la lectura
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Lectura ${dateFormat.format(lectura.fecha)}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          lectura.response.isEmpty
                                              ? 'Pendiente de análisis'
                                              : 'Análisis completado',
                                          style: TextStyle(
                                            color: lectura.response.isEmpty
                                                ? Colors.orange
                                                : Colors.green,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
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
                          );
                        },
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFF6366F1)),
          const SizedBox(height: 16),
          Text(
            'Analizando lectura...',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.back_hand,
            color: Colors.white.withValues(alpha: 0.5),
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'No tienes lecturas aún',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Usa el botón de cámara para\ncapturar tu primera foto',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
