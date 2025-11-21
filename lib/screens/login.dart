import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController correoController = TextEditingController();
  final TextEditingController registroController = TextEditingController();

  void login() {
    String correo = correoController.text.trim();
    int registro = int.parse(registroController.text.trim());

    if (correo.isEmpty || registro > 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Complete todos los campos")));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(correo: correo, registro: registro),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: correoController,
              decoration: InputDecoration(labelText: "Correo"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: registroController,
              decoration: InputDecoration(labelText: "Registro"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 30),
            ElevatedButton(onPressed: login, child: Text("Ingresar")),
          ],
        ),
      ),
    );
  }
}
