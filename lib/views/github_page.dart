import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/github_view_model.dart';

class GitHubPage extends StatefulWidget {
  const GitHubPage({super.key});

  @override
  State<GitHubPage> createState() => _GitHubPageState();
}

class _GitHubPageState extends State<GitHubPage> {
  final TextEditingController _controller = TextEditingController(text: 'happymary16');

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GitHubViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub статистика'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Введіть GitHub username',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    viewModel.fetchUser(_controller.text.trim());
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (viewModel.isLoading)
              const CircularProgressIndicator()
            else if (viewModel.errorMessage != null)
              Text(
                viewModel.errorMessage!,
                style: const TextStyle(color: Colors.red),
              )
            else if (viewModel.userData != null)
              _buildUserCard(viewModel.userData!)
            else
              const Text('Введіть ім’я користувача для пошуку'),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> data) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(data['avatar_url']),
            ),
            const SizedBox(height: 16),
            Text(
              data['name'] ?? 'Без імені',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('@${data['login']}'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfo('Репозиторії', data['public_repos'].toString()),
                _buildInfo('Підписники', data['followers'].toString()),
                _buildInfo('Підписки', data['following'].toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label),
      ],
    );
  }
}
