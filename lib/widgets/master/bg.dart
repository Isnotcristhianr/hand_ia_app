import 'package:flutter/material.dart';

class Bg {
  static const BoxDecoration decoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromARGB(255, 0, 0, 0),
        Color(0xFF16213E),
        Color.fromARGB(255, 95, 31, 177),
        Color.fromARGB(255, 100, 22, 218),
        Color(0xFF5E17EB),
      ],
      stops: [0.0, 0.2, 0.4, 0.7, 1.0],
    ),
  );
}

//topbar color
class Topbar {
  static const BoxDecoration decoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromARGB(255, 0, 0, 0),
        Color(0xFF16213E),
        Color.fromARGB(255, 95, 31, 177),
        Color.fromARGB(255, 100, 22, 218),
        Color(0xFF5E17EB),
      ],
      stops: [0.0, 0.2, 0.4, 0.7, 1.0],
    ),
  );
}