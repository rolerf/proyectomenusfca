import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://iot.elbservicios.com.bo/iot/proyecto";

  // LOGIN
  static Future<Map<String, dynamic>> login(
    String correo,
    String password,
  ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/login.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"correo": correo, "password": password}),
    );
    return jsonDecode(res.body);
  }

  // REGISTRO
  static Future<Map<String, dynamic>> registrar(
    String nombre,
    String correo,
    int registro,
    String imei,
  ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/registrar.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nombre": nombre,
        "correo": correo,
        "registro": registro,
        "imei": imei,
      }),
    );
    return jsonDecode(res.body);
  }

  // OBTENER SENSORES
  static Future<List<dynamic>> obtenerSensores() async {
    final res = await http.get(Uri.parse("$baseUrl/api.php"));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Error al obtener datos de sensores");
    }
  }

  // CAMBIAR PASSWORD
  static Future<Map<String, dynamic>> cambiarPassword(
    String correo,
    String passActual,
    String passNuevo,
  ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/cambiar_password.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "correo": correo,
        "pass_actual": passActual,
        "pass_nuevo": passNuevo,
      }),
    );
    return jsonDecode(res.body);
  }

  // REGISTRAR OBSERVACIÓN
  static Future<Map<String, dynamic>> registrarObservacion(
    int registro,
    String mensaje,
  ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/registrar_observacion.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"registro": registro, "mensaje": mensaje}),
    );
    return jsonDecode(res.body);
  }

  // Solicitar recuperación
  static Future<Map<String, dynamic>> solicitarRecuperacion(
    String correo,
  ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/solicitar_recuperacion.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"correo": correo}),
    );
    return jsonDecode(res.body);
  }

  // Restablecer contraseña
  static Future<Map<String, dynamic>> restablecerPassword(
    String token,
    String passNuevo,
  ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/restablecer_password.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"token": token, "pass_nuevo": passNuevo}),
    );
    return jsonDecode(res.body);
  }
}
