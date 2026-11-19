# Ronda 1. Preparar Firebase, Android e iOS

## Crear el proyecto y conectar Flutter
- Entra a la consola de Firebase y crea un proyecto (puedes desactivar Google Analytics para esta práctica).
- Instala las herramientas: Firebase CLI (npm install -g firebase-tools, luego firebase login) y la CLI de FlutterFire (dart pub global activate flutterfire_cli).
- Crea el proyecto Flutter y copia el código de este manual.
Terminal

```
flutter create loteria_push
cd loteria_push
flutter pub add firebase_core firebase_messaging flutter_local_notifications http shared_preferences
flutterfire configure
```
flutterfire configure registra tus apps Android e iOS en Firebase y genera lib/firebase_options.dart (el archivo que main.dart y fondo.dart importan). Sin ese archivo la app no compila, pero flutter test sí corre, porque las pruebas no lo importan.

Después de copiar el código, revisa el pubspec: las restricciones de versión de nuestro pubspec son amplias a propósito, y flutter pub add elige versiones compatibles entre sí con TU versión de Flutter.

```
Archivo: app/pubspec.yaml
name: loteria_push
description: Lotería Push - notificaciones push (FCM) bien hechas, jugando a la Lotería.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.8.0

dependencies:
  flutter:
    sdk: flutter
  # Consejo: instala con `flutter pub add firebase_core firebase_messaging` para que
  # pub elija versiones compatibles entre sí con TU versión de Flutter.
  firebase_core: ">=3.0.0 <6.0.0"
  firebase_messaging: ">=15.0.0 <19.0.0"
  # Solo para CREAR los canales de Android (importancia por tipo de aviso).
  flutter_local_notifications: ">=20.1.0 <24.0.0"
  http: ^1.2.0
  shared_preferences: ^2.3.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
```

## Android
android/app/src/main/AndroidManifest.xml. Fuera de <application>:

```
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```
OJO: INTERNET: los proyectos de Flutter lo traen solo en el modo debug. Si lo olvidas, todo funciona en desarrollo y la versión de producción no puede hablar con tu servidor. Es uno de los errores más clásicos.

Dentro de <application>, para desarrollo contra un servidor local por http (el "localhost" del emulador es 10.0.2.2), y los metadatos del canal predeterminado:

```
<application
    android:usesCleartextTraffic="true"   <!-- SOLO para desarrollo; en producción usa https -->
    ...>
  <meta-data
      android:name="com.google.firebase.messaging.default_notification_channel_id"
      android:value="cartas" />
</application>
```
El permiso POST_NOTIFICATIONS es obligatorio en Android 13 o superior; firebase_messaging lo solicita cuando llamas requestPermission. Para el icono y color de la notificación hay metadatos equivalentes (default_notification_icon y default_notification_color).


## iOS
- Necesitas una cuenta de desarrollador de Apple y un iPhone real: las notificaciones push dependen de APNs y los simuladores tienen limitaciones.
- En Xcode, abre ios/Runner.xcworkspace, pestaña Signing & Capabilities, y agrega las capacidades Push Notifications y Background Modes (marca Remote notifications).
- En el portal de Apple crea una llave de autenticación de APNs (archivo .p8) y súbela en la consola de Firebase: Configuración del proyecto, Cloud Messaging, configuración de la app de Apple (necesita el Key ID y el Team ID).

## La cuenta de servicio (solo para el servidor)
Para que TU servidor pueda enviar mensajes, genera una cuenta de servicio: consola de Firebase, Configuración del proyecto, Cuentas de servicio, "Generar nueva clave privada". Se descarga un archivo JSON. Ese archivo es una llave maestra: quien lo tenga puede enviar mensajes a todos tus usuarios haciéndose pasar por ti.

OJO: Reglas del JSON de la cuenta de servicio: jamás dentro de la app móvil (cualquiera puede descomprimir una app), jamás en un repositorio de GitHub, jamás en un mensaje de chat. Se entrega al servidor por una variable de entorno (GOOGLE_APPLICATION_CREDENTIALS) o por el sistema de secretos de tu proveedor. Si se filtra, se revoca y se genera otro.

DATO CURIOSO: La API antigua de FCM que usaba una "clave de servidor" fue dada de baja; hoy se usa la API HTTP v1 o el SDK de administrador (Admin SDK), que es lo que usa nuestro servidor. Si encuentras tutoriales con "Authorization: key=...", están obsoletos.

