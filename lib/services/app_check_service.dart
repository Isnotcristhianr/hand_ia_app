import 'package:flutter/foundation.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:get/get.dart';

class AppCheckService extends GetxService {
  static AppCheckService get instance => Get.find<AppCheckService>();

  final RxBool _isInitialized = false.obs;
  final RxString _initializationError = ''.obs;

  bool get isInitialized => _isInitialized.value;
  String get initializationError => _initializationError.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeAppCheck();
  }

  Future<void> _initializeAppCheck() async {
    try {
      debugPrint('🛡️ Inicializando Firebase App Check...');

      await FirebaseAppCheck.instance.activate(
        // Para Android - usar Play Integrity en producción, debug en desarrollo
        androidProvider: kDebugMode
            ? AndroidProvider.debug
            : AndroidProvider.playIntegrity,

        // Para iOS/macOS - App Attest con fallback a Device Check
        appleProvider: kDebugMode
            ? AppleProvider.debug
            : AppleProvider.appAttestWithDeviceCheckFallback,

        // Para Web (opcional)
        webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
      );

      _isInitialized.value = true;
      _initializationError.value = '';
      debugPrint('✅ Firebase App Check inicializado correctamente');

      // Obtener token de prueba para verificar funcionamiento
      if (kDebugMode) {
        await _getDebugToken();
      }
    } catch (e) {
      debugPrint('❌ Error al inicializar Firebase App Check: $e');
      _isInitialized.value = false;
      _initializationError.value = e.toString();
    }
  }

  Future<void> _getDebugToken() async {
    try {
      final token = await FirebaseAppCheck.instance.getToken();
      if (token != null) {
        debugPrint('🔑 App Check Token obtenido: ${token.substring(0, 20)}...');
      } else {
        debugPrint('⚠️ No se pudo obtener el token de App Check');
      }
    } catch (e) {
      debugPrint('❌ Error al obtener token de App Check: $e');
    }
  }

  // Método para obtener token manualmente
  Future<String?> getToken() async {
    try {
      final token = await FirebaseAppCheck.instance.getToken();
      return token;
    } catch (e) {
      debugPrint('❌ Error al obtener token: $e');
      return null;
    }
  }

  // Método para verificar el estado
  Map<String, dynamic> getAppCheckStatus() {
    return {
      'isInitialized': _isInitialized.value,
      'error': _initializationError.value,
      'canGetTokens':
          _isInitialized.value && _initializationError.value.isEmpty,
    };
  }
}
