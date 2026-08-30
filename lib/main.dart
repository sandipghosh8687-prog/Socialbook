import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const SocialbookApp());
}

class SocialbookApp extends StatelessWidget {
  const SocialbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Socialbook',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 40),

                const Text(
                  'Socialbook',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Connect with friends and family',
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 40),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email or phone',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HomePage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Log In',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateAccountPage(),
                  ),
                );
              },
                  child: const Text('Forgot password?'),
                ),

                const Divider(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateAccountPage(),
                ),
              );
            },
                    child: const Text(
                      'Create New Account',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Socialbook',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chat),
          ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),

          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: const Text(
              'What’s on your mind?',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          onTap: () { showDialog(context: context, builder: (dialogContext) { final controller = TextEditingController(); return AlertDialog(title: const Text("Create Post"), content: TextField(controller: controller, maxLines: 5, decoration: const InputDecoration(hintText: "What's on your mind?")), actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text("Cancel")), ElevatedButton(onPressed: () { if (controller.text.trim().isNotEmpty) { Navigator.pop(dialogContext); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Post created successfully!"))); } }, child: const Text("Post"))]); }); },
          ),

          const Divider(),

          Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    TextButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.thumb_up_outlined),
      label: const Text('Like'),
    ),
    TextButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.thumb_down_outlined),
      label: const Text('Dislike'),
    ),
    TextButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.comment_outlined),
      label: const Text('Comment'),
    ),
    TextButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.share_outlined),
      label: const Text('Share'),
    ),
  ],
),

          const Divider(),

          const PostCard(
            name: 'Socialbook User',
            text: 'Welcome to Socialbook! 👋',
            likes: 12,
            comments: 4,
          ),

          const PostCard(
            name: 'Socialbook Team',
            text: 'This is your new social media app.',
            likes: 25,
            comments: 8,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class PostCard extends StatefulWidget {
  final String name;
  final String text;
  final int likes;
  final int comments;

  const PostCard({
    super.key,
    required this.name,
    required this.text,
    required this.likes,
    required this.comments,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int _likes;
  late int _dislikes;
  late int _comments;
  bool _liked = false;
  bool _disliked = false;

  @override
  void initState() {
    super.initState();
    _likes = widget.likes;
    _dislikes = 0;
    _comments = widget.comments;
  }

  void _like() {
    setState(() {
      if (_liked) {
        _liked = false;
        _likes--;
      } else {
        _liked = true;
        _likes++;
        if (_disliked) {
          _disliked = false;
          _dislikes--;
        }
      }
    });
  }

  void _dislike() {
    setState(() {
      if (_disliked) {
        _disliked = false;
        _dislikes--;
      } else {
        _disliked = true;
        _dislikes++;
        if (_liked) {
          _liked = false;
          _likes--;
        }
      }
    });
  }

  void _comment() {
    setState(() {
      _comments++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comment added!')),
    );
  }

  void _share() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post shared!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 16),
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              widget.text,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 12),

            Text(
              '$_likes likes • $_dislikes dislikes • $_comments comments',
            ),

            const Divider(),

            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: _like,
                  icon: Icon(
                    _liked
                        ? Icons.thumb_up
                        : Icons.thumb_up_outlined,
                  ),
                  label: const Text('Like'),
                  ),
                ),

                Expanded(
                  child: TextButton.icon(
                    onPressed: _dislike,
                  icon: Icon(
                    _disliked
                        ? Icons.thumb_down
                        : Icons.thumb_down_outlined,
                  ),
                  label: const Text('Dislike'),
                  ),
                ),

                Expanded(
                  child: TextButton.icon(
                    onPressed: _comment,
                  icon: const Icon(Icons.comment_outlined),
                  label: const Text('Comment'),
                  ),
                ),

                Expanded(
                  child: TextButton.icon(
                    onPressed: _share,
                  icon: const Icon(Icons.share_outlined),
                  label: const Text('Share'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> createAccount() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters'),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('account_name', name);
    await prefs.setString('account_email', email);
    await prefs.setString('account_password', password);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account created successfully!')),
    );

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60),

            const Text(
              'Create your Socialbook account',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 50),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email or phone',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: createAccount,
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

