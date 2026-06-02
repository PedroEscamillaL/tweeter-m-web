import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';

class CommentsScreen extends StatefulWidget {
  final int postId;

  const CommentsScreen({super.key, required this.postId});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  List<dynamic> comments = [];

  bool loading = true;

  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadComments();
  }

  Future<void> loadComments() async {
    final data = await ApiService.getComments(widget.postId);

    setState(() {
      comments = data;
      loading = false;
    });
  }

  Future<void> sendComment() async {
    if (commentController.text.trim().isEmpty) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getInt('userId');

    if (userId == null) {
      return;
    }

    await ApiService.createComment(
      widget.postId,
      userId,
      commentController.text.trim(),
    );

    commentController.clear();

    loadComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comentarios')),

      body: Column(
        children: [
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : comments.isEmpty
                ? const Center(child: Text('No hay comentarios'))
                : ListView.builder(
                    itemCount: comments.length,

                    itemBuilder: (context, index) {
                      final comment = comments[index];

                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://cdn-icons-png.flaticon.com/512/149/149071.png',
                          ),
                        ),

                        title: Text(comment['user']['username'] ?? 'Usuario'),

                        subtitle: Text(comment['text']),
                      );
                    },
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),

            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,

                    decoration: const InputDecoration(
                      hintText: 'Escribe un comentario',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                IconButton(
                  onPressed: sendComment,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
