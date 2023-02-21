import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_todolist/vandad_tutorials/stream_provider/providers.dart';

class MyStreamProvider extends ConsumerWidget {
  const MyStreamProvider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(nameProvider);
    return Scaffold(
        appBar: AppBar(title: Text('Stream Provider')),
        body: names.when(
          data: (names) => ListView.builder(
            itemCount: names.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(names.elementAt(index)),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Reach the end of the stream'),
          ),
        ));
  }
}
