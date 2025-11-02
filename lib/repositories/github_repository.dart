import '../services/github_service.dart';

class GitHubRepository {
  final GitHubService _service = GitHubService();

  Future<Map<String, dynamic>> getUser(String username) async {
    return await _service.fetchUserData(username);
  }
}
