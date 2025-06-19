// Importar cloud_firestore para Timestamp
import 'package:cloud_firestore/cloud_firestore.dart';

class LecturaModel {
  final String id;
  final String imageUrl;
  final List<String> response;
  final DateTime fecha;
  final String userId;

  LecturaModel({
    required this.id,
    required this.imageUrl,
    required this.response,
    required this.fecha,
    required this.userId,
  });

  // Convertir desde Firestore
  factory LecturaModel.fromFirestore(Map<String, dynamic> data, String id) {
    return LecturaModel(
      id: id,
      imageUrl: data['imageUrl'] ?? '',
      response: List<String>.from(data['response'] ?? []),
      fecha: (data['fecha'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
    );
  }

  // Convertir a Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'imageUrl': imageUrl,
      'response': response,
      'fecha': Timestamp.fromDate(fecha),
      'userId': userId,
    };
  }

  // Crear instancia vacía
  factory LecturaModel.empty({
    required String userId,
    required String imageUrl,
  }) {
    return LecturaModel(
      id: '',
      imageUrl: imageUrl,
      response: [],
      fecha: DateTime.now(),
      userId: userId,
    );
  }

  // Copiar con cambios
  LecturaModel copyWith({
    String? id,
    String? imageUrl,
    List<String>? response,
    DateTime? fecha,
    String? userId,
  }) {
    return LecturaModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      response: response ?? this.response,
      fecha: fecha ?? this.fecha,
      userId: userId ?? this.userId,
    );
  }
}
