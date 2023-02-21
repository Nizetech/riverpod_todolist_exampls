import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final myId = DateTime.now().millisecondsSinceEpoch.toString();

@immutable
class Person {
  final String name;
  final int age;
  final String id;

  Person({
    required this.name,
    required this.age,
    String? id,
  }) : id = id ?? myId;

  Person updated([String? name, int? age]) {
    return Person(
      name: name ?? this.name,
      age: age ?? this.age,
      id: id,
    );
  }

  String get displayName => '$name ($age years old)';

  @override
  bool operator ==(covariant Person other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Person{id: $id, name: $name, age: $age}';
}

class DataModel extends ChangeNotifier {
  final List<Person> _people = [];

  int get count => _people.length;

  UnmodifiableListView<Person> get people => UnmodifiableListView(_people);

  void addPerson(Person person) {
    _people.add(person);
    notifyListeners();
  }

  void removePerson(Person person) {
    _people.remove(person);
    notifyListeners();
  }

  void updatePerson(Person updatedPerson) {
    final index = _people.indexOf(updatedPerson);
    final oldPerson = _people[index];
    if (oldPerson.name != updatedPerson.name ||
        oldPerson.age != updatedPerson.age) {
      _people[index] = oldPerson.updated(
        updatedPerson.name,
        updatedPerson.age,
      );
      notifyListeners();
    }
  }
}

final peopleProvider = ChangeNotifierProvider((_) => DataModel());

final nameController = TextEditingController();
final ageController = TextEditingController();

Future<Person?> createOrUpdatePersonDialog(BuildContext context,
    [Person? existingPerson]) {
  String? name = existingPerson?.name;
  int? age = existingPerson?.age;

  nameController.text = name ?? '';
  ageController.text = age?.toString() ?? '';

  return showDialog(
    context: context,
    builder: ((context) => AlertDialog(
          title:
              Text(existingPerson == null ? 'Create Person' : 'Update Person'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Enter Name here...',
                ),
                onChanged: (value) => name = value,
              ),
              TextField(
                controller: ageController,
                decoration: InputDecoration(
                  labelText: 'Enter Age here...',
                ),
                onChanged: (value) => age = int.tryParse(value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (name != null && age != null) {
                  if (existingPerson != null) {
                    // have Existing person, so update it
                    final newPerson = existingPerson.updated(
                      name,
                      age,
                    );
                    Navigator.of(context).pop(newPerson);
                  } else {
                    // no existing person, so create a new one
                    Navigator.of(context).pop(
                      Person(
                        name: name!,
                        age: age!,
                      ),
                    );
                  }
                } else {
                  // no name or age, so just close the dialog
                  Navigator.of(context).pop();
                }
              },
              child: Text(existingPerson == null ? 'Create' : 'Update'),
            ),
          ],
        )),
  );
}
