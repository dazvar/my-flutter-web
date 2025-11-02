import 'package:flutter/material.dart';
import '../models/person.dart';

class AboutPage extends StatelessWidget {
  final Person? person;

  AboutPage({this.person});

  @override
  Widget build(BuildContext context) {
    if (person == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Про мене")),
        body: Center(child: Text("Дані не вибрані")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(person!.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(person!.photo),
            ),
            SizedBox(height: 20),
            Text(person!.role, style: TextStyle(fontSize: 18)),
            Divider(),
            Text("Хобі:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(person!.hobbies),
            SizedBox(height: 10),
            Text("Освіта:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(person!.education),
            SizedBox(height: 10),
            Text("Контакти:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(person!.contacts),
          ],
        ),
      ),
    );
  }
}
