import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RecuperarPasswordScreen extends StatefulWidget {
  @override
  _RecuperarPasswordScreenState createState() =>
      _RecuperarPasswordScreenState();
}

class _RecuperarPasswordScreenState extends State<RecuperarPasswordScreen> {
  final correoCtrl = TextEditingController();
  final tokenCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final passConfirmCtrl = TextEditingController();
  bool cargando = false;

  // Solicitar código de recuperación
  solicitar() async {
    if (correoCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Ingrese su correo")));
      return;
    }

    setState(() => cargando = true);
    final res = await ApiService.solicitarRecuperacion(correoCtrl.text.trim());
    setState(() => cargando = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(res["mensaje"])));

    // Limpiar todos los campos si fue enviado correctamente
    if (res["status"] == "ok") {
      correoCtrl.clear();
      tokenCtrl.clear();
      passCtrl.clear();
      passConfirmCtrl.clear();
    }
  }

  // Restablecer contraseña
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

    setState(() => cargando = true);
    final res = await ApiService.restablecerPassword(token, pass);
    setState(() => cargando = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(res["mensaje"])));

    // Limpiar todos los campos después de cambiar la contraseña exitosamente
    if (res["status"] == "ok") {
      correoCtrl.clear();
      tokenCtrl.clear();
      passCtrl.clear();
      passConfirmCtrl.clear();
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
              decoration: InputDecoration(labelText: "Correo"),
            ),
            SizedBox(height: 10),
            cargando
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: solicitar,
                  child: Text("Enviar código de recuperación"),
                ),
            Divider(),
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
            SizedBox(height: 10),
            cargando
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: restablecer,
                  child: Text("Restablecer contraseña"),
                ),
          ],
        ),
      ),
    );
  }
}
