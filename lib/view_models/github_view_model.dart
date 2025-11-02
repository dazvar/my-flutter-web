import 'package:flutter/material.dart';
import '../repositories/github_repository.dart';

class GitHubViewModel extends ChangeNotifier {
  final GitHubRepository _repository = GitHubRepository();

  Map<String, dynamic>? _userData;
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUser(String username) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userData = await _repository.getUser(username);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
