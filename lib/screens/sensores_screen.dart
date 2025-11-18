import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SensoresScreen extends StatefulWidget {
  @override
  _SensoresScreenState createState() => _SensoresScreenState();
}

class _SensoresScreenState extends State<SensoresScreen> {
  List<Map<String, dynamic>> sensores = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    try {
      // Llamada a la API que devuelve JSON
      final data = await ApiService.obtenerSensores();
      // Convertir cada elemento a Map<String, dynamic>
      sensores = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print("Error al cargar sensores: $e");
      sensores = [];
    }
    setState(() => cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Datos Sensores")),
      body:
          cargando
              ? Center(child: CircularProgressIndicator())
              : sensores.isEmpty
              ? Center(child: Text("No hay datos disponibles"))
              : ListView.builder(
                itemCount: sensores.length,
                itemBuilder: (context, index) {
                  final sensor = sensores[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      title: Text(
                        "Dispositivo ID: ${sensor['dispositivo_id']}",
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Temperatura: ${sensor['temperatura']} °C"),
                          Text("Humedad Suelo: ${sensor['humedad_suelo']} %"),
                          Text(
                            "Humedad Ambiente: ${sensor['humedad_ambiente']} %",
                          ),
                          Text("Timestamp: ${sensor['ts']}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
