import 'package:flutter/material.dart';

import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final TextEditingController
      usernameController =
          TextEditingController();

  final TextEditingController
      passwordController =
          TextEditingController();

  bool loading = false;

  Future<void> register() async {

    if (
        usernameController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty
    ) {

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

      await ApiService.register(

        usernameController.text.trim(),

        passwordController.text.trim(),
      );

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content: Text(
              'Usuario creado correctamente',
            ),
          ),
        );

        Navigator.pop(context);
      }

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            'Error al registrar usuario',
          ),
        ),
      );
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Crear Cuenta',
        ),
      ),

      body: Center(

        child: SingleChildScrollView(

          padding:
              const EdgeInsets.all(24),

          child: Card(

            elevation: 8,

            shape:
                RoundedRectangleBorder(

              borderRadius:
                  BorderRadius.circular(25),
            ),

            child: Padding(

              padding:
                  const EdgeInsets.all(24),

              child: Column(

                mainAxisSize:
                    MainAxisSize.min,

                children: [

                  const Icon(

                    Icons.person_add,

                    size: 80,

                    color:
                        Colors.deepPurple,
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  const Text(

                    'Crear Cuenta',

                    style: TextStyle(

                      fontSize: 28,

                      fontWeight:
                          FontWeight.bold,

                      color:
                          Colors.deepPurple,
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  TextField(

                    controller:
                        usernameController,

                    decoration:
                        InputDecoration(

                      hintText:
                          'Usuario',

                      prefixIcon:
                          const Icon(
                        Icons.person,
                      ),

                      border:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  TextField(

                    controller:
                        passwordController,

                    obscureText:
                        true,

                    decoration:
                        InputDecoration(

                      hintText:
                          'Contraseña',

                      prefixIcon:
                          const Icon(
                        Icons.lock,
                      ),

                      border:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  SizedBox(

                    width:
                        double.infinity,

                    height: 50,

                    child:
                        ElevatedButton(

                      onPressed:
                          loading
                              ? null
                              : register,

                      style:
                          ElevatedButton.styleFrom(

                        backgroundColor:
                            Colors.deepPurple,

                        foregroundColor:
                            Colors.white,
                      ),

                      child:
                          loading

                              ? const CircularProgressIndicator(
                                  color:
                                      Colors.white,
                                )

                              : const Text(
                                  'Crear Cuenta',
                                ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}