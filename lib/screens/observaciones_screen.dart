import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ObservacionesScreen extends StatefulWidget {
  final String correo;
  final int registro; // ⭐ Debe existir

  ObservacionesScreen({required this.correo, required this.registro});

  @override
  _ObservacionesScreenState createState() => _ObservacionesScreenState();
}

class _ObservacionesScreenState extends State<ObservacionesScreen> {
  final obsCtrl = TextEditingController();
  bool cargando = false;

  registrar() async {
    if (obsCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Debe escribir una observación")));
      return;
    }

    setState(() => cargando = true);

    final res = await ApiService.registrarObservacion(
      widget.registro, // ⭐ ENVIAMOS EL REGISTRO
      obsCtrl.text.trim(),
    );

    setState(() => cargando = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(res["mensaje"])));

    if (res["status"] == "ok") {
      obsCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text("Registrar Observaciones")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: obsCtrl,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Observación",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            cargando
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: registrar,
                  child: Text("Guardar Observación"),
                ),
          ],
        ),
      ),
    );
  }
}
