import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_todolist/vandad_tutorials/create_person/person_data_model.dart';

class CreatePerson extends ConsumerWidget {
  const CreatePerson({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Person'),
        centerTitle: true,
      ),
      body: Consumer(
        builder: ((context, ref, child) {
          final dataModel = ref.watch(peopleProvider);
          return ListView.builder(
              itemCount: dataModel.count,
              itemBuilder: ((context, index) {
                final person = dataModel.people[index];
                return ListTile(
                  title: GestureDetector(
                      onTap: () async {
                        final updatedPerson = await createOrUpdatePersonDialog(
                          context,
                          person,
                        );
                        if (updatedPerson != null) {
                          dataModel.updatePerson(updatedPerson);
                        }
                      },
                      child: Text(
                        person.displayName,
                        style: TextStyle(color: Colors.black),
                      )),
                  subtitle: Text(
                    person.age.toString(),
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }));
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final person = await createOrUpdatePersonDialog(context);
          if (person != null) {
            final dataModel =
                ref.read(peopleProvider.notifier).addPerson(person);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
