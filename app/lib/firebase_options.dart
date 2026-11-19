// ⚠️ ARCHIVO PROVISIONAL.
// `flutterfire configure` (Ronda 1 del manual) genera el archivo REAL y reemplaza este.
// Mientras tanto, las PRUEBAS funcionan (no usan Firebase); la app, no.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => throw UnsupportedError(
      'Falta configurar Firebase: ejecuta "flutterfire configure" (Ronda 1 del manual).');
}
