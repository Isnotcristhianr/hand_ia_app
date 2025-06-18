import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import '../firebase_options.dart';

class FirebaseService extends GetxService {
  static FirebaseService get instance => Get.find<FirebaseService>();

  final RxBool _isInitialized = false.obs;
  final RxBool _isAvailable = false.obs;
  final RxString _initializationError = ''.obs;

  bool get isInitialized => _isInitialized.value;
  bool get isAvailable => _isAvailable.value;
  String get initializationError => _initializationError.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      debugPrint('🔥 Iniciando validación de Firebase...');

      // Verificar si Firebase ya está inicializado
      try {
        Firebase.app();
        debugPrint('✅ Firebase ya estaba inicializado');
        _isInitialized.value = true;
        _isAvailable.value = true;
        return;
      } catch (e) {
        debugPrint(
          '⚠️ Firebase no está inicializado, procediendo a inicializar...',
        );
      }

      // Intentar inicializar Firebase con opciones específicas de plataforma
      debugPrint('🔧 Inicializando Firebase con opciones de plataforma...');
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Verificar que la inicialización fue exitosa
      final app = Firebase.app();
      debugPrint('✅ Firebase inicializado exitosamente');
      debugPrint('📱 Firebase App Name: ${app.name}');
      debugPrint('🔧 Firebase Options: ${app.options.projectId}');

      _isInitialized.value = true;
      _isAvailable.value = true;
      _initializationError.value = '';
    } catch (e) {
      debugPrint('❌ Error al inicializar Firebase: $e');
      _isInitialized.value =
          true; // Marcamos como "inicializado" pero no disponible
      _isAvailable.value = false;
      _initializationError.value = e.toString();

      _showFirebaseError(e.toString());
    }
  }

  void _showFirebaseError(String error) {
    if (error.contains('channel-error')) {
      debugPrint('🔍 Error de canal detectado - posibles causas:');
      debugPrint('   • google-services.json faltante (Android)');
      debugPrint('   • GoogleService-Info.plist faltante (iOS)');
      debugPrint('   • Configuración incorrecta de Firebase');
      debugPrint('   • Problemas de red o emulador');
    }
  }

  // Método para reintentar la inicialización
  Future<bool> retryInitialization() async {
    debugPrint('🔄 Reintentando inicialización de Firebase...');
    await _initializeFirebase();
    return _isAvailable.value;
  }

  // Método para verificar el estado actual
  Map<String, dynamic> getFirebaseStatus() {
    return {
      'isInitialized': _isInitialized.value,
      'isAvailable': _isAvailable.value,
      'error': _initializationError.value,
      'canUseAuth': _isAvailable.value,
      'canUseFirestore': _isAvailable.value,
    };
  }

  // Método para configurar Firebase manualmente (útil para desarrollo)
  Future<bool> configureFirebaseManually() async {
    try {
      debugPrint(
        '🔧 Configurando Firebase manualmente con DefaultFirebaseOptions...',
      );

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Verificar que funcionó
      final app = Firebase.app();
      debugPrint('✅ Firebase configurado manualmente exitosamente');
      debugPrint('📱 Project ID: ${app.options.projectId}');

      _isInitialized.value = true;
      _isAvailable.value = true;
      _initializationError.value = '';

      return true;
    } catch (e) {
      debugPrint('❌ Error en configuración manual: $e');
      return false;
    }
  }
}
