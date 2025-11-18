// Pantalla 1: solicitar código de recuperación
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'verificar_token_screen.dart';

class RecuperarPasswordScreen extends StatefulWidget {
  @override
  _RecuperarPasswordScreenState createState() =>
      _RecuperarPasswordScreenState();
}

class _RecuperarPasswordScreenState extends State<RecuperarPasswordScreen> {
  final correoCtrl = TextEditingController();
  bool cargando = false;

  solicitar() async {
    if (correoCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Ingrese su correo electrónico")));
      return;
    }

    // ➤ 1) Sincronizar hora del servidor antes de continuar
    final horaServidor = await ApiService.obtenerHoraServidor();
    if (horaServidor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No se pudo obtener la hora del servidor")),
      );
      return;
    }

    setState(() => cargando = true);
    final res = await ApiService.solicitarRecuperacion(correoCtrl.text.trim());
    setState(() => cargando = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(res["mensaje"] ?? "")));

    if (res["status"] == "ok") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerificarTokenScreen(correo: correoCtrl.text.trim()),
        ),
      );
      correoCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recuperar Contraseña")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: correoCtrl,
              decoration: InputDecoration(labelText: "Correo registrado"),
            ),
            SizedBox(height: 10),
            cargando
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: solicitar,
                  child: Text("Enviar código de recuperación"),
                ),
          ],
        ),
      ),
    );
  }
}

// ========================================================================
// Pantalla 2: ingresar token y nueva contraseña
// ========================================================================

class VerificarTokenScreen extends StatefulWidget {
  final String correo;
  VerificarTokenScreen({required this.correo});

  @override
  _VerificarTokenScreenState createState() => _VerificarTokenScreenState();
}

class _VerificarTokenScreenState extends State<VerificarTokenScreen> {
  final tokenCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final passConfirmCtrl = TextEditingController();
  bool cargando = false;

  restablecer() async {
    String token = tokenCtrl.text.trim();
    String pass = passCtrl.text.trim();
    String passConfirm = passConfirmCtrl.text.trim();

    if (token.isEmpty || pass.isEmpty || passConfirm.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Debe llenar todos los campos")));
      return;
    }

    if (pass != passConfirm) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Las contraseñas no coinciden")));
      return;
    }

    // ➤ 2) Comprobar hora del servidor ANTES de validar token
    final horaServidor = await ApiService.obtenerHoraServidor();
    if (horaServidor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No se pudo sincronizar con el servidor")),
      );
      return;
    }

    // ➤ 3) Llamada a API: validar token primero
    setState(() => cargando = true);

    final resVerificacion = await ApiService.verificarToken(
      widget.correo,
      token,
    );

    if (resVerificacion["status"] != "ok") {
      setState(() => cargando = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resVerificacion["mensaje"] ?? "Token inválido")),
      );
      return;
    }

    // Si el servidor dice que el token es válido, continuar
    final res = await ApiService.restablecerPassword(token, pass);

    setState(() => cargando = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(res["mensaje"] ?? "")));

    if (res["status"] == "ok") {
      tokenCtrl.clear();
      passCtrl.clear();
      passConfirmCtrl.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verificar Código")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Se envió un código de verificación al correo: ${widget.correo}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextField(
              controller: tokenCtrl,
              decoration: InputDecoration(labelText: "Código de recuperación"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passCtrl,
              decoration: InputDecoration(labelText: "Nueva contraseña"),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextField(
              controller: passConfirmCtrl,
              decoration: InputDecoration(
                labelText: "Confirmar nueva contraseña",
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            cargando
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: restablecer,
                  child: Text("Cambiar contraseña"),
                ),
          ],
        ),
      ),
    );
  }
}
