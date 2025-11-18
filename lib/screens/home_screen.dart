import 'package:flutter/material.dart';
import 'observaciones_screen.dart';
import 'sensores_screen.dart';
import 'cambiar_password_screen.dart';

class HomeScreen extends StatelessWidget {
  final String correo;
  final int registro;

  HomeScreen({required this.correo, required this.registro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sistema IoT Riego F.C.A"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ---------- LOGO ----------
            SizedBox(height: 250, child: Image.asset('assets/images/logo.png')),
            const SizedBox(height: 30),
            // --- Registrar Observaciones ---
            ElevatedButton.icon(
              icon: Icon(Icons.note_add),
              label: Text("Registrar Observaciones"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, //  Color del botón
                foregroundColor: Colors.white, //  Color del texto
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ObservacionesScreen(
                          correo: correo,
                          registro: registro, //  ahora se envía bien
                        ),
                  ),
                );
              },
            ),

            SizedBox(height: 20),

            // --- Ver Sensores ---
            ElevatedButton.icon(
              icon: Icon(Icons.sensors),
              label: Text("Ver Datos de Sensores"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, //  Color del botón
                foregroundColor: Colors.white, //  Color del texto
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SensoresScreen()),
                );
              },
            ),

            SizedBox(height: 20),

            // --- Cambiar Contraseña ---
            ElevatedButton.icon(
              icon: Icon(Icons.lock),
              label: Text("Cambiar Contraseña"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, //  Color del botón
                foregroundColor: Colors.white, //  Color del texto
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => CambiarPasswordScreen(
                          correo: correo, // ✔️ aquí solo se necesita correo
                        ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
