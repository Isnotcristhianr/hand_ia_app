import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String email;
  String photoUrl;
  String language;
  String userType;
  String signo;
  DateTime fechaNacimiento;
  int genero;
  int lecturas;

  UserModel({
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.language,
    required this.userType,
    required this.signo,
    required this.fechaNacimiento,
    required this.genero,
    required this.lecturas,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      language: json['language'] ?? 'es',
      userType: json['userType'] ?? 'free',
      signo: json['signo'] ?? '',
      fechaNacimiento: json['fechaNacimiento'] != null
          ? (json['fechaNacimiento'] as Timestamp).toDate()
          : DateTime.now(),
      genero: json['genero'] ?? 0,
      lecturas: json['lecturas'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'language': language,
      'userType': userType,
      'signo': signo,
      'fechaNacimiento': Timestamp.fromDate(fechaNacimiento),
      'genero': genero,
      'lecturas': lecturas,
    };
  }
}
