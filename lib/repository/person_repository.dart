import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/person.dart';

class PersonRepository {
  static const String _storageKey = 'persons_data_v1';
  final List<Person> _persons = [
    Person(
      id: "1",
      name: "Ярмак Ярослав Ігорович",
      role: "Flutter розробник",
      hobbies: "🎸 Музика, 🎮 Ігри, 📚 Книги",
      education: "🔹 Наразі навчаюсь у ХПІ\n🔹 IT",
      contacts: "📧 email@gmail.com\n📱 +380XXXXXXXXX",
      photo: "assets/my_photo.jpg",
    ),
    Person(
      id: "2",
      name: "Андрій Коваленко",
      role: "Backend розробник",
      hobbies: "⚽ Футбол, 🍳 Кулінарія",
      education: "🔹 КПІ\n🔹 Програмна інженерія",
      contacts: "📧 andrii@example.com\n📱 +380YYYYYYYYY",
      photo: "assets/andrii.jpg",
    ),
  ];

  List<Person> get persons => List.unmodifiable(_persons);

  Future<void> addPerson(Person person) async {
    _persons.add(person);
    await _saveToStorage();
  }

  Future<void> updatePerson(Person updatedPerson) async {
    final index = _persons.indexWhere((p) => p.id == updatedPerson.id);
    if (index != -1) {
      _persons[index] = updatedPerson;
      await _saveToStorage();
    }
  }

  Future<void> deletePerson(String id) async {
    _persons.removeWhere((p) => p.id == id);
    await _saveToStorage();
  }

  Person duplicatePerson(Person original) {
    final newId = _generateUniqueId();
    return Person.copyWith(newId: newId, original: original);
  }

  String _generateUniqueId() {
    final random = Random();
    String newId;
    do {
      newId = random.nextInt(999999).toString();
    } while (_persons.any((p) => p.id == newId));
    return newId;
  }

  Person? getPersonById(String id) {
    try {
      return _persons.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_storageKey);
    if (jsonStr == null) return; // keep defaults
    try {
      final List<dynamic> decoded = jsonDecode(jsonStr) as List<dynamic>;
      _persons
        ..clear()
        ..addAll(decoded.map((e) => Person.fromMap(Map<String, dynamic>.from(e))));
    } catch (_) {
      // ignore parse errors, keep defaults
    }
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _persons.map((p) => p.toMap()).toList();
    await prefs.setString(_storageKey, jsonEncode(data));
  }
}
