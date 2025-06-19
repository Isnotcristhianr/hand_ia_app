import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Controladores
import '../../bloc/controllers/ocr_controller.dart';
// Modelos
import '../../data/models/lectura_model.dart';
// Widgets
import '../../widgets/glass/glass_container.dart';

class LecturasView extends StatefulWidget {
  const LecturasView({super.key});

  @override
  State<LecturasView> createState() => _LecturasViewState();
}

class _LecturasViewState extends State<LecturasView> {
  final PageController _pageController = PageController();
  final RxInt _currentIndex = 0.obs;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final OcrController ocrController = Get.find<OcrController>();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: Obx(() {
          if (ocrController.lecturas.isEmpty) {
            return const Text(
              'Mis Lecturas',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          }
          return Text(
            'Lectura ${_currentIndex.value + 1} de ${ocrController.lecturas.length}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
        }),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Obx(() {
            if (ocrController.lecturas.isEmpty) return const SizedBox();

            return PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              color: const Color(0xFF2A2A3E),
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteDialog(
                    ocrController.lecturas[_currentIndex.value],
                    ocrController,
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Eliminar lectura',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
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
          return _buildEmptyState();
        }

        return Column(
          children: [
            // Indicador de páginas
            if (ocrController.lecturas.length > 1)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    ocrController.lecturas.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex.value == index
                            ? const Color(0xFF6366F1)
                            : Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
              ),

            // PageView con las lecturas
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  _currentIndex.value = index;
                },
                itemCount: ocrController.lecturas.length,
                itemBuilder: (context, index) {
                  final lectura = ocrController.lecturas[index];
                  return _buildLecturaDetailView(lectura);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyState() {
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

  Widget _buildLecturaDetailView(LecturaModel lectura) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con fecha
          GlassContainer(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  dateFormat.format(lectura.fecha),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
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
                    lectura.response.isEmpty ? 'Pendiente' : 'Completado',
                    style: TextStyle(
                      color: lectura.response.isEmpty
                          ? Colors.orange
                          : Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Imagen de la mano
          GlassContainer(
            height: 370,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.back_hand,
                      color: Colors.white.withValues(alpha: 0.8),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Tu Mano',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 16 / 12,
                    child: Image.network(
                      lectura.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
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
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Análisis
          if (lectura.response.isEmpty)
            _buildPendingAnalysis()
          else
            _buildAnalysisContent(lectura.response.first),
        ],
      ),
    );
  }

  Widget _buildPendingAnalysis() {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.hourglass_empty,
            color: Colors.orange.withValues(alpha: 0.8),
            size: 48,
          ),
          const SizedBox(height: 16),
          const Text(
            'Análisis en Proceso',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tu foto está siendo procesada por nuestra IA especializada en quiromancia. El análisis detallado estará listo en unos minutos.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.timer,
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
      ),
    );
  }

  Widget _buildAnalysisContent(String analysisText) {
    // Procesar el texto del análisis para estructurarlo mejor
    final sections = _parseAnalysisText(analysisText);

    return Column(
      children: [
        // Título del análisis
        GlassContainer(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(
                Icons.psychology,
                color: Colors.white.withValues(alpha: 0.8),
                size: 20,
              ),
              const SizedBox(width: 12),
              const Text(
                'Análisis Completo de tu Mano',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Contenido del análisis por secciones
        ...sections.map((section) => _buildAnalysisSection(section)).toList(),
      ],
    );
  }

  List<AnalysisSection> _parseAnalysisText(String text) {
    final sections = <AnalysisSection>[];

    // Dividir el texto en secciones basándose en los patrones
    final lines = text.split('\n');
    String currentTitle = '';
    List<String> currentContent = [];

    for (String line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      // Detectar títulos (líneas que contienen ** o emojis específicos)
      if (line.contains('**') || _isTitle(line)) {
        // Guardar sección anterior
        if (currentTitle.isNotEmpty && currentContent.isNotEmpty) {
          sections.add(
            AnalysisSection(
              title: currentTitle,
              content: currentContent.join('\n'),
              icon: _getIconForSection(currentTitle),
            ),
          );
        }

        // Iniciar nueva sección
        currentTitle = _cleanTitle(line);
        currentContent = [];
      } else {
        currentContent.add(line);
      }
    }

    // Agregar última sección
    if (currentTitle.isNotEmpty && currentContent.isNotEmpty) {
      sections.add(
        AnalysisSection(
          title: currentTitle,
          content: currentContent.join('\n'),
          icon: _getIconForSection(currentTitle),
        ),
      );
    }

    // Si no se encontraron secciones, crear una sección general
    if (sections.isEmpty) {
      sections.add(
        AnalysisSection(
          title: 'Análisis de tu Mano',
          content: text,
          icon: Icons.back_hand,
        ),
      );
    }

    return sections;
  }

  bool _isTitle(String line) {
    return line.contains('🖐️') ||
        line.contains('📏') ||
        line.contains('🔍') ||
        line.contains('🧩') ||
        line.contains('**');
  }

  String _cleanTitle(String title) {
    return title
        .replaceAll('**', '')
        .replaceAll('*', '')
        .replaceAll('🖐️', '')
        .replaceAll('📏', '')
        .replaceAll('🔍', '')
        .replaceAll('🧩', '')
        .trim();
  }

  IconData _getIconForSection(String title) {
    if (title.toLowerCase().contains('forma') ||
        title.toLowerCase().contains('general')) {
      return Icons.back_hand;
    } else if (title.toLowerCase().contains('línea') ||
        title.toLowerCase().contains('principales')) {
      return Icons.linear_scale;
    } else if (title.toLowerCase().contains('detalle') ||
        title.toLowerCase().contains('adicional')) {
      return Icons.zoom_in;
    } else if (title.toLowerCase().contains('conclusión') ||
        title.toLowerCase().contains('resumen')) {
      return Icons.psychology;
    } else {
      return Icons.star;
    }
  }

  Widget _buildAnalysisSection(AnalysisSection section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        height: 500,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la sección
            Row(
              children: [
                Icon(section.icon, color: const Color(0xFF6366F1), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    section.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Contenido de la sección
            Text(
              section.content,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14,
                height: 1.5,
              ),
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

// Clase auxiliar para las secciones del análisis
class AnalysisSection {
  final String title;
  final String content;
  final IconData icon;

  AnalysisSection({
    required this.title,
    required this.content,
    required this.icon,
  });
}
