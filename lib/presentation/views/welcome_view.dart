import 'package:flutter/material.dart';

//widgets
import '../../widgets/master/bg.dart';
import '../../widgets/welcome/logo.dart';
import '../../widgets/welcome/lema.dart';
import '../../widgets/welcome/descripcion.dart';
import '../../widgets/welcome/caracteristicas.dart';
import '../../widgets/buttons/startbtn.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: Bg.decoration,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Logo y título principal
                Logo.buildLogo(),

                const SizedBox(height: 12),

                // Subtítulo
                Lema.buildLema(),

                const SizedBox(height: 40),

                // Descripción principal
                Descripcion.buildMainDescription(),

                const SizedBox(height: 48),

                // Características
                Caracteristicas.buildFeatures(),

                const Spacer(flex: 3),

                // Botón empezar
                StartButton.buildStartButton(context),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
