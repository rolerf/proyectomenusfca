import 'package:flutter/material.dart';
import '../services/api_service.dart';

/// ===============================================
///  PANTALLA 2: Ingresar token + nueva contraseña
/// ===============================================
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

  Future<void> restablecer() async {
    final token = tokenCtrl.text.trim();
    final pass = passCtrl.text.trim();
    final passConfirm = passConfirmCtrl.text.trim();

    if (token.isEmpty || pass.isEmpty || passConfirm.isEmpty) {
      _mensaje("Debe llenar todos los campos");
      return;
    }

    if (pass != passConfirm) {
      _mensaje("Las contraseñas no coinciden");
      return;
    }

    setState(() => cargando = true);

    // 1️⃣ Verificar token primero
    final verif = await ApiService.verificarToken(widget.correo, token);

    if (verif["status"] != "ok") {
      setState(() => cargando = false);
      _mensaje(verif["mensaje"] ?? "Token inválido o expirado");
      return;
    }

    // 2️⃣ Si el token es válido, cambiar contraseña
    final res = await ApiService.restablecerPassword(token, pass);

    setState(() => cargando = false);
    _mensaje(res["mensaje"] ?? "");

    if (res["status"] == "ok") {
      tokenCtrl.clear();
      passCtrl.clear();
      passConfirmCtrl.clear();
      Navigator.pop(context);
    }
  }

  void _mensaje(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verificar Código")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Se envió un código a: ${widget.correo}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            TextField(
              controller: tokenCtrl,
              decoration: InputDecoration(
                labelText: "Código de recuperación",
                prefixIcon: Icon(Icons.vpn_key),
              ),
            ),
            SizedBox(height: 15),

            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Nueva contraseña",
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            SizedBox(height: 15),

            TextField(
              controller: passConfirmCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirmar nueva contraseña",
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 25),

            cargando
                ? CircularProgressIndicator()
                : ElevatedButton.icon(
                  icon: Icon(Icons.check),
                  onPressed: restablecer,
                  label: Text("Cambiar contraseña"),
                ),
          ],
        ),
      ),
    );
  }
}
