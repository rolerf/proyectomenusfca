import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nombreCtrl = TextEditingController();
  final correoCtrl = TextEditingController();
  final registroCtrl = TextEditingController();
  final imeiCtrl = TextEditingController();
  bool cargando = false;

  registrar() async {
    setState(() => cargando = true);
    final res = await ApiService.registrar(
      nombreCtrl.text,
      correoCtrl.text,
      int.tryParse(registroCtrl.text) ?? 0,
      imeiCtrl.text,
    );
    setState(() => cargando = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(res["mensaje"])));
    if (res["status"] == "ok") Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text("Registro")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: InputDecoration(labelText: "Nombre"),
            ),
            TextField(
              controller: correoCtrl,
              decoration: InputDecoration(labelText: "Correo"),
            ),
            TextField(
              controller: registroCtrl,
              decoration: InputDecoration(labelText: "Registro"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: imeiCtrl,
              decoration: InputDecoration(labelText: "IMEI"),
            ),
            SizedBox(height: 20),
            cargando
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: registrar,
                  child: Text("Registrar"),
                ),
          ],
        ),
      ),
    );
  }
}
