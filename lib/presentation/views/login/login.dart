import 'package:flutter/material.dart';
import 'package:get/get.dart';
//widgets
import '../../../widgets/glass/glass_container.dart';
import '../../../widgets/glass/glass_btn.dart';
import '../../../widgets/master/bg.dart';
//controller
import '../../../bloc/controllers/auth_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  final AuthController _authController = Get.put(AuthController());

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Por favor complete todos los campos',
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    _authController.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      onSuccess: () {
        // La navegación se maneja automáticamente por el AuthController
        debugPrint('Login exitoso, navegación automática activada');
      },
      onError: (error) {
        Get.snackbar(
          'Error de inicio de sesión',
          error,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: Bg.decoration,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28.0,
                  vertical: 80.0,
                ),
                child: Column(
                  children: [
                    //back button
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    // Título de bienvenida
                    Text(
                      'Bienvenido de vuelta',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Inicia sesión para continuar',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 24),

                    // Formulario de login
                    GlassContainer(
                      height: 300,
                      borderRadius: 20,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Campo de email
                          _buildInputField(
                            controller: _emailController,
                            hintText: 'Correo electrónico',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 14),

                          // Campo de contraseña
                          _buildInputField(
                            controller: _passwordController,
                            hintText: 'Contraseña',
                            icon: Icons.lock_outline,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Botón de iniciar sesión
                          Obx(
                            () => GlassButton(
                              text: _authController.isLoading.value
                                  ? 'Iniciando...'
                                  : 'Iniciar Sesión',
                              onTap: _authController.isLoading.value
                                  ? () {}
                                  : _login,
                              height: 50,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // ¿Olvidaste tu contraseña?
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/forgot');
                            },
                            child: Text(
                              '¿Olvidaste tu contraseña?',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Divisor
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.white.withValues(alpha: 0.3),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'O continúa con',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.white.withValues(alpha: 0.3),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Botones de login social
                    Row(
                      children: [
                        Expanded(
                          child: GlassContainer(
                            height: 48,
                            borderRadius: 135,
                            child: InkWell(
                              onTap: () {
                                _authController.loginWithGoogle();
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.g_mobiledata_outlined,
                                    color: Colors.white.withValues(alpha: 0.9),
                                    size: 28,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Google',
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GlassContainer(
                            height: 48,
                            borderRadius: 35,
                            child: InkWell(
                              onTap: () {
                                _authController.loginWithApple();
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.apple,
                                    color: Colors.white.withValues(alpha: 0.9),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Apple',
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // ¿No tienes cuenta?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¿No tienes una cuenta? ',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/sign_in');
                          },
                          child: Text(
                            'Regístrate',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 16,
          ),
          prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: 0.6)),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
