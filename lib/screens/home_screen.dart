import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/post_card.dart';
import '../services/api_service.dart';
import 'create_post_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<dynamic> posts = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<void> loadPosts() async {

    final data = await ApiService.getPosts();

    setState(() {

      posts = data;
      loading = false;
    });
  }

  Future<void> logout() async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.clear();

    if (mounted) {

      Navigator.pushReplacement(
        context,

        MaterialPageRoute(
          builder: (_) =>
              const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          'Moto Social',
        ),

        actions: [

          IconButton(

            onPressed: logout,

            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),

      body: loading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : ListView.builder(

              itemCount: posts.length,

              itemBuilder: (
                context,
                index,
              ) {

                final post = posts[index];

                return PostCard(

                  titulo:
                      post['text'] ??
                          'Sin título',

                  imagen:
                      post['imageUrl'] ?? '',

                  likes:
                      post['likes'] ?? 0,

                  username:
                      post['user']?['username'] ??
                      'Usuario',

                  onLike: () async {

                    await ApiService.likePost(
                      post['id'],
                    );

                    loadPosts();
                  },

                  onDelete: () async {

                    await ApiService.deletePost(
                      post['id'],
                    );

                    setState(() {

                      posts.removeWhere(
                        (p) =>
                            p['id'] ==
                            post['id'],
                      );
                    });
                  },
                );
              },
            ),

      floatingActionButton:
          FloatingActionButton(

        onPressed: () async {

          await Navigator.push(
            context,

            MaterialPageRoute(
              builder: (_) =>
                  const CreatePostScreen(),
            ),
          );

          loadPosts();
        },

        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}