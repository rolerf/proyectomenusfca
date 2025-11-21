import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegistrarScreen extends StatefulWidget {
  @override
  _RegistrarScreenState createState() => _RegistrarScreenState();
}

class _RegistrarScreenState extends State<RegistrarScreen> {
  final nombreCtrl = TextEditingController();
  final correoCtrl = TextEditingController();
  final registroCtrl = TextEditingController();
  final imeiCtrl = TextEditingController();
  bool cargando = false;

  registrar() async {
    String nombre = nombreCtrl.text.trim();
    String correo = correoCtrl.text.trim();
    String registroStr = registroCtrl.text.trim();
    String imei = imeiCtrl.text.trim();

    if (nombre.isEmpty ||
        correo.isEmpty ||
        registroStr.isEmpty ||
        imei.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Debe llenar todos los campos")));
      return;
    }

    int? registro = int.tryParse(registroStr);
    if (registro == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registro debe ser un número válido")),
      );
      return;
    }

    setState(() => cargando = true);

    final res = await ApiService.registrar(nombre, correo, registro, imei);

    setState(() => cargando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res["mensaje"] ?? "Error desconocido")),
    );

    if (res["status"] == "ok") {
      // Limpiar campos y regresar al login
      nombreCtrl.clear();
      correoCtrl.clear();
      registroCtrl.clear();
      imeiCtrl.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text("Registrar Nuevo Usuario")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: InputDecoration(
                labelText: "Nombre",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: correoCtrl,
              decoration: InputDecoration(
                labelText: "Correo",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: registroCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Número de registro",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: imeiCtrl,
              decoration: InputDecoration(
                labelText: "IMEI",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            cargando
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: registrar,
                  child: Text("Registrar"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
