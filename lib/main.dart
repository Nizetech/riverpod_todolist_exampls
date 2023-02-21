import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_todolist/todo.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends HookConsumerWidget {
  Home({Key? key}) : super(key: key);
  TextEditingController newTodoController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newTodoController = useTextEditingController();
    final todos = ref.watch(filteredTodos);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            children: [
              Title(),
              TextField(
                controller: newTodoController,
                decoration: InputDecoration(
                  labelText: 'What need to be done??',
                ),
                onSubmitted: (value) {
                  // addTodo();
                  ref.read(todoListProvider.notifier).add(value);
                  newTodoController.clear();
                },
              ),
              const SizedBox(height: 42),
              Column(
                children: [
                  // ToolBar(),

                  if (todos.isNotEmpty) const Divider(height: 0),
                  for (var i = 0; i < todos.length; i++) ...[
                    if (i > 0) const Divider(height: 0),
                    Dismissible(
                      key: ValueKey(todos[i].id),
                      onDismissed: (_) {
                        ref.read(todoListProvider.notifier).remove(todos[i]);
                      },
                      child: ProviderScope(
                        // overrides: [
                        // currentTodo.overrideWithValue(todos[i]),
                        // ],
                        child: TodoItem(
                          todo: todos[i],
                        ),
                      ),
                    ),
                  ]
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'todos',
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
          ),
        ),
        Icon(Icons.check, size: 30),
      ],
    );
  }
}

class TodoItem extends HookConsumerWidget {
  final Todo todo;
  const TodoItem({Key? key, required this.todo}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ItemFocusNode = useFocusNode();
    useListenable(ItemFocusNode);
    bool isFocused = ItemFocusNode.hasFocus;

    final textEditingController = useTextEditingController();
    final textFieldFocusNode = useFocusNode();

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Material(
        color: Colors.white,
        elevation: 3,
        child: Focus(
            focusNode: ItemFocusNode,
            onFocusChange: (focus) {
              if (focus) {
                textEditingController.text = todo.description;
              } else {
                ref
                    .read(todoListProvider.notifier)
                    .edit(id: todo.id, description: textEditingController.text);
              }
            },
            child: ListTile(
                onTap: () {
                  ItemFocusNode.requestFocus();
                  textFieldFocusNode.requestFocus();
                },
                leading: Checkbox(
                  value: todo.completed,
                  onChanged: (value) {
                    ref.read(todoListProvider.notifier).toggle(todo.id);
                  },
                ),
                title: isFocused
                    ? TextField(
                        controller: textEditingController,
                        focusNode: textFieldFocusNode,
                        autofocus: true,
                        onSubmitted: (value) {
                          ItemFocusNode.unfocus();
                        },
                      )
                    : Text(
                        todo.description,
                        style: TextStyle(
                          fontSize: 16,
                          // decoration: todo.completed
                          //     // ? TextDecoration.lineThrough
                          //     // :
                          //     TextDecoration.none,
                        ),
                      ))),
      ),
    );
  }
}

class ToolBar extends HookConsumerWidget {
  const ToolBar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final filter = ref.watch(todoListFilter);
    final search = ref.read(todoListSearch);

    Color textColor(TodoListFilter value) =>
        filter == value ? Colors.blue : Colors.black;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${ref.read(uncompletedTodosCount)} items left'),
        Expanded(
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search',
              border: InputBorder.none,
              icon: Icon(Icons.search),
            ),
            onChanged: (value) {
              ref.read(todoListSearch.notifier).state = value;
            },
          ),
        ),
        Tooltip(
          message: 'All todos',
          child: TextButton(
            onPressed: () =>
                ref.read(todoListFilter.notifier).state = TodoListFilter.all,
            child: Text(
              'All',
              style: TextStyle(color: textColor(TodoListFilter.all)),
            ),
          ),
        ),
        Tooltip(
          message: 'Only uncompleted todos',
          child: TextButton(
            onPressed: () =>
                ref.read(todoListFilter.notifier).state = TodoListFilter.active,
            child: Text(
              'Active',
              style: TextStyle(color: textColor(TodoListFilter.active)),
            ),
          ),
        ),
        Tooltip(
          message: 'completed todos',
          child: TextButton(
            onPressed: () => ref.read(todoListFilter.notifier).state =
                TodoListFilter.completed,
            child: Text(
              'Completed',
              style: TextStyle(color: textColor(TodoListFilter.completed)),
            ),
          ),
        ),
      ],
    );
  }
}
