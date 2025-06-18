import 'package:flutter/material.dart';
import 'package:get/get.dart';

//controllers
import '../bloc/controllers/auth_controller.dart';
//services
import '../services/firebase_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    debugPrint('AuthMiddleware: Verificando ruta $route');

    try {
      // Verificar si Firebase está disponible usando FirebaseService
      final firebaseService = Get.isRegistered<FirebaseService>()
          ? Get.find<FirebaseService>()
          : null;

      if (firebaseService == null || !firebaseService.isAvailable) {
        debugPrint('Firebase no disponible en middleware');
        // Si Firebase no está disponible, permitir acceso a rutas públicas
        if (route == '/' ||
            route == '/login' ||
            route == '/sign_in' ||
            route == '/forgot') {
          return null; // Permitir acceso
        }
        return const RouteSettings(name: '/'); // Redirigir a welcome
      }

      debugPrint('Firebase disponible en middleware');

      // Si Firebase está disponible, verificar autenticación
      if (Get.isRegistered<AuthController>()) {
        final authController = Get.find<AuthController>();

        switch (authController.authStatus.value) {
          case AuthStatus.authenticated:
            // Usuario autenticado
            if (route == '/' || route == '/login' || route == '/sign_in') {
              debugPrint('Usuario autenticado, redirigiendo a /home');
              return const RouteSettings(name: '/home');
            }
            break;
          case AuthStatus.unauthenticated:
            // Usuario no autenticado
            if (route == '/home' || route == '/profile') {
              debugPrint('Usuario no autenticado, redirigiendo a /');
              return const RouteSettings(name: '/');
            }
            break;
          case AuthStatus.checking:
            // Todavía verificando, permitir acceso
            debugPrint('Verificando autenticación...');
            break;
          case AuthStatus.error:
            // Error de autenticación, tratar como no autenticado
            if (route == '/home' || route == '/profile') {
              debugPrint('Error de autenticación, redirigiendo a /');
              return const RouteSettings(name: '/');
            }
            break;
        }
      }
    } catch (e) {
      debugPrint('Error en AuthMiddleware: $e');
      // En caso de error, permitir acceso a rutas públicas
      if (route == '/home' || route == '/profile') {
        return const RouteSettings(name: '/');
      }
    }

    return null; // Permitir acceso a la ruta original
  }
}
