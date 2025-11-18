import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_screen.dart';
import 'registrar_screen.dart'; // Nueva pantalla de registro
import 'recuperar_password_screen.dart'; // Nueva pantalla de recuperación

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final correoCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool cargando = false;

  login() async {
    if (correoCtrl.text.isEmpty || passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Debe llenar todos los campos")));
      return;
    }

    setState(() => cargando = true);

    final result = await ApiService.login(
      correoCtrl.text.trim(),
      passCtrl.text.trim(),
    );

    setState(() => cargando = false);

    if (result["status"] == "ok") {
      String correo = result["correo"];
      int registro = result["registro"];

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(correo: correo, registro: registro),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result["mensaje"])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Iniciar Sesión")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---------- LOGO ----------
              SizedBox(
                height: 250,
                child: Image.asset('assets/images/logo.png'),
              ),
              const SizedBox(height: 30),

              TextField(
                controller: correoCtrl,
                decoration: InputDecoration(labelText: "Correo"),
              ),
              SizedBox(height: 10),

              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: InputDecoration(labelText: "Contraseña"),
              ),
              SizedBox(height: 20),

              cargando
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                    onPressed: login,
                    child: Text("Entrar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, //  Color del botón
                      foregroundColor: Colors.white, //  Color del texto
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),

              SizedBox(height: 10),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegistrarScreen()),
                  );
                },
                child: Text(
                  "Registrar nuevo usuario",
                  style: TextStyle(
                    color: Colors.blue, //  COLOR DEL TEXTO
                    fontSize: 16,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecuperarPasswordScreen(),
                    ),
                  );
                },
                child: Text(
                  "Olvidé mi contraseña",
                  style: TextStyle(
                    color: Colors.blue, //  COLOR DEL TEXTO
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
