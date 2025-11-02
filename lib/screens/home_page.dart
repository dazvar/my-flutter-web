import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';
import '../repository/person_repository.dart';
import '../models/person.dart';
import 'about_page.dart';
import 'add_edit_person_page.dart';
import '../view_models/github_view_model.dart';
import '../view_models/theme_view_model.dart';
import '../widgets/ad_banner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _githubController =
      TextEditingController(text: 'happymary16');
  BannerAd? _bannerAd;
  bool _isBannerReady = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS)) {
      final adUnitId = defaultTargetPlatform == TargetPlatform.android
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
      _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adUnitId,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              _isBannerReady = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        ),
        request: const AdRequest(),
      )..load();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GitHubViewModel>(context);
    final repository = Provider.of<PersonRepository>(context);
    final themeVM = Provider.of<ThemeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Лабораторна 5"),
        actions: [
          IconButton(
            icon: Icon(themeVM.mode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeVM.toggleTheme(),
            tooltip: themeVM.mode == ThemeMode.dark ? 'Світла тема' : 'Темна тема',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAddEditPage(),
            tooltip: 'Додати нове резюме',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Список резюме:",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () => _navigateToAddEditPage(),
                  icon: const Icon(Icons.add),
                  label: const Text('Додати'),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _openLandmark,
                    icon: const Icon(Icons.map),
                    label: const Text('Софійський собор'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _searchUkrainianCafe,
                    icon: const Icon(Icons.restaurant),
                    label: const Text('Українське кафе'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: repository.persons.length,
              itemBuilder: (context, index) {
                final person = repository.persons[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(person.photo),
                      radius: 30,
                    ),
                    title: Text(
                      person.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(person.role),
                        const SizedBox(height: 4),
                        Text(
                          person.hobbies,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) => _handleMenuAction(value, person),
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(Icons.visibility),
                              SizedBox(width: 8),
                              Text('Переглянути'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text('Редагувати'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'duplicate',
                          child: Row(
                            children: [
                              Icon(Icons.copy),
                              SizedBox(width: 8),
                              Text('Дублювати'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Видалити', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AboutPage(person: person),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 25),
            const Divider(thickness: 2),
            const SizedBox(height: 10),

            // GitHub частина
            const Text(
              'GitHub статистика',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _githubController,
              decoration: InputDecoration(
                labelText: 'Введіть GitHub username',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    viewModel.fetchUser(_githubController.text.trim());
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            if (viewModel.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (viewModel.errorMessage != null)
              Center(
                child: Text(
                  viewModel.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (viewModel.userData != null)
              _buildGitHubCard(viewModel.userData!)
            else
              const Center(child: Text('Поки що нічого не знайдено')),
            const SizedBox(height: 20),
            if (kIsWeb)
              const AdBanner()
            else if (_isBannerReady && _bannerAd != null)
              Container(
                alignment: Alignment.center,
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
          ],
        ),
      ),
    );
  }

  // Картка GitHub користувача
  Widget _buildGitHubCard(Map<String, dynamic> data) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
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
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }

  void _navigateToAddEditPage({Person? personToEdit}) {
    final repository = Provider.of<PersonRepository>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditPersonPage(
          repository: repository,
          personToEdit: personToEdit,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  void _handleMenuAction(String action, Person person) {
    switch (action) {
      case 'view':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AboutPage(person: person),
          ),
        );
        return;
      case 'edit':
        _navigateToAddEditPage(personToEdit: person);
        return;
      case 'duplicate':
        _duplicatePerson(person);
        return;
      case 'delete':
        _showDeleteDialog(person);
        return;
    }
  }

  void _duplicatePerson(Person person) {
    final repository = Provider.of<PersonRepository>(context, listen: false);
    final duplicatedPerson = repository.duplicatePerson(person);
    () async {
      await repository.addPerson(duplicatedPerson);
      if (!mounted) return;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Резюме "${person.name}" дубльовано!'),
          action: SnackBarAction(
            label: 'Редагувати',
            onPressed: () => _navigateToAddEditPage(personToEdit: duplicatedPerson),
          ),
        ),
      );
    }();
  }

  void _showDeleteDialog(Person person) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Видалити резюме'),
          content: Text('Ви впевнені, що хочете видалити резюме "${person.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Скасувати'),
            ),
            TextButton(
              onPressed: () async {
                final repository = Provider.of<PersonRepository>(context, listen: false);
                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);
                await repository.deletePerson(person.id);
                if (!mounted) return;
                setState(() {});
                navigator.pop();
                messenger.showSnackBar(
                  SnackBar(content: Text('Резюме "${person.name}" видалено!')),
                );
              },
              child: const Text('Видалити', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openLandmark() async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=50.4520,30.5144');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _searchUkrainianCafe() async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=%D1%83%D0%BA%D1%80%D0%B0%D1%97%D0%BD%D1%81%D1%8C%D0%BA%D0%B5%20%D0%BA%D0%B0%D1%84%D0%B5');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
