import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final TextEditingController
      usernameController =
      TextEditingController();

  final TextEditingController
      passwordController =
      TextEditingController();

  bool loading = false;

  Future<void> login() async {

    if (usernameController.text
            .trim()
            .isEmpty ||
        passwordController.text
            .trim()
            .isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Completa todos los campos',
          ),
        ),
      );

      return;
    }

    try {

      setState(() {
        loading = true;
      });

      bool success =
          await AuthService.login(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );

      if (success) {

        setState(() {
          loading = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const HomeScreen(),
          ),
        );

      } else {

        setState(() {
          loading = false;
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Credenciales incorrectas',
            ),
          ),
        );
      }

    } catch (e) {

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Error al iniciar sesión',
          ),
        ),
      );
    }
  }

  Future<void> register() async {

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Registro desactivado temporalmente',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(

        child: Padding(

          padding:
              const EdgeInsets.all(20),

          child: Column(

            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              const Icon(
                Icons.two_wheeler,
                size: 100,
                color: Colors.deepPurple,
              ),

              const SizedBox(height: 20),

              const Text(
                'Tweeter',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              TextField(

                controller:
                    usernameController,

                decoration:
                    const InputDecoration(

                  hintText: 'Usuario',

                  border:
                      OutlineInputBorder(),

                  prefixIcon:
                      Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 20),

              TextField(

                controller:
                    passwordController,

                obscureText: true,

                decoration:
                    const InputDecoration(

                  hintText:
                      'Contraseña',

                  border:
                      OutlineInputBorder(),

                  prefixIcon:
                      Icon(Icons.lock),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  onPressed:
                      loading
                          ? null
                          : login,

                  child: loading

                      ? const CircularProgressIndicator()

                      : const Text(
                          'Iniciar Sesión',
                        ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(

                width: double.infinity,

                child: OutlinedButton(

                  onPressed:
                      loading
                          ? null
                          : register,

                  child: const Text(
                    'Crear Cuenta',
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