import 'package:flutter/material.dart';
//widgets
import '../../../widgets/glass/glass_container.dart';
import '../../../widgets/glass/glass_btn.dart';
import '../../../widgets/master/bg.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: Bg.decoration,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 28.0,
              vertical: 20.0,
            ),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Botón de regresar
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

                if (!_emailSent) ...[
                  // Vista de solicitud de recuperación
                  _buildRequestView(),
                ] else ...[
                  // Vista de confirmación
                  _buildConfirmationView(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestView() {
    return Column(
      children: [
        // Título
        Text(
          '¿Olvidaste tu contraseña?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 16),

        Text(
          'No te preocupes, te enviaremos instrucciones para restablecerla',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 16,
            fontWeight: FontWeight.w300,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 40),

        // Icono de email
        GlassContainer(
          width: 120,
          height: 120,
          borderRadius: 60,
          child: Icon(
            Icons.email_outlined,
            size: 60,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),

        const SizedBox(height: 40),

        // Formulario
        GlassContainer(
          borderRadius: 20,
          height: 235,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                'Ingresa tu correo electrónico',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Campo de email
              _buildInputField(
                controller: _emailController,
                hintText: 'Correo electrónico',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 24),

              // Botón de enviar
              GlassButton(
                text: 'Enviar Instrucciones',
                onTap: () {
                  if (_emailController.text.isNotEmpty) {
                    setState(() {
                      _emailSent = true;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Por favor ingresa tu correo electrónico',
                        ),
                        backgroundColor: Colors.orange.withValues(alpha: 0.8),
                      ),
                    );
                  }
                },
                height: 54,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationView() {
    return Column(
      children: [
        // Título de confirmación
        Text(
          'Revisa tu correo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 16),

        Text(
          'Te hemos enviado las instrucciones para restablecer tu contraseña a:',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 16,
            fontWeight: FontWeight.w300,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        Text(
          _emailController.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 40),

        // Icono de confirmación
        GlassContainer(
          width: 120,
          height: 120,
          borderRadius: 60,
          child: Icon(
            Icons.mark_email_read_outlined,
            size: 60,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),

        const SizedBox(height: 40),

        // Instrucciones adicionales
        GlassContainer(
          borderRadius: 20,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                'Sigue estos pasos:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              _buildStep('1', 'Revisa tu bandeja de entrada'),
              const SizedBox(height: 12),
              _buildStep('2', 'Abre el email que te enviamos'),
              const SizedBox(height: 12),
              _buildStep('3', 'Haz clic en el enlace para restablecer'),
              const SizedBox(height: 12),
              _buildStep('4', 'Crea tu nueva contraseña'),

              const SizedBox(height: 24),

              // Botón de reenviar
              GlassButton(
                text: 'Reenviar Email',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Email reenviado exitosamente'),
                      backgroundColor: Colors.green.withValues(alpha: 0.8),
                    ),
                  );
                },
                height: 50,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Volver al login
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: Colors.white.withValues(alpha: 0.8),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Volver al inicio de sesión',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep(String number, String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
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
        keyboardType: keyboardType,
        style: TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 16,
          ),
          prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: 0.6)),
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
