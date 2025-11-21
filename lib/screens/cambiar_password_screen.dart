import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CambiarPasswordScreen extends StatefulWidget {
  final String correo;
  CambiarPasswordScreen({required this.correo});

  @override
  _CambiarPasswordScreenState createState() => _CambiarPasswordScreenState();
}

class _CambiarPasswordScreenState extends State<CambiarPasswordScreen> {
  final actualCtrl = TextEditingController();
  final nuevoCtrl = TextEditingController();
  final nuevo2Ctrl = TextEditingController();
  bool cargando = false;

  cambiarPassword() async {
    if (nuevoCtrl.text != nuevo2Ctrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Las contraseñas nuevas no coinciden")),
      );
      return;
    }

    setState(() => cargando = true);
    final res = await ApiService.cambiarPassword(
      widget.correo,
      actualCtrl.text,
      nuevoCtrl.text,
    );
    setState(() => cargando = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(res["mensaje"])));

    if (res["status"] == "ok") {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text("Cambiar Contraseña")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: actualCtrl,
              obscureText: true,
              decoration: InputDecoration(labelText: "Contraseña actual"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: nuevoCtrl,
              obscureText: true,
              decoration: InputDecoration(labelText: "Nueva contraseña"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: nuevo2Ctrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Repetir nueva contraseña",
              ),
            ),
            SizedBox(height: 20),
            cargando
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: cambiarPassword,
                  child: Text("Actualizar contraseña"),
                ),
          ],
        ),
      ),
    );
  }
}
