import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Modelos
import '../../data/models/lectura_model.dart';
// Controladores
import 'auth_controller.dart';

class OcrController extends GetxController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  // Estados reactivos
  final isLoading = false.obs;
  final error = ''.obs;
  final lecturas = <LecturaModel>[].obs;

  // Obtener controlador de autenticación
  AuthController get authController => Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    _loadLecturas();
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

      // Subir imagen y crear lectura
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

      // Crear lectura
      final LecturaModel nuevaLectura = LecturaModel.empty(
        userId: userId,
        imageUrl: imageUrl,
      );

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

  // Cargar lecturas del usuario
  Future<void> _loadLecturas() async {
    try {
      if (authController.uid.value.isEmpty) return;

      final String userId = authController.uid.value;

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

      debugPrint('📖 Cargadas ${lecturas.length} lecturas');
    } catch (e) {
      debugPrint('❌ Error al cargar lecturas: $e');
      error('Error al cargar las lecturas: $e');
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
