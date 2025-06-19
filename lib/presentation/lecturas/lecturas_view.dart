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
  final int initialIndex;

  const LecturasView({super.key, this.initialIndex = 0});

  @override
  State<LecturasView> createState() => _LecturasViewState();
}

class _LecturasViewState extends State<LecturasView> {
  late final PageController _pageController;
  final RxInt _currentIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    // Configurar el índice inicial y el PageController
    _currentIndex.value = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

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
        mainAxisSize: MainAxisSize.min,
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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
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
      mainAxisSize: MainAxisSize.min,
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

    // Limpiar el texto y dividirlo en líneas
    final lines = text.split('\n');
    String currentTitle = '';
    List<String> currentContent = [];

    for (String line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      // Detectar títulos más específicamente
      if (_isTitle(line)) {
        // Guardar sección anterior si existe
        if (currentTitle.isNotEmpty && currentContent.isNotEmpty) {
          sections.add(
            AnalysisSection(
              title: currentTitle,
              content: _formatContent(currentContent.join('\n')),
              icon: _getIconForSection(currentTitle),
            ),
          );
        }

        // Iniciar nueva sección
        currentTitle = _cleanTitle(line);
        currentContent = [];
      } else {
        // Agregar contenido a la sección actual
        currentContent.add(line);
      }
    }

    // Agregar última sección
    if (currentTitle.isNotEmpty && currentContent.isNotEmpty) {
      sections.add(
        AnalysisSection(
          title: currentTitle,
          content: _formatContent(currentContent.join('\n')),
          icon: _getIconForSection(currentTitle),
        ),
      );
    }

    // Si no se encontraron secciones, dividir el texto en párrafos lógicos
    if (sections.isEmpty) {
      sections.addAll(_createDefaultSections(text));
    }

    return sections;
  }

  bool _isTitle(String line) {
    // Detectar líneas que son títulos
    return line.contains('**') &&
        (line.contains('🖐️') ||
            line.contains('📏') ||
            line.contains('🔍') ||
            line.contains('🧩') ||
            line.contains('Forma general') ||
            line.contains('Principales líneas') ||
            line.contains('Detalles adicionales') ||
            line.contains('Conclusión'));
  }

  String _cleanTitle(String title) {
    return title
        .replaceAll('**', '')
        .replaceAll('*', '')
        .replaceAll('🖐️', '')
        .replaceAll('📏', '')
        .replaceAll('🔍', '')
        .replaceAll('🧩', '')
        .replaceAll(':', '')
        .trim();
  }

  String _formatContent(String content) {
    // Mejorar el formato del contenido
    return content
        .replaceAll('* **', '• ')
        .replaceAll('**', '')
        .replaceAll('*', '')
        .trim();
  }

  List<AnalysisSection> _createDefaultSections(String text) {
    final sections = <AnalysisSection>[];

    // Buscar patrones específicos en el texto
    if (text.contains('Forma general')) {
      final formaMatch = _extractSection(
        text,
        'Forma general',
        'Principales líneas',
      );
      if (formaMatch.isNotEmpty) {
        sections.add(
          AnalysisSection(
            title: 'Forma General de la Mano',
            content: formaMatch,
            icon: Icons.back_hand,
          ),
        );
      }
    }

    if (text.contains('Principales líneas')) {
      final lineasMatch = _extractSection(
        text,
        'Principales líneas',
        'Detalles adicionales',
      );
      if (lineasMatch.isNotEmpty) {
        sections.add(
          AnalysisSection(
            title: 'Principales Líneas',
            content: lineasMatch,
            icon: Icons.linear_scale,
          ),
        );
      }
    }

    if (text.contains('Detalles adicionales')) {
      final detallesMatch = _extractSection(
        text,
        'Detalles adicionales',
        'Conclusión',
      );
      if (detallesMatch.isNotEmpty) {
        sections.add(
          AnalysisSection(
            title: 'Detalles Adicionales',
            content: detallesMatch,
            icon: Icons.zoom_in,
          ),
        );
      }
    }

    if (text.contains('Conclusión')) {
      final conclusionMatch = _extractSection(text, 'Conclusión', '');
      if (conclusionMatch.isNotEmpty) {
        sections.add(
          AnalysisSection(
            title: 'Conclusión',
            content: conclusionMatch,
            icon: Icons.psychology,
          ),
        );
      }
    }

    // Si aún no hay secciones, crear una sección general
    if (sections.isEmpty) {
      // Dividir el texto en párrafos y crear secciones
      final paragraphs = text.split('\n\n');
      if (paragraphs.length > 1) {
        for (int i = 0; i < paragraphs.length; i++) {
          if (paragraphs[i].trim().isNotEmpty) {
            sections.add(
              AnalysisSection(
                title: 'Análisis ${i + 1}',
                content: _formatContent(paragraphs[i]),
                icon: _getIconForIndex(i),
              ),
            );
          }
        }
      } else {
        sections.add(
          AnalysisSection(
            title: 'Análisis de tu Mano',
            content: _formatContent(text),
            icon: Icons.back_hand,
          ),
        );
      }
    }

    return sections;
  }

  String _extractSection(String text, String startMarker, String endMarker) {
    final startIndex = text.indexOf(startMarker);
    if (startIndex == -1) return '';

    int endIndex;
    if (endMarker.isEmpty) {
      endIndex = text.length;
    } else {
      endIndex = text.indexOf(endMarker, startIndex);
      if (endIndex == -1) endIndex = text.length;
    }

    return _formatContent(text.substring(startIndex, endIndex));
  }

  IconData _getIconForSection(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('forma') ||
        lowerTitle.contains('general') ||
        lowerTitle.contains('tipo')) {
      return Icons.back_hand;
    } else if (lowerTitle.contains('línea') ||
        lowerTitle.contains('principales') ||
        lowerTitle.contains('corazón') ||
        lowerTitle.contains('cabeza') ||
        lowerTitle.contains('vida')) {
      return Icons.linear_scale;
    } else if (lowerTitle.contains('detalle') ||
        lowerTitle.contains('adicional') ||
        lowerTitle.contains('textura') ||
        lowerTitle.contains('pulgar')) {
      return Icons.zoom_in;
    } else if (lowerTitle.contains('conclusión') ||
        lowerTitle.contains('resumen') ||
        lowerTitle.contains('personalidad')) {
      return Icons.psychology;
    } else if (lowerTitle.contains('emocional') ||
        lowerTitle.contains('mental') ||
        lowerTitle.contains('aspectos')) {
      return Icons.favorite;
    } else {
      return Icons.star;
    }
  }

  IconData _getIconForIndex(int index) {
    switch (index % 4) {
      case 0:
        return Icons.back_hand;
      case 1:
        return Icons.linear_scale;
      case 2:
        return Icons.zoom_in;
      case 3:
        return Icons.psychology;
      default:
        return Icons.star;
    }
  }

  Widget _buildAnalysisSection(AnalysisSection section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
                      fontSize: 22,
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
                fontSize: 18,
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
