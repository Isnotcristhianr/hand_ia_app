import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../widgets/glass/glass_container.dart';
import '../../widgets/master/bg.dart';
import '../../bloc/controllers/profile_controller.dart';

class AccountInfoView extends StatefulWidget {
  const AccountInfoView({super.key});

  @override
  State<AccountInfoView> createState() => _AccountInfoViewState();
}

class _AccountInfoViewState extends State<AccountInfoView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  late ProfileController _profileController;

  @override
  void initState() {
    super.initState();
    _profileController = Get.put(ProfileController());
    _loadUserData();
  }

  void _loadUserData() {
    // Los datos se cargan automáticamente desde el ProfileController
    ever(_profileController.profileName, (name) {
      _nameController.text = name;
    });
    ever(_profileController.profileEmail, (email) {
      _emailController.text = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          Container(decoration: Bg.decoration),

          SafeArea(
            child: Column(
              children: [
                // App Bar personalizada
                _buildCustomAppBar(),

                // Contenido
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Foto de perfil
                        _buildProfilePicture(),

                        const SizedBox(height: 32),

                        // Formulario de información
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildInputField(
                                controller: _nameController,
                                icon: Icons.person_outline,
                                label: "Nombre",
                                enabled: _isEditing,
                              ),

                              const SizedBox(height: 10),

                              _buildInputField(
                                controller: _emailController,
                                icon: Icons.email_outlined,
                                label: "Correo Electrónico",
                                enabled: false, // Email no se puede editar
                              ),

                              const SizedBox(height: 10),

                              // Campos adicionales de perfil
                              _buildAdditionalFields(),

                              const SizedBox(height: 16),

                              // Información adicional
                              _buildInfoSection(),

                              const SizedBox(height: 10),

                              // Botones de acción
                              _buildActionButtons(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        children: [
          // Botón de regreso
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Título
          const Text(
            "Mi Perfil",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Spacer(),

          // Botón de editar
          GestureDetector(
            onTap: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _isEditing ? Icons.close : Icons.edit_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.1),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Obx(() {
                if (_profileController.isUploadingImage.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF7C4DFF)),
                  );
                }

                if (_profileController.profilePhotoUrl.value.isNotEmpty) {
                  return Image.network(
                    _profileController.profilePhotoUrl.value,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      );
                    },
                  );
                } else {
                  return const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  );
                }
              }),
            ),
          ),

          if (_isEditing)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _profileController.selectProfileImage(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C4DFF),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required bool enabled,
  }) {
    return GlassContainer(
      height: 115,
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 20),

              const SizedBox(width: 12),

              Expanded(
                child: TextFormField(
                  controller: controller,
                  enabled: enabled,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Ingresa tu $label",
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  validator: (value) {
                    if (label == "Nombre" && (value == null || value.isEmpty)) {
                      return 'El nombre es requerido';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalFields() {
    return Column(
      children: [
        // Género
        GestureDetector(
          onTap: _isEditing
              ? () => _profileController.showGeneroSelector(context)
              : null,
          child: _buildSelectableField(
            icon: Icons.person_outline,
            label: "Género",
            value: Obx(
              () => Text(
                _profileController.generoText,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            enabled: _isEditing,
          ),
        ),

        const SizedBox(height: 12),

        // Signo Zodiacal
        GestureDetector(
          onTap: _isEditing
              ? () => _profileController.showSignoSelector(context)
              : null,
          child: _buildSelectableField(
            icon: Icons.star_outline,
            label: "Signo Zodiacal",
            value: Obx(
              () => Text(
                _profileController.signoText,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            enabled: _isEditing,
          ),
        ),

        const SizedBox(height: 12),

        // Fecha de Nacimiento
        GestureDetector(
          onTap: _isEditing
              ? () => _profileController.selectBirthDate(context)
              : null,
          child: _buildSelectableField(
            icon: Icons.cake_outlined,
            label: "Fecha de Nacimiento",
            value: Obx(() {
              final date = _profileController.profileFechaNacimiento.value;
              return Text(
                DateFormat('dd/MM/yyyy').format(date),
                style: const TextStyle(color: Colors.white),
              );
            }),
            enabled: _isEditing,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectableField({
    required IconData icon,
    required String label,
    required Widget value,
    required bool enabled,
  }) {
    return GlassContainer(
      height: 80,
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                value,
              ],
            ),
          ),
          if (enabled)
            Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white.withValues(alpha: 0.5),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return GlassContainer(
      height: 215,
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Información Adicional",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          _buildInfoItem(
            icon: Icons.calendar_today_outlined,
            title: "Miembro desde",
            subtitle: "Enero 2024",
          ),

          _buildInfoItem(
            icon: Icons.star_outline,
            title: "Tipo de cuenta",
            subtitle: "Usuario gratuito",
          ),

          Obx(
            () => _buildInfoItem(
              icon: Icons.cake_outlined,
              title: "Edad",
              subtitle: "${_profileController.calculatedAge} años",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 20),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    if (!_isEditing) return const SizedBox.shrink();

    return Column(
      children: [
        // Botón Guardar Cambios
        SizedBox(
          width: double.infinity,
          height: 50,
          child: Obx(
            () => ElevatedButton(
              onPressed: _profileController.isSaving.value
                  ? null
                  : _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C4DFF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: _profileController.isSaving.value
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Guardando...",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : const Text(
                      "Guardar Cambios",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Botón Cancelar
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _isEditing = false;
                // Recargar datos originales
                _nameController.text = _profileController.profileName.value;
                _emailController.text = _profileController.profileEmail.value;
              });
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              "Cancelar",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      _profileController.saveProfile(
        name: _nameController.text.trim(),
        signo: _profileController.profileSigno.value,
        genero: _profileController.profileGenero.value,
        fechaNacimiento: _profileController.profileFechaNacimiento.value,
      );

      setState(() {
        _isEditing = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
