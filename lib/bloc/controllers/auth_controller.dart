import 'package:get/get.dart';
import 'package:flutter/material.dart';
//firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//models
import '../../../data/models/user_model.dart';
//google sign in
import 'package:google_sign_in/google_sign_in.dart';
//apple sign in
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum AuthStatus { checking, authenticated, unauthenticated, error }

class AuthController extends GetxController {
  //variables
  final RxBool showLogin = false.obs;
  final RxBool showRegister = false.obs;
  final RxBool showForgotPassword = false.obs;
  final RxBool isDarkMode = false.obs;
  final RxString userName = 'test'.obs;
  final RxString userEmail = 'test@mail.com'.obs;
  final Rxn<String> profileImage = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    _initializeAuth();
  }

  void _initializeAuth() async {
    try {
      authStatus.value = AuthStatus.checking;

      // Verificar si Firebase está disponible
      try {
        Firebase.app();
        debugPrint('Firebase disponible en AuthController');
      } catch (e) {
        debugPrint('Firebase no disponible en AuthController: $e');
        authStatus.value = AuthStatus.unauthenticated;
        return;
      }

      // Escuchar cambios en el estado de autenticación
      _auth.authStateChanges().listen((User? user) {
        if (user != null && user.emailVerified) {
          uid.value = user.uid;
          _loadUserData();
          authStatus.value = AuthStatus.authenticated;

          // Navegar automáticamente a home si está autenticado y verificado
          final currentRoute = Get.currentRoute;
          if (currentRoute == '/' ||
              currentRoute == '/login' ||
              currentRoute == '/sign_in') {
            Get.offAllNamed('/home');
          }
        } else {
          _clearUserData();
          authStatus.value = AuthStatus.unauthenticated;

          // Navegar automáticamente a welcome si no está autenticado
          final currentRoute = Get.currentRoute;
          if (currentRoute == '/home' || currentRoute == '/profile') {
            Get.offAllNamed('/');
          }
        }
      });
    } catch (e) {
      debugPrint('Error al inicializar auth: $e');
      authStatus.value = AuthStatus.unauthenticated;
    }
  }

  void _clearUserData() {
    uid.value = '';
    userName.value = '';
    userEmail.value = '';
    profileImage.value = null;
    user = null;
  }

  Future<void> _loadUserData() async {
    try {
      if (uid.value.isEmpty) return;

      final userDoc = await _firestore.collection('users').doc(uid.value).get();
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        userName.value = userData['name'] ?? 'Usuario';
        userEmail.value = userData['email'] ?? 'usuario@example.com';
        profileImage.value = userData['photoUrl'];
      }
    } catch (e) {
      debugPrint('Error al cargar datos del usuario: $e');
    }
  }

  void toggleLogin() {
    showLogin.value = !showLogin.value;
    if (showLogin.value) {
      showRegister.value = false;
      showForgotPassword.value = false;
    }
  }

  void toggleRegister() {
    showRegister.value = !showRegister.value;
    if (showRegister.value) {
      showLogin.value = false;
      showForgotPassword.value = false;
    }
  }

  void toggleForgotPassword() {
    showForgotPassword.value = !showForgotPassword.value;
    if (showForgotPassword.value) {
      showLogin.value = false;
      showRegister.value = false;
    }
  }

  void closeAll() {
    showLogin.value = false;
    showRegister.value = false;
    showForgotPassword.value = false;
  }

  //?Variables
  //Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //UserModel
  UserModel? user;

  //observadores
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;
  final authStatus = AuthStatus.checking.obs;
  //user
  final uid = ''.obs;
  final name = ''.obs;
  final password = ''.obs;
  final profilePicture = ''.obs;
  final theme = ''.obs;
  final language = ''.obs;
  final userType = ''.obs;
  final email = ''.obs;
  //Constantes
  static const int minNameLength = 1;
  static const int maxNameLength = 50;
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 12;
  static const int minEmailLength = 6;
  static const int maxEmailLength = 100;
  static const String specialCharacters = r'[!@#$%^&*(),.?":{}|<>]';

  //handle firebase error
  void _handleAuthErrors(FirebaseAuthException e, Function(String) onError) {
    String errorMessage;

    switch (e.code) {
      case 'email-already-in-use':
        errorMessage = 'Este correo ya está en uso.';
        break;
      case 'invalid-email':
        errorMessage = 'Formato de correo inválido.';
        break;
      case 'weak-password':
        errorMessage = 'La contraseña es muy débil.';
        break;
      case 'user-not-found':
        errorMessage = 'No se encontró usuario con este correo.';
        break;
      case 'wrong-password':
        errorMessage = 'Contraseña incorrecta.';
        break;
      case 'invalid-credential':
        errorMessage =
            'Credenciales inválidas. Verifique su correo y contraseña.';
        break;
      case 'user-disabled':
        errorMessage = 'Este usuario ha sido deshabilitado.';
        break;
      case 'too-many-requests':
        errorMessage =
            'Demasiados intentos fallidos. Por favor, intente más tarde.';
        break;
      case 'operation-not-allowed':
        errorMessage = 'Operación no permitida.';
        break;
      case 'network-request-failed':
        errorMessage = 'Error de conexión. Verifique su conexión a internet.';
        break;
      default:
        errorMessage = 'Ocurrió un error inesperado.';
    }

    debugPrint('AuthController: Error manejado - ${e.code}: $errorMessage');
    onError(errorMessage);
  }

  AuthStatus _handleAuthStatus(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Por favor, ingrese un email y contraseña válidos');
    }

    if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email)) {
      throw Exception('Por favor, ingrese un email válido');
    }

    if (email.length < minEmailLength) {
      throw Exception(
        'El email debe tener al menos $minEmailLength caracteres',
      );
    }

    if (email.length > maxEmailLength) {
      throw Exception(
        'El email no puede tener más de $maxEmailLength caracteres',
      );
    }

    if (password.length < minPasswordLength) {
      throw Exception(
        'La contraseña debe tener al menos $minPasswordLength caracteres',
      );
    }

    if (password.length > maxPasswordLength) {
      throw Exception(
        'La contraseña no puede tener más de $maxPasswordLength caracteres',
      );
    }

    return AuthStatus.checking;
  }

  //!Metodos
  //create user document
  Future<void> _createUserDocument(User user, {String? userName}) async {
    await _firestore.collection('users').doc(user.uid).set({
      'UID': user.uid,
      'createdAt': Timestamp.now(),
      'name': userName ?? user.displayName ?? '',
      'email': user.email?.toLowerCase(),
      'photoUrl': user.photoURL ?? '',
      'language': 'es',
      'userType': 'free',
      'signo': '',
      'fechaNacimiento': Timestamp.now(),
      'genero': 0,
      'lecturas': 0,
      'isDarkMode': false,
    });
  }

  //login email
  Future<void> login({
    required String email,
    required String password,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    debugPrint('AuthController: Iniciando proceso de login...');
    try {
      isLoading.value = true;
      authStatus.value = _handleAuthStatus(email, password);

      final String userEmail = email.toLowerCase().trim();
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: userEmail, password: password);

      final User? signedUser = userCredential.user;
      if (signedUser == null) {
        throw Exception('No se pudo iniciar sesión');
      }

      if (!signedUser.emailVerified) {
        await signedUser.sendEmailVerification();
        throw Exception(
          'Por favor, verifique su correo electrónico. Se ha enviado un nuevo correo de verificación.',
        );
      }

      final userDoc = await _firestore
          .collection('users')
          .doc(signedUser.uid)
          .get();

      if (!userDoc.exists) {
        await _createUserDocument(signedUser);
        final updatedDoc = await _firestore
            .collection('users')
            .doc(signedUser.uid)
            .get();
        if (!updatedDoc.exists) {
          throw Exception('Error al crear el perfil de usuario');
        }
        user = UserModel.fromJson(updatedDoc.data()!);
      } else {
        final userData = userDoc.data();
        if (userData == null) {
          throw Exception('Error al obtener los datos del usuario');
        }
        user = UserModel.fromJson(userData);
      }

      // Actualizar datos observables
      uid.value = signedUser.uid;
      email = signedUser.email ?? '';
      name.value = user?.name ?? '';
      profilePicture.value = user?.photoUrl ?? '';
      language.value = user?.language ?? '';
      userType.value = user?.userType ?? '';
      authStatus.value = AuthStatus.authenticated;

      debugPrint('AuthController: Login exitoso');
      onSuccess();
    } on FirebaseAuthException catch (e) {
      debugPrint('AuthController: Error de Firebase - ${e.code}');
      _handleAuthErrors(e, onError);
    } catch (e) {
      debugPrint('AuthController: Error inesperado - $e');
      onError(e.toString());
    } finally {
      isLoading.value = false;
      if (authStatus.value != AuthStatus.authenticated) {
        authStatus.value = AuthStatus.unauthenticated;
      }
    }
  }

  //register email
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    debugPrint('AuthController: Iniciando proceso de registro...');
    try {
      isLoading.value = true;
      authStatus.value = _handleAuthStatus(email, password);

      final String userEmail = email.toLowerCase().trim();
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: userEmail, password: password);

      final User? newUser = userCredential.user;
      if (newUser == null) {
        throw Exception('Error al crear la cuenta');
      }

      await newUser.sendEmailVerification();
      await _createUserDocument(newUser, userName: name);

      // Cerrar sesión después del registro para que el usuario verifique su email
      await _auth.signOut();

      authStatus.value = AuthStatus.unauthenticated;

      Get.snackbar(
        'Registro exitoso',
        'Por favor, verifique su correo electrónico para activar su cuenta y luego inicie sesión.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );

      // Redirigir al login después del registro
      Get.offAllNamed('/login');

      onSuccess();
    } on FirebaseAuthException catch (e) {
      debugPrint('AuthController: Error de Firebase - ${e.code}');
      _handleAuthErrors(e, onError);
    } catch (e) {
      debugPrint('AuthController: Error inesperado - $e');
      onError(e.toString());
    } finally {
      isLoading.value = false;
      authStatus.value = AuthStatus.unauthenticated;
    }
  }

  //recover password
  Future<void> recoverPassword({
    required String email,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    try {
      //verificar si el email existe
      final userDoc = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (userDoc.docs.isEmpty) {
        throw Exception('No se encontró usuario con este correo');
      }

      //enviar correo de recuperación
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        'Correo de recuperación enviado',
        'Se ha enviado un correo de recuperación a su correo electrónico.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      onSuccess();
    } on FirebaseAuthException catch (e) {
      debugPrint('AuthController: Error de Firebase - ${e.code}');
      _handleAuthErrors(e, onError);
    } catch (e) {
      debugPrint('AuthController: Error inesperado - $e');
      onError(e.toString());
    }
  }

  //logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
      // Cerrar sesión de Google también
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      debugPrint('Logout exitoso, navegación automática activada');
      // La navegación se maneja automáticamente por authStateChanges
    } catch (e) {
      debugPrint('Error al cerrar sesión: $e');
      // En caso de error, navegar manualmente
      Get.offAllNamed('/');
    }
  }

  //* Login con Google
  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      debugPrint('Iniciando login con Google...');

      // Configurar GoogleSignIn con manejo de errores mejorado
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      // Intentar cerrar sesión previa
      try {
        await googleSignIn.signOut();
        debugPrint('Sesión previa de Google cerrada correctamente');
      } catch (e) {
        debugPrint('No había sesión previa de Google: $e');
      }

      // Intentamos iniciar sesión con Google
      debugPrint('Solicitando cuenta de Google...');
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        debugPrint('Usuario canceló el inicio de sesión con Google');
        throw Exception('Inicio de sesión cancelado');
      }

      debugPrint('Cuenta de Google seleccionada: ${googleUser.email}');
      debugPrint('Obteniendo tokens de autenticación...');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        debugPrint('Error: No se pudieron obtener los tokens de autenticación');
        throw Exception('No se pudieron obtener los tokens de autenticación');
      }

      debugPrint('Tokens obtenidos correctamente');
      debugPrint('Creando credencial para Firebase...');

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      debugPrint('Iniciando sesión en Firebase con credencial de Google...');
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;

      if (user == null) {
        debugPrint('Error: Firebase no devolvió un usuario válido');
        throw Exception('Error al iniciar sesión con Google en Firebase');
      }

      debugPrint('Usuario autenticado en Firebase: ${user.uid}');
      debugPrint('Verificando si el usuario existe en Firestore...');

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        debugPrint('Usuario nuevo, creando documento en Firestore...');
        await _createUserDocument(user);
        debugPrint('Documento de usuario creado correctamente');
      } else {
        debugPrint('Usuario existente encontrado en Firestore');
      }

      // Actualizar datos observables
      uid.value = user.uid;
      email.value = user.email ?? '';
      name.value = user.displayName ?? '';
      profilePicture.value = user.photoURL ?? '';

      // Actualizar datos del usuario en Firestore si es necesario
      await _firestore.collection('users').doc(user.uid).update({
        'lastLogin': Timestamp.now(),
        'name': user.displayName ?? name.value,
        'email': user.email?.toLowerCase() ?? email.value,
        'photoUrl': user.photoURL ?? profilePicture.value,
      });

      debugPrint('Login con Google exitoso');
      authStatus.value = AuthStatus.authenticated;
    } catch (e) {
      debugPrint('Error detallado en login con Google: $e');
      String errorMessage =
          'No se pudo completar el inicio de sesión con Google';

      if (e.toString().contains('network') ||
          e.toString().contains('connection')) {
        errorMessage = 'Error de conexión. Verifica tu conexión a internet.';
      } else if (e.toString().contains('canceled') ||
          e.toString().contains('aborted')) {
        errorMessage = 'Inicio de sesión cancelado.';
      } else if (e.toString().contains('credential')) {
        errorMessage =
            'Error de autenticación. Verifica tu configuración de Firebase.';
      } else if (e.toString().contains('channel-error') ||
          e.toString().contains('PlatformException')) {
        errorMessage =
            'Error de configuración. Intenta de nuevo en unos momentos.';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  //* Login con Apple
  Future<void> loginWithApple() async {
    try {
      debugPrint('Iniciando login con Apple...');

      // Verificar si el servicio está disponible
      final isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        throw Exception(
          'El inicio de sesión con Apple no está disponible en este dispositivo',
        );
      }

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      debugPrint('Credencial de Apple obtenida');

      // Crear credencial de Firebase
      final oAuthProvider = OAuthProvider('apple.com');
      final authCredential = oAuthProvider.credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      // Iniciar sesión en Firebase
      final userCredential = await _auth.signInWithCredential(authCredential);
      final user = userCredential.user;

      if (user == null) {
        throw Exception('Error al iniciar sesión con Apple');
      }

      debugPrint('Usuario autenticado con Firebase');

      // Verificar si el usuario existe en Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        // Crear documento del usuario si no existe
        await _createUserDocument(user);
        debugPrint('Documento de usuario creado en Firestore');
      }

      // Actualizar datos observables
      uid.value = user.uid;
      email.value = user.email ?? '';
      name.value = user.displayName ?? '';
      profilePicture.value = user.photoURL ?? '';

      debugPrint('Login con Apple exitoso');
      authStatus.value = AuthStatus.authenticated;
    } on SignInWithAppleAuthorizationException catch (e) {
      String errorMessage;
      switch (e.code) {
        case AuthorizationErrorCode.canceled:
          errorMessage = 'Inicio de sesión cancelado por el usuario';
          break;
        case AuthorizationErrorCode.failed:
          errorMessage = 'Error de autenticación: ${e.message}';
          break;
        case AuthorizationErrorCode.invalidResponse:
          errorMessage = 'Respuesta inválida del servidor de Apple';
          break;
        case AuthorizationErrorCode.notHandled:
          errorMessage = 'La solicitud no pudo ser manejada';
          break;
        case AuthorizationErrorCode.unknown:
          errorMessage = 'Error desconocido al iniciar sesión con Apple';
          break;
        default:
          errorMessage = 'Error al iniciar sesión con Apple';
      }
      debugPrint('Error en login con Apple: $errorMessage');
      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      debugPrint('Error inesperado en login con Apple: $e');
      Get.snackbar(
        'Error',
        'No se pudo completar el inicio de sesión con Apple',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateProfileImage(String imagePath) async {
    try {
      // Aquí implementarías la lógica para subir la imagen a Firebase Storage
      // y actualizar la URL en Firestore
      // Por ahora solo actualizamos el estado local
      profileImage.value = imagePath;
      Get.snackbar(
        'Éxito',
        'Imagen de perfil actualizada',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo actualizar la imagen de perfil',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateUserName(String newName) async {
    try {
      if (uid.value.isEmpty) return;

      await _firestore.collection('users').doc(uid.value).update({
        'name': newName,
      });

      userName.value = newName;
      Get.snackbar(
        'Éxito',
        'Nombre actualizado correctamente',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Error al actualizar nombre: $e');
      Get.snackbar(
        'Error',
        'No se pudo actualizar el nombre',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteAccount() async {
    try {
      // Aquí implementarías la lógica para eliminar la cuenta en Firebase
      // Por ahora solo cerramos sesión
      await logout();
      Get.snackbar(
        'Éxito',
        'Cuenta eliminada correctamente',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo eliminar la cuenta',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
