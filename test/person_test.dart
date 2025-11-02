import 'package:flutter_test/flutter_test.dart';
import 'package:namer_app/models/person.dart';

void main() {
  group('Person serialization', () {
    test('toMap and fromMap preserve all fields', () {
      final original = Person(
        id: '123',
        name: 'Test Name',
        role: 'Flutter розробник',
        hobbies: '🎸 Музика',
        education: 'ХПІ',
        contacts: 'email@example.com',
        photo: 'assets/p.jpg',
      );

      final map = original.toMap();
      final restored = Person.fromMap(map);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.role, original.role);
      expect(restored.hobbies, original.hobbies);
      expect(restored.education, original.education);
      expect(restored.contacts, original.contacts);
      expect(restored.photo, original.photo);
    });
  });
}
