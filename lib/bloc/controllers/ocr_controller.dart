import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ai/firebase_ai.dart';

// Modelos
import '../../data/models/lectura_model.dart';
// Controladores
import 'auth_controller.dart';

class OcrController extends GetxController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  late final GenerativeModel _model;

  // Estados reactivos
  final isLoading = false.obs;
  final error = ''.obs;
  final lecturas = <LecturaModel>[].obs;

  // Obtener controlador de autenticación
  AuthController get authController => Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    _initializeGemini();
    _setupAuthListener();
  }

  // Configurar listener para cambios de autenticación
  void _setupAuthListener() {
    // Escuchar cambios en el UID del usuario
    ever(authController.uid, (String uid) {
      if (uid.isNotEmpty) {
        loadLecturas(); // Método público
      } else {
        lecturas.clear(); // Limpiar si no hay usuario
      }
    });

    // Cargar inicial si ya hay usuario autenticado
    if (authController.uid.value.isNotEmpty) {
      loadLecturas();
    }
  }

  // Inicializar Gemini
  void _initializeGemini() {
    try {
      _model = FirebaseAI.googleAI().generativeModel(model: 'gemini-2.0-flash');
      debugPrint('✅ Gemini inicializado correctamente');
    } catch (e) {
      debugPrint('❌ Error al inicializar Gemini: $e');
    }
  }

  // Analizar imagen con Gemini para quiromancia
  Future<String> _analizarImagenConGemini(File imageFile) async {
    try {
      debugPrint('🔮 Iniciando análisis de quiromancia con Gemini...');

      // Leer los bytes de la imagen
      final Uint8List imageBytes = await imageFile.readAsBytes();

      // Crear el prompt para quiromancia
      const String promptQuiromancia = '''
        Eres un experto en quiromancia con años de experiencia analizando manos. 
        Analiza cuidadosamente esta imagen de una palma de la mano y proporciona una lectura detallada y profesional.

        Tu análisis debe incluir:

        🖐️ **Forma general de la mano:**
        - Tipo de mano (tierra, aire, fuego, agua) según la forma de la palma y longitud de dedos
        - Características generales de personalidad asociadas

        📏 **Principales líneas:**
        - **❤️ Línea del corazón:** Ubicación, forma, longitud y su interpretación emocional
        - **🧠 Línea de la cabeza:** Trayectoria y significado para la mentalidad
        - **💪 Línea de la vida:** Profundidad, longitud y vitalidad
        - Otras líneas importantes si son visibles

        🔍 **Detalles adicionales:**
        - Textura de la piel y callosidades
        - Forma y tamaño del pulgar
        - Montes de la palma (Venus, Luna, etc.)
        - Cualquier marca o característica especial

        🧩 **Conclusión:**
        - Resumen de la personalidad basado en el análisis
        - Fortalezas y características principales
        - Aspectos emocionales y mentales destacados

        Proporciona una lectura empática, positiva y detallada, usando emojis para hacer el texto más atractivo. 
        Mantén un tono profesional pero accesible, como si fueras un quiromántico experimentado dando una consulta personal.
        ''';

      // Preparar el prompt de texto para quiromancia
      final prompt = TextPart(promptQuiromancia);

      // Preparar la imagen para el análisis
      final imagePart = InlineDataPart('image/jpeg', imageBytes);

      // Crear el contenido multimodal con texto e imagen
      final response = await _model.generateContent([
        Content.multi([prompt, imagePart]),
      ]);

      final String analisis =
          response.text ??
          '''
🔮 **Análisis de Quiromancia**

Lo sentimos, no pudimos completar el análisis de tu palma en este momento. 

Esto puede deberse a:
- Problemas de conectividad
- Calidad de la imagen
- Servicio temporalmente no disponible

**Consejos para una mejor lectura:**
- Asegúrate de tener buena iluminación
- Mantén la palma extendida y visible
- Evita sombras sobre la mano
- Intenta nuevamente en unos minutos

¡Vuelve a intentarlo para obtener tu lectura personalizada! 🖐️✨
''';

      debugPrint('✅ Análisis de quiromancia completado');
      debugPrint('📝 Longitud del análisis: ${analisis.length} caracteres');

      return analisis;
    } catch (e) {
      debugPrint('❌ Error al analizar imagen con Gemini: $e');

      // Retornar un mensaje de error amigable
      return '''
🔮 **Análisis de Quiromancia**

Lo sentimos, no pudimos completar el análisis de tu palma en este momento. 

Esto puede deberse a:
- Problemas de conectividad
- Calidad de la imagen
- Servicio temporalmente no disponible

**Consejos para una mejor lectura:**
- Asegúrate de tener buena iluminación
- Mantén la palma extendida y visible
- Evita sombras sobre la mano
- Intenta nuevamente en unos minutos

¡Vuelve a intentarlo para obtener tu lectura personalizada! 🖐️✨
''';
    }
  }

  // Abrir cámara y capturar foto
  Future<void> capturarFoto() async {
    try {
      isLoading(true);
      error('');

      // Verificar que el usuario esté autenticado
      if (authController.uid.value.isEmpty) {
        error('Usuario no autenticado');
        Get.snackbar(
          'Error',
          'Debes iniciar sesión para usar esta función',
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
        return;
      }

      // Abrir cámara
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 85,
      );

      if (photo == null) {
        debugPrint('📸 Captura de foto cancelada');
        return;
      }

      debugPrint('📸 Foto capturada: ${photo.path}');

      // Subir imagen y crear lectura con análisis de IA
      await _subirImagenYCrearLectura(File(photo.path));
    } catch (e) {
      debugPrint('❌ Error al capturar foto: $e');
      error('Error al capturar la foto: $e');
      Get.snackbar(
        'Error',
        'No se pudo capturar la foto',
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  // Subir imagen a Storage y crear lectura en Firestore
  Future<void> _subirImagenYCrearLectura(File imageFile) async {
    try {
      final String userId = authController.uid.value;
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = 'lectura_$timestamp.jpg';

      // Ruta en Storage: usuarios/{userId}/lecturas/{fileName}
      final String storagePath = 'usuarios/$userId/lecturas/$fileName';

      debugPrint('📤 Subiendo imagen a: $storagePath');

      // Subir imagen a Firebase Storage
      final Reference storageRef = _storage.ref().child(storagePath);
      final UploadTask uploadTask = storageRef.putFile(imageFile);

      final TaskSnapshot snapshot = await uploadTask;
      final String imageUrl = await snapshot.ref.getDownloadURL();

      debugPrint('✅ Imagen subida. URL: $imageUrl');

      // Analizar imagen con Gemini
      final String analisisQuiromancia = await _analizarImagenConGemini(
        imageFile,
      );

      // Crear lectura con el análisis
      final LecturaModel nuevaLectura = LecturaModel.empty(
        userId: userId,
        imageUrl: imageUrl,
      ).copyWith(response: [analisisQuiromancia]);

      // Guardar en Firestore
      await _guardarLectura(nuevaLectura);

      Get.snackbar(
        'Éxito',
        'Foto capturada y guardada correctamente',
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('❌ Error al subir imagen: $e');
      error('Error al subir la imagen: $e');
      rethrow;
    }
  }

  // Guardar lectura en Firestore
  Future<void> _guardarLectura(LecturaModel lectura) async {
    try {
      final String userId = lectura.userId;

      // Verificar si existe la colección lecturas, si no la creamos
      final CollectionReference lecturasRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('lecturas');

      // Agregar nueva lectura
      final DocumentReference docRef = await lecturasRef.add(
        lectura.toFirestore(),
      );

      debugPrint('✅ Lectura guardada con ID: ${docRef.id}');

      // Actualizar la lectura con el ID generado
      final LecturaModel lecturaConId = lectura.copyWith(id: docRef.id);
      lecturas.add(lecturaConId);
    } catch (e) {
      debugPrint('❌ Error al guardar lectura: $e');
      error('Error al guardar la lectura: $e');
      rethrow;
    }
  }

  // Cargar lecturas del usuario (método público)
  Future<void> loadLecturas() async {
    try {
      if (authController.uid.value.isEmpty) {
        debugPrint('⚠️ No hay usuario autenticado para cargar lecturas');
        return;
      }

      isLoading(true);
      error(''); // Limpiar errores previos

      final String userId = authController.uid.value;
      debugPrint('📖 Cargando lecturas para usuario: $userId');

      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('lecturas')
          .orderBy('fecha', descending: true)
          .get();

      lecturas.clear();
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        final LecturaModel lectura = LecturaModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
        lecturas.add(lectura);
      }

      debugPrint('✅ Cargadas ${lecturas.length} lecturas exitosamente');
    } catch (e) {
      debugPrint('❌ Error al cargar lecturas: $e');
      error('Error al cargar las lecturas: $e');
    } finally {
      isLoading(false);
    }
  }

  // Obtener una lectura específica
  LecturaModel? getLectura(String id) {
    return lecturas.firstWhereOrNull((lectura) => lectura.id == id);
  }

  // Eliminar lectura
  Future<void> eliminarLectura(String lecturaId) async {
    try {
      if (authController.uid.value.isEmpty) return;

      final String userId = authController.uid.value;

      // Buscar la lectura para obtener la URL de la imagen
      final lectura = lecturas.firstWhereOrNull((l) => l.id == lecturaId);
      if (lectura == null) {
        error('Lectura no encontrada');
        return;
      }

      isLoading(true);

      // Eliminar imagen del Storage
      try {
        final Reference imageRef = _storage.refFromURL(lectura.imageUrl);
        await imageRef.delete();
        debugPrint('✅ Imagen eliminada del Storage');
      } catch (e) {
        debugPrint('⚠️ Error al eliminar imagen del Storage: $e');
        // Continuar aunque falle eliminar la imagen
      }

      // Eliminar de Firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('lecturas')
          .doc(lecturaId)
          .delete();

      // Eliminar de la lista local
      lecturas.removeWhere((lectura) => lectura.id == lecturaId);

      debugPrint('✅ Lectura eliminada completamente');

      Get.snackbar(
        'Éxito',
        'Lectura eliminada correctamente',
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      debugPrint('❌ Error al eliminar lectura: $e');
      error('Error al eliminar la lectura: $e');
      Get.snackbar(
        'Error',
        'No se pudo eliminar la lectura',
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading(false);
    }
  }

  // Limpiar errores
  void clearError() {
    error('');
  }
}
