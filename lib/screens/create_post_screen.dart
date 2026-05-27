import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';

class CreatePostScreen extends StatefulWidget {

  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() =>
      _CreatePostScreenState();
}

class _CreatePostScreenState
    extends State<CreatePostScreen> {

  final TextEditingController textController =
      TextEditingController();

  bool loading = false;

  File? imagenSeleccionada;

  final picker = ImagePicker();

  Future<void> seleccionarImagen() async {

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {

      setState(() {

        imagenSeleccionada = File(
          pickedFile.path,
        );
      });
    }
  }

  Future<void> createPost() async {

    if (imagenSeleccionada == null) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Selecciona una imagen',
          ),
        ),
      );

      return;
    }

    final prefs =
        await SharedPreferences.getInstance();

    final username =
        prefs.getString('username');

    if (username == null) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Usuario no encontrado',
          ),
        ),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    try {

      await ApiService.createPost(
        textController.text,
        imagenSeleccionada!,
        username,
      );

      if (mounted) {

        Navigator.pop(
          context,
          true,
        );
      }

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Error al crear post',
          ),
        ),
      );

    } finally {

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFFF5F7FA),

      appBar: AppBar(

        title: const Text(
          'Crear Post',
        ),

        backgroundColor:
            Colors.white,

        foregroundColor:
            Colors.black,

        elevation: 0,
      ),

      body: Padding(

        padding: const EdgeInsets.all(16),

        child: SingleChildScrollView(

          child: Column(

            children: [

              TextField(

                controller: textController,

                decoration: InputDecoration(

                  labelText:
                      '¿Qué moto quieres mostrar?',

                  filled: true,

                  fillColor: Colors.white,

                  border: OutlineInputBorder(

                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(

                onTap: seleccionarImagen,

                child: Container(

                  height: 220,
                  width: double.infinity,

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),

                    border: Border.all(
                      color:
                          Colors.grey.shade300,
                    ),
                  ),

                  child: imagenSeleccionada == null

                      ? const Column(

                          mainAxisAlignment:
                              MainAxisAlignment.center,

                          children: [

                            Icon(
                              Icons.add_a_photo,
                              size: 60,
                              color:
                                  Colors.blueGrey,
                            ),

                            SizedBox(height: 10),

                            Text(
                              'Seleccionar imagen',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        )

                      : ClipRRect(

                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),

                          child: Image.file(
                            imagenSeleccionada!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(

                width: double.infinity,
                height: 55,

                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(

                    backgroundColor:
                        Colors.indigo,

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),
                  ),

                  onPressed:
                      loading
                          ? null
                          : createPost,

                  child: loading

                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )

                      : const Text(

                          'Publicar',

                          style: TextStyle(

                            color: Colors.white,

                            fontSize: 18,

                            fontWeight:
                                FontWeight.bold,
                          ),
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