import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
      return;
    }

    setState(() {
      loading = true;
    });

    try {

      await ApiService.createPost(
        textController.text,
        imagenSeleccionada!,
      );

      if (mounted) {
        Navigator.pop(context);
      }

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
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

      appBar: AppBar(
        title: const Text('Crear Post'),
      ),

      body: Padding(

        padding: const EdgeInsets.all(16),

        child: SingleChildScrollView(

          child: Column(

            children: [

              TextField(
                controller: textController,

                decoration: const InputDecoration(
                  labelText: 'Título',
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(

                onPressed: seleccionarImagen,

                icon: const Icon(Icons.image),

                label: const Text(
                  'Seleccionar Imagen',
                ),
              ),

              const SizedBox(height: 20),

              if (imagenSeleccionada != null)

                ClipRRect(

                  borderRadius:
                      BorderRadius.circular(16),

                  child: Image.file(
                    imagenSeleccionada!,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

              const SizedBox(height: 20),

              SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  onPressed:
                      loading ? null : createPost,

                  child: loading

                      ? const CircularProgressIndicator()

                      : const Text(
                          'Publicar',
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