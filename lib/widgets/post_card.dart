import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {

  final String titulo;
  final String imagen;
  final int likes;

  final VoidCallback onDelete;
  final VoidCallback onLike;

  const PostCard({
    super.key,
    required this.titulo,
    required this.imagen,
    required this.likes,
    required this.onDelete,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 6,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),

            child: imagen.isNotEmpty
                ? Image.network(
                    imagen,
                    height: 240,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )

                : Container(
                    height: 240,
                    width: double.infinity,
                    color: Colors.grey.shade300,

                    child: const Center(
                      child: Icon(
                        Icons.motorcycle,
                        size: 80,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    Row(
                      children: [

                        IconButton(
                          onPressed: onLike,

                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                        ),

                        Text(
                          '$likes likes',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    IconButton(
                      onPressed: onDelete,

                      icon: const Icon(
                        Icons.delete,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}