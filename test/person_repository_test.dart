import 'package:flutter_test/flutter_test.dart';
import 'package:namer_app/models/person.dart';
import 'package:namer_app/repository/person_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('PersonRepository persistence', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    test('load keeps defaults when no storage, then persists after add', () async {
      final repo1 = PersonRepository();
      await repo1.loadFromStorage();
      expect(repo1.persons.length, 2);

      final newPerson = Person(
        id: '999',
        name: 'Unit Test User',
        role: 'QA інженер',
        hobbies: 'Тести',
        education: 'Курс',
        contacts: 'test@example.com',
        photo: 'assets/test.jpg',
      );
      await repo1.addPerson(newPerson);
      expect(repo1.persons.length, 3);

      final repo2 = PersonRepository();
      await repo2.loadFromStorage();
      expect(repo2.persons.length, 3);
      expect(repo2.persons.any((p) => p.id == '999' && p.name == 'Unit Test User'), isTrue);
    });

    test('update and delete persist correctly', () async {
      final repo = PersonRepository();
      await repo.loadFromStorage();
      final originalCount = repo.persons.length; // should be 2

      final p = Person(
        id: '1000',
        name: 'Temp',
        role: 'Developer',
        hobbies: 'Code',
        education: 'Uni',
        contacts: 'temp@example.com',
        photo: 'assets/a.jpg',
      );
      await repo.addPerson(p);
      expect(repo.persons.length, originalCount + 1);

      final updated = p.copyWith(name: 'Temp Updated');
      await repo.updatePerson(updated);
      expect(repo.getPersonById('1000')!.name, 'Temp Updated');

      await repo.deletePerson('1000');
      expect(repo.getPersonById('1000'), isNull);

      final repoReloaded = PersonRepository();
      await repoReloaded.loadFromStorage();
      expect(repoReloaded.getPersonById('1000'), isNull);
      expect(repoReloaded.persons.length, originalCount);
    });
  });
}
