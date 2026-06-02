import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String titulo;
  final String imagen;
  final String username;

  final int likes;
  final int loves;
  final int hahas;
  final int wows;
  final int sads;
  final int angrys;

  final Function(String) onReact;

  final VoidCallback onDelete;
  final VoidCallback onComments;

  const PostCard({
    super.key,
    required this.titulo,
    required this.imagen,
    required this.username,
    required this.likes,
    required this.loves,
    required this.hahas,
    required this.wows,
    required this.sads,
    required this.angrys,
    required this.onReact,
    required this.onDelete,
    required this.onComments,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                        'https://cdn-icons-png.flaticon.com/512/149/149071.png',
                      ),
                    ),

                    const SizedBox(width: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Text('Publicó una moto'),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (likes > 0)
                      _reactionBadge('👍', likes, Colors.blue.shade50),

                    if (loves > 0)
                      _reactionBadge('❤️', loves, Colors.red.shade50),

                    if (hahas > 0)
                      _reactionBadge('😂', hahas, Colors.orange.shade50),

                    if (wows > 0)
                      _reactionBadge('😮', wows, Colors.amber.shade50),

                    if (sads > 0)
                      _reactionBadge('😢', sads, Colors.indigo.shade50),

                    if (angrys > 0)
                      _reactionBadge('😡', angrys, Colors.deepOrange.shade50),
                  ],
                ),

                const SizedBox(height: 10),

                const Divider(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    PopupMenuButton<String>(
                      onSelected: onReact,

                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'like', child: Text('👍 Like')),
                        PopupMenuItem(value: 'love', child: Text('❤️ Love')),
                        PopupMenuItem(value: 'haha', child: Text('😂 Haha')),
                        PopupMenuItem(value: 'wow', child: Text('😮 Wow')),
                        PopupMenuItem(value: 'sad', child: Text('😢 Sad')),
                        PopupMenuItem(value: 'angry', child: Text('😡 Angry')),
                      ],

                      child: const Row(
                        children: [
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 6),
                          Text('Reaccionar'),
                        ],
                      ),
                    ),

                    InkWell(
                      onTap: onComments,
                      child: const Row(
                        children: [
                          Icon(Icons.comment_outlined, color: Colors.blue),
                          SizedBox(width: 6),
                          Text('Comentar'),
                        ],
                      ),
                    ),

                    InkWell(
                      onTap: onDelete,
                      child: const Row(
                        children: [
                          Icon(Icons.delete_outline, color: Colors.deepPurple),
                          SizedBox(width: 6),
                          Text('Eliminar'),
                        ],
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

  Widget _reactionBadge(String emoji, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$emoji $count',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
