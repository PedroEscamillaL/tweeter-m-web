import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/api_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool loading = false;

  Future<void> login() async {
    if (usernameController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );

      return;
    }

    try {
      setState(() {
        loading = true;
      });

      bool success = await AuthService.login(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );

      if (success) {
        setState(() {
          loading = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        setState(() {
          loading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciales incorrectas')),
        );
      }
    } catch (e) {
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error al iniciar sesión')));
    }
  }

  Future<void> register() async {
    if (usernameController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );

      return;
    }

    try {
      setState(() {
        loading = true;
      });

      await ApiService.register(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario creado correctamente')),
      );
    } catch (e) {
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al registrar usuario')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            colors: [Colors.deepPurple, Color(0xFFF5F1F8)],
          ),
        ),

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),

              child: Card(
                elevation: 8,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(24),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      const Icon(
                        Icons.two_wheeler,
                        size: 90,
                        color: Colors.deepPurple,
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        'MotoSphere',

                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Conecta con la comunidad motociclista',

                        textAlign: TextAlign.center,

                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),

                      const SizedBox(height: 35),

                      TextField(
                        controller: usernameController,

                        decoration: InputDecoration(
                          hintText: 'Usuario',

                          prefixIcon: const Icon(Icons.person),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: passwordController,

                        obscureText: true,

                        decoration: InputDecoration(
                          hintText: 'Contraseña',

                          prefixIcon: const Icon(Icons.lock),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,

                        height: 50,

                        child: ElevatedButton(
                          onPressed: loading ? null : login,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,

                            foregroundColor: Colors.white,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),

                          child: loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text('Iniciar Sesión'),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        '¿No tienes cuenta?',

                        style: TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,

                        height: 50,

                        child: OutlinedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },

                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.deepPurple),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),

                          child: const Text('Crear Cuenta'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
