import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../data/models/user_model.dart';
import 'auth_controller.dart';

class ProfileController extends GetxController {
  // Referencias de Firebase
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  // Estados
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isUploadingImage = false.obs;

  // Datos del perfil
  final RxString profileName = ''.obs;
  final RxString profileEmail = ''.obs;
  final RxString profilePhotoUrl = ''.obs;
  final RxString profileSigno = ''.obs;
  final RxInt profileGenero =
      0.obs; // 0: No especificado, 1: Masculino, 2: Femenino, 3: Otro
  final Rx<DateTime> profileFechaNacimiento = DateTime.now().obs;

  // Opciones para selección
  final List<String> signos = [
    'No especificado',
    'Aries',
    'Tauro',
    'Géminis',
    'Cáncer',
    'Leo',
    'Virgo',
    'Libra',
    'Escorpio',
    'Sagitario',
    'Capricornio',
    'Acuario',
    'Piscis',
  ];

  final List<String> generos = [
    'No especificado',
    'Masculino',
    'Femenino',
    'Otro',
  ];

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  // Cargar datos del perfil desde Firebase
  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      final authController = Get.find<AuthController>();

      if (authController.uid.value.isEmpty) {
        debugPrint('ProfileController: UID vacío, no se puede cargar perfil');
        return;
      }

      final userDoc = await _firestore
          .collection('users')
          .doc(authController.uid.value)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        final userModel = UserModel.fromJson(userData);

        profileName.value = userModel.name;
        profileEmail.value = userModel.email;
        profilePhotoUrl.value = userModel.photoUrl;
        profileSigno.value = userModel.signo;
        profileGenero.value = userModel.genero;
        profileFechaNacimiento.value = userModel.fechaNacimiento;

        // Actualizar también el AuthController
        authController.userName.value = userModel.name;
        authController.userEmail.value = userModel.email;
        authController.profileImage.value = userModel.photoUrl;
      }
    } catch (e) {
      debugPrint('Error al cargar perfil: $e');
      _showError('Error al cargar datos del perfil');
    } finally {
      isLoading.value = false;
    }
  }

  // Seleccionar imagen del dispositivo
  Future<void> selectProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (image != null) {
        await uploadProfileImage(File(image.path));
      }
    } catch (e) {
      debugPrint('Error al seleccionar imagen: $e');
      _showError('Error al seleccionar imagen');
    }
  }

  // Subir imagen a Firebase Storage
  Future<void> uploadProfileImage(File imageFile) async {
    try {
      isUploadingImage.value = true;
      final authController = Get.find<AuthController>();

      if (authController.uid.value.isEmpty) {
        _showError('Error: Usuario no autenticado');
        return;
      }

      // Crear referencia en Storage
      final storageRef = _storage
          .ref()
          .child('profile_images')
          .child('${authController.uid.value}.jpg');

      // Subir archivo
      final uploadTask = storageRef.putFile(imageFile);

      // Mostrar progreso
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        debugPrint(
          'Progreso de subida: ${(progress * 100).toStringAsFixed(2)}%',
        );
      });

      // Esperar a que termine la subida
      final snapshot = await uploadTask;

      // Obtener URL de descarga
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Actualizar URL en el perfil
      profilePhotoUrl.value = downloadUrl;
      authController.profileImage.value = downloadUrl;

      _showSuccess('Imagen actualizada correctamente');
    } catch (e) {
      debugPrint('Error al subir imagen: $e');
      _showError('Error al subir imagen');
    } finally {
      isUploadingImage.value = false;
    }
  }

  // Guardar todos los datos del perfil
  Future<void> saveProfile({
    required String name,
    required String signo,
    required int genero,
    required DateTime fechaNacimiento,
  }) async {
    try {
      isSaving.value = true;
      final authController = Get.find<AuthController>();

      if (authController.uid.value.isEmpty) {
        _showError('Error: Usuario no autenticado');
        return;
      }

      // Crear modelo actualizado
      final updatedUser = UserModel(
        name: name,
        email: profileEmail.value,
        photoUrl: profilePhotoUrl.value,
        language: 'es',
        userType: 'free',
        signo: signo,
        fechaNacimiento: fechaNacimiento,
        genero: genero,
        lecturas: 0,
      );

      // Guardar en Firestore
      await _firestore
          .collection('users')
          .doc(authController.uid.value)
          .update(updatedUser.toJson());

      // Actualizar datos locales
      profileName.value = name;
      profileSigno.value = signo;
      profileGenero.value = genero;
      profileFechaNacimiento.value = fechaNacimiento;

      // Actualizar AuthController
      authController.userName.value = name;

      _showSuccess('Perfil actualizado correctamente');
    } catch (e) {
      debugPrint('Error al guardar perfil: $e');
      _showError('Error al guardar cambios');
    } finally {
      isSaving.value = false;
    }
  }

  // Seleccionar fecha de nacimiento
  Future<void> selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: profileFechaNacimiento.value,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      profileFechaNacimiento.value = picked;
    }
  }

  // Calcular edad
  int get calculatedAge {
    final now = DateTime.now();
    final birthDate = profileFechaNacimiento.value;
    int age = now.year - birthDate.year;

    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  // Obtener texto del género
  String get generoText {
    if (profileGenero.value >= 0 && profileGenero.value < generos.length) {
      return generos[profileGenero.value];
    }
    return generos[0];
  }

  // Obtener texto del signo
  String get signoText {
    if (profileSigno.value.isEmpty) return 'No especificado';
    return profileSigno.value;
  }

  // Mostrar selector de género
  void showGeneroSelector(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Seleccionar Género',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...generos.asMap().entries.map((entry) {
              final index = entry.key;
              final genero = entry.value;
              return ListTile(
                title: Text(
                  genero,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: profileGenero.value == index
                    ? const Icon(Icons.check, color: Color(0xFF7C4DFF))
                    : null,
                onTap: () {
                  profileGenero.value = index;
                  Get.back();
                },
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Mostrar selector de signo zodiacal
  void showSignoSelector(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Seleccionar Signo Zodiacal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: signos.length,
                itemBuilder: (context, index) {
                  final signo = signos[index];
                  return ListTile(
                    title: Text(
                      signo,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: profileSigno.value == signo
                        ? const Icon(Icons.check, color: Color(0xFF7C4DFF))
                        : null,
                    onTap: () {
                      profileSigno.value = signo;
                      Get.back();
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Mostrar mensajes
  void _showSuccess(String message) {
    Get.snackbar(
      'Éxito',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }
}
