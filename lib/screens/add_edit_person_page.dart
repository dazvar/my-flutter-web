import 'dart:math';
import 'package:flutter/material.dart';
import '../models/person.dart';
import '../repository/person_repository.dart';

class AddEditPersonPage extends StatefulWidget {
  final PersonRepository repository;
  final Person? personToEdit;

  const AddEditPersonPage({
    required this.repository,
    this.personToEdit,
    super.key,
  });

  @override
  State<AddEditPersonPage> createState() => _AddEditPersonPageState();
}

class _AddEditPersonPageState extends State<AddEditPersonPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _hobbiesController = TextEditingController();
  final _educationController = TextEditingController();
  final _contactsController = TextEditingController();
  final _photoController = TextEditingController();

  String _selectedRole = 'Flutter розробник';
  final List<String> _availableRoles = [
    'Flutter розробник',
    'Backend розробник',
    'Frontend розробник',
    'Full-stack розробник',
    'Mobile розробник',
    'DevOps інженер',
    'UI/UX дизайнер',
    'QA інженер',
    'Data Scientist',
    'Project Manager',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.personToEdit != null) {
      _populateFields(widget.personToEdit!);
    } else {
      _photoController.text = 'assets/default_avatar.jpg';
    }
  }

  void _populateFields(Person person) {
    _nameController.text = person.name;
    _roleController.text = person.role;
    _hobbiesController.text = person.hobbies;
    _educationController.text = person.education;
    _contactsController.text = person.contacts;
    _photoController.text = person.photo;
    _selectedRole = person.role;
  }

  String _generateUniqueId() {
    final random = Random();
    String newId;
    do {
      newId = random.nextInt(999999).toString();
    } while (widget.repository.persons.any((p) => p.id == newId));
    return newId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _hobbiesController.dispose();
    _educationController.dispose();
    _contactsController.dispose();
    _photoController.dispose();
    super.dispose();
  }

  void _savePerson() {
    if (_formKey.currentState!.validate()) {
      final person = Person(
        id: widget.personToEdit?.id ?? _generateUniqueId(),
        name: _nameController.text.trim(),
        role: _selectedRole,
        hobbies: _hobbiesController.text.trim(),
        education: _educationController.text.trim(),
        contacts: _contactsController.text.trim(),
        photo: _photoController.text.trim(),
      );

      () async {
        if (widget.personToEdit != null) {
          await widget.repository.updatePerson(person);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Резюме оновлено!')),
          );
        } else {
          await widget.repository.addPerson(person);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Нове резюме додано!')),
          );
        }

        if (mounted) Navigator.pop(context);
      }();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.personToEdit != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редагувати резюме' : 'Додати нове резюме'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Поле імені
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Повне ім\'я *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Будь ласка, введіть ім\'я';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Випадаючий список ролей
              DropdownButtonFormField<String>(
                initialValue: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Роль *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
                items: _availableRoles.map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedRole = newValue;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Будь ласка, оберіть роль';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Поле хобі
              TextFormField(
                controller: _hobbiesController,
                decoration: const InputDecoration(
                  labelText: 'Хобі та інтереси *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.favorite),
                  hintText: 'Наприклад: 🎸 Музика, 🎮 Ігри, 📚 Книги',
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Будь ласка, введіть хобі';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Поле освіти
              TextFormField(
                controller: _educationController,
                decoration: const InputDecoration(
                  labelText: 'Освіта *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                  hintText: 'Наприклад: 🔹 Наразі навчаюсь у ХПІ\n🔹 IT',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Будь ласка, введіть освіту';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Поле контактів
              TextFormField(
                controller: _contactsController,
                decoration: const InputDecoration(
                  labelText: 'Контакти *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.contact_phone),
                  hintText: 'Наприклад: 📧 email@gmail.com\n📱 +380XXXXXXXXX',
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Будь ласка, введіть контакти';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Поле фото
              TextFormField(
                controller: _photoController,
                decoration: const InputDecoration(
                  labelText: 'Шлях до фото',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.photo),
                  hintText: 'assets/photo.jpg',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Будь ласка, введіть шлях до фото';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Кнопки
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Скасувати'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _savePerson,
                      child: Text(isEditing ? 'Оновити' : 'Додати'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Видалити резюме'),
          content: const Text('Ви впевнені, що хочете видалити це резюме?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Скасувати'),
            ),
            TextButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);
                await widget.repository.deletePerson(widget.personToEdit!.id);
                navigator.pop(); // Закрити діалог
                navigator.pop(); // Повернутися на попередню сторінку
                messenger.showSnackBar(
                  const SnackBar(content: Text('Резюме видалено!')),
                );
              },
              child: const Text('Видалити', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
