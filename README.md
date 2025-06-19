# 🖐️ Hand IA - Quiromancia con Inteligencia Artificial

[![Flutter](https://img.shields.io/badge/Flutter-3.8.1-blue.svg)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange.svg)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/License-Private-red.svg)]()

**Hand IA** es una aplicación móvil revolucionaria que utiliza inteligencia artificial avanzada para analizar las líneas de tu mano y obtener insights únicos sobre tu personalidad y futuro. Combina la sabiduría ancestral de la quiromancia con la precisión de la IA moderna.

## ✨ Características Principales

### 🤖 **Análisis con IA Avanzada**
- **Gemini AI Integration**: Utiliza el modelo Gemini 2.0 Flash de Google AI
- **Análisis Detallado**: Interpretación profunda de líneas, forma de mano y características
- **Resultados Personalizados**: Cada lectura es única y adaptada a tu mano

### 📱 **Interfaz Moderna**
- **Glassmorphism UI**: Efectos cristal elegantes y modernos
- **Tema Oscuro**: Diseño optimizado para una experiencia visual superior
- **Navegación Intuitiva**: UX diseñada para máxima facilidad de uso

### 🔐 **Autenticación Segura**
- **Firebase Authentication**: Sistema robusto de autenticación
- **Google Sign-In**: Inicia sesión con tu cuenta de Google
- **Apple Sign-In**: Compatible con Sign in with Apple (iOS)
- **Firebase App Check**: Protección avanzada contra abuso de APIs

### 📊 **Gestión de Lecturas**
- **Historial Completo**: Todas tus lecturas guardadas y organizadas
- **Vista Detallada**: Análisis estructurado en secciones fáciles de leer
- **Navegación por Páginas**: Desliza entre diferentes lecturas
- **Almacenamiento Seguro**: Fotos y análisis guardados en Firebase Storage

## 🏗️ Arquitectura Técnica

### **Frontend (Flutter)**
```
lib/
├── bloc/               # Controladores de estado (GetX)
│   ├── controllers/    # AuthController, OcrController, ProfileController
│   └── services/       # Servicios de negocio
├── config/             # Configuración de tema
├── data/              # Modelos de datos
│   └── models/        # LecturaModel, UserModel
├── presentation/      # UI y vistas
│   ├── home/          # Pantalla principal
│   ├── lecturas/      # Vista de lecturas detalladas
│   ├── profile/       # Perfil de usuario
│   └── views/         # Login, Welcome
├── routes/            # Navegación y middleware
├── services/          # Servicios Firebase
└── widgets/           # Componentes reutilizables
```

### **Backend (Firebase)**
- **Firestore**: Base de datos NoSQL para lecturas y usuarios
- **Storage**: Almacenamiento de imágenes de manos
- **Authentication**: Gestión de usuarios
- **App Check**: Seguridad de APIs
- **AI Integration**: Conexión con Gemini AI

### **Seguridad**
- **Firebase App Check** con Play Integrity (Android) y App Attest (iOS)
- **Security Rules** para Firestore y Storage
- **Token-based Authentication**
- **Validación de certificados SHA-256**

## 🚀 Instalación y Configuración

### **Prerrequisitos**
- Flutter SDK 3.8.1+
- Dart 3.0+
- Android Studio / VS Code
- Cuenta de Firebase
- Cuenta de Google Cloud (para Gemini AI)

### **1. Clonar el Repositorio**
```bash
git clone https://github.com/tu-usuario/hand_ia.git
cd hand_ia
```

### **2. Instalar Dependencias**
```bash
flutter pub get
```

### **3. Configuración de Firebase**

#### **Android**
1. Crear proyecto en [Firebase Console](https://console.firebase.google.com)
2. Agregar app Android con package `com.example.hand_ia`
3. Descargar `google-services.json` y colocar en `android/app/`
4. Configurar Firebase App Check con Play Integrity:
   ```bash
   cd android && ./gradlew signingReport
   ```
   Usar el SHA-256 generado en Firebase Console

#### **iOS**
1. Agregar app iOS en Firebase Console
2. Descargar `GoogleService-Info.plist` y agregar a `ios/Runner/`
3. Configurar App Check con Device Check/App Attest

### **4. Configuración de Gemini AI**
1. Crear proyecto en Google Cloud Console
2. Habilitar Firebase AI Logic API
3. Configurar las credenciales en Firebase

### **5. Ejecutar la Aplicación**
```bash
# Desarrollo
flutter run --debug

# Producción
flutter build apk --release
flutter build ios --release
```

## 📦 Dependencias Principales

```yaml
dependencies:
  flutter: sdk: flutter
  
  # Estado y Navegación
  get: ^4.7.2
  
  # UI y Efectos
  glassmorphism: ^3.0.0
  google_fonts: ^6.1.0
  flutter_launcher_icons: ^0.14.4
  flutter_native_splash: ^2.4.6
  
  # Firebase
  firebase_core: ^3.14.0
  firebase_auth: ^5.6.0
  firebase_storage: ^12.4.7
  cloud_firestore: ^5.6.9
  firebase_app_check: ^0.3.2+7
  firebase_ai: ^2.1.0
  
  # Autenticación Social
  google_sign_in: ^6.3.0
  sign_in_with_apple: ^7.0.1
  
  # Utilidades
  image_picker: ^1.1.2
  intl: ^0.20.2
  flutter_localizations: sdk: flutter
```

## 🎯 Características del Análisis

### **Detección Automática**
- **Tipo de Mano**: Tierra, Aire, Fuego, Agua
- **Líneas Principales**: Corazón, Cabeza, Vida
- **Características Físicas**: Textura, callosidades, forma del pulgar
- **Montes Palmares**: Venus, Luna, Marte

### **Análisis Estructurado**
1. **🖐️ Forma General**: Tipo de mano y características básicas
2. **📏 Líneas Principales**: Interpretación detallada de líneas
3. **🔍 Detalles Adicionales**: Elementos específicos y únicos
4. **🧩 Conclusión**: Resumen de personalidad y características

## 🔧 Configuración Avanzada

### **Firebase App Check TTL**
- **Desarrollo**: 1-2 horas
- **Producción**: 2-4 horas (balance seguridad/rendimiento)

### **Certificados Requeridos**
- **Android**: SHA-256 del keystore de debug/release
- **iOS**: Bundle ID y Team ID registrados

### **Variables de Entorno**
Crear archivo `.env` (no incluido en Git):
```env
FIREBASE_PROJECT_ID=your-project-id
GEMINI_API_KEY=your-gemini-key
```

## 🚀 Despliegue

### **Android (Google Play)**
```bash
# Generar keystore de release
keytool -genkey -v -keystore android/app/hand_ia_release.keystore

# Build de release
flutter build appbundle --release
```

### **iOS (App Store)**
```bash
# Build para App Store
flutter build ios --release

# Abrir en Xcode para upload
open ios/Runner.xcworkspace
```

## 🤝 Contribución

1. Fork del repositorio
2. Crear rama feature (`git checkout -b feature/AmazingFeature`)
3. Commit cambios (`git commit -m 'Add AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir Pull Request

## 📄 Licencia

Este proyecto es privado y propietario. Todos los derechos reservados.

## 📞 Soporte

Para soporte técnico o consultas:
- **Email**: soporte@handia.app
- **Issues**: [GitHub Issues](https://github.com/tu-usuario/hand_ia/issues)

## 🙏 Agradecimientos

- **Google Gemini AI** por la tecnología de análisis
- **Firebase** por la infraestructura backend
- **Flutter** por el framework de desarrollo
- **Comunidad Flutter** por los recursos y librerías

---

**Desarrollado con ❤️ usando Flutter y Firebase**

*"El futuro está en la palma de tu mano"* ✨
