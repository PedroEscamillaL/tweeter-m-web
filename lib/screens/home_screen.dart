import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/post_card.dart';
import '../services/api_service.dart';
import 'create_post_screen.dart';
import 'login_screen.dart';
import 'comments_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> posts = [];

  bool loading = true;

  String username = 'Usuario';

  @override
  void initState() {
    super.initState();
    loadUser();
    loadPosts();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString('username') ?? 'Usuario';
    });
  }

  Future<void> loadPosts() async {
    final data = await ApiService.getPosts();

    setState(() {
      posts = data;
      loading = false;
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '🏍️ MotoSphere',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(
                              'https://cdn-icons-png.flaticon.com/512/149/149071.png',
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              username,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          ElevatedButton.icon(
                            onPressed: logout,
                            icon: const Icon(Icons.logout),
                            label: const Text('Salir'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];

                      return PostCard(
                        titulo: post['text'] ?? 'Sin título',

                        imagen: post['imageUrl'] ?? '',

                        username: post['user']?['username'] ?? 'Usuario',

                        likes: post['likes'] ?? 0,

                        loves: post['loves'] ?? 0,

                        hahas: post['hahas'] ?? 0,

                        wows: post['wows'] ?? 0,

                        sads: post['sads'] ?? 0,

                        angrys: post['angrys'] ?? 0,

                        onReact: (type) async {
                          await ApiService.reactPost(post['id'], type);

                          setState(() {
                            switch (type) {
                              case 'like':
                                post['likes']++;
                                break;

                              case 'love':
                                post['loves']++;
                                break;

                              case 'haha':
                                post['hahas']++;
                                break;

                              case 'wow':
                                post['wows']++;
                                break;

                              case 'sad':
                                post['sads']++;
                                break;

                              case 'angry':
                                post['angrys']++;
                                break;
                            }
                          });
                        },
                        onComments: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CommentsScreen(postId: post['id']),
                            ),
                          );
                        },

                        onDelete: () async {
                          await ApiService.deletePost(post['id']);

                          setState(() {
                            posts.removeWhere((p) => p['id'] == post['id']);
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePostScreen()),
          );

          loadPosts();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
