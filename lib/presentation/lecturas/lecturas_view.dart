import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Controladores
import '../../bloc/controllers/ocr_controller.dart';
// Modelos
import '../../data/models/lectura_model.dart';
// Widgets
import '../../widgets/glass/glass_container.dart';

class LecturasView extends StatelessWidget {
  const LecturasView({super.key});

  @override
  Widget build(BuildContext context) {
    final OcrController ocrController = Get.find<OcrController>();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text(
          'Mis Lecturas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (ocrController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF6366F1)),
          );
        }

        if (ocrController.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                Text(
                  ocrController.error.value,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ocrController.clearError(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (ocrController.lecturas.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 80,
                ),
                const SizedBox(height: 24),
                Text(
                  'No tienes lecturas aún',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Usa el botón de cámara en el menú principal\npara capturar tu primera foto',
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

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: ocrController.lecturas.length,
          itemBuilder: (context, index) {
            final lectura = ocrController.lecturas[index];
            return _buildLecturaCard(lectura, ocrController);
          },
        );
      }),
    );
  }

  Widget _buildLecturaCard(LecturaModel lectura, OcrController controller) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        height: 275,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con fecha y botón eliminar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateFormat.format(lectura.fecha),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Obx(
                  () => IconButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => _showDeleteDialog(lectura, controller),
                    icon: controller.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.red,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Layout de dos columnas: Imagen a la izquierda, análisis a la derecha
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Columna izquierda - Imagen
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 1.0, // Hace la imagen cuadrada
                      child: Image.network(
                        lectura.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey.withValues(alpha: 0.3),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF6366F1),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.withValues(alpha: 0.3),
                            child: const Center(
                              child: Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 48,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Columna derecha - Análisis
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Estado de la lectura
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: lectura.response.isEmpty
                              ? Colors.orange.withValues(alpha: 0.2)
                              : Colors.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: lectura.response.isEmpty
                                ? Colors.orange.withValues(alpha: 0.5)
                                : Colors.green.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          lectura.response.isEmpty
                              ? 'Pendiente de análisis'
                              : 'Análisis completado',
                          style: TextStyle(
                            color: lectura.response.isEmpty
                                ? Colors.orange
                                : Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Título del análisis
                      const Text(
                        'Análisis de la Mano',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Contenido del análisis
                      if (lectura.response.isEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tu foto está siendo procesada por nuestra IA especializada en quiromancia.',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.hourglass_empty,
                                  color: Colors.orange.withValues(alpha: 0.8),
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Tiempo estimado: 2-5 minutos',
                                  style: TextStyle(
                                    color: Colors.orange.withValues(alpha: 0.8),
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      else
                        // Aquí se mostraría el análisis completado
                        Column(
                          children: lectura.response
                              .map(
                                (respuesta) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    respuesta,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      fontSize: 14,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(LecturaModel lectura, OcrController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF2A2A3E),
        title: const Text(
          'Eliminar lectura',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '¿Estás seguro de que quieres eliminar esta lectura? Esta acción no se puede deshacer.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.eliminarLectura(lectura.id);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
