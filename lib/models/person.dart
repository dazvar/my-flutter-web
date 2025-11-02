class Person {
  final String id;
  final String name;
  final String role;
  final String hobbies;
  final String education;
  final String contacts;
  final String photo;

  Person({
    required this.id,
    required this.name,
    required this.role,
    required this.hobbies,
    required this.education,
    required this.contacts,
    required this.photo,
  });

  Person.copyWith({
    required String newId,
    required Person original,
  }) : id = newId,
       name = original.name,
       role = original.role,
       hobbies = original.hobbies,
       education = original.education,
       contacts = original.contacts,
       photo = original.photo;

  Person copyWith({
    String? id,
    String? name,
    String? role,
    String? hobbies,
    String? education,
    String? contacts,
    String? photo,
  }) {
    return Person(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      hobbies: hobbies ?? this.hobbies,
      education: education ?? this.education,
      contacts: contacts ?? this.contacts,
      photo: photo ?? this.photo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'hobbies': hobbies,
      'education': education,
      'contacts': contacts,
      'photo': photo,
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['id'] as String,
      name: map['name'] as String,
      role: map['role'] as String,
      hobbies: map['hobbies'] as String,
      education: map['education'] as String,
      contacts: map['contacts'] as String,
      photo: map['photo'] as String,
    );
  }
}
