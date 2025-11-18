import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class VerificarTokenScreen extends StatefulWidget {
  @override
  _VerificarTokenScreenState createState() => _VerificarTokenScreenState();
}

class _VerificarTokenScreenState extends State<VerificarTokenScreen> {
  final tokenCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final passConfirmCtrl = TextEditingController();

  bool cargando = false;

  restablecer() async {
    if (tokenCtrl.text.isEmpty ||
        passCtrl.text.isEmpty ||
        passConfirmCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Debe llenar todos los campos")));
      return;
    }

    if (passCtrl.text.trim() != passConfirmCtrl.text.trim()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Las contraseñas no coinciden")));
      return;
    }

    setState(() => cargando = true);

    final res = await ApiService.restablecerPassword(
      tokenCtrl.text.trim(),
      passCtrl.text.trim(),
    );

    setState(() => cargando = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(res["mensaje"])));

    if (res["status"] == "ok") {
      // limpiar campos
      tokenCtrl.clear();
      passCtrl.clear();
      passConfirmCtrl.clear();

      // regresar al login
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      });
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
              "Introduce el código que recibiste en tu correo",
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
              obscureText: true,
              decoration: InputDecoration(labelText: "Nueva contraseña"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passConfirmCtrl,
              obscureText: true,
              decoration: InputDecoration(labelText: "Confirmar contraseña"),
            ),
            SizedBox(height: 20),
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
