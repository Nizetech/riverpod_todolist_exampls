// A read-only description of a todo-list

import 'package:hooks_riverpod/hooks_riverpod.dart';

String myId = DateTime.now().millisecondsSinceEpoch.toString();

// Todo model
class Todo {
  final String id;
  final String description;
  final bool completed;

  Todo({
    required this.description,
    this.completed = false,
    required this.id,
    //  this.id = myId,
    // ignore: prefer_initializing_formals
  });

  @override
  String toString() {
    return 'Todo{id: $id, description: $description, completed: $completed}';
  }
}

// Logic to manage the list of todos
// StateNotifier is a class that allows to mutate the state of a provider , it is a value notifier
class TodoList extends StateNotifier<List<Todo>> {
  TodoList([List<Todo>? initialTodos]) : super(initialTodos ?? []);

  void add(String description) {
    state = [
      ...state,
      Todo(
        id: myId,
        description: description,
      ),
    ];
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            completed: !todo.completed,
            description: todo.description,
          )
        else
          todo
    ];
  }

  void edit({required String id, required String description}) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            description: description,
            completed: todo.completed,
          )
        else
          todo
    ];
  }

  void remove(Todo target) {
    state = state.where((todo) => todo.id != target.id).toList();
  }
}

/// creates a [TodoList] and initializes it with some pre-existing values
///
/// We are using [StateNotifierProvider] to create a provider that will manage the state of our list of todos
final todoListProvider =
    StateNotifierProvider<TodoList, List<Todo>>((ref) => TodoList([
          Todo(id: '0', description: 'Buy milk'),
          Todo(id: '1', description: 'Buy eggs'),
          Todo(id: '2', description: 'Buy bread'),
        ]));

enum TodoListFilter {
  all,
  active,
  completed,
}

/// The currently actuve filter
/// we use [StateProvider] here as there is no fancy logic behind manipulating the state
/// The state is just a simple enum
final todoListFilter = StateProvider((_) => TodoListFilter.all);

/// Ther current active search
final todoListSearch = StateProvider((_) => '');

final uncompletedTodosCount = Provider<int>((ref) {
  final todos = ref.read(todoListProvider);
  return todos.where((todo) => !todo.completed).length;
});

final filteredTodos = Provider<List<Todo>>((ref) {
  final filter = ref.read(todoListFilter);
  final todos = ref.read(todoListProvider);
  final search = ref.read(todoListSearch);

  List<Todo> filteredTodos;

  switch (filter) {
    case TodoListFilter.completed:
      return filteredTodos = todos.where((todo) => todo.completed).toList();
    case TodoListFilter.active:
      return filteredTodos = todos.where((todo) => !todo.completed).toList();
    case TodoListFilter.all:
    default:
      filteredTodos = todos;
      break;
  }

  if (search.isEmpty) {
    return filteredTodos;
  } else {
    return filteredTodos = filteredTodos
        .where((todo) => todo.description.contains(search))
        .toList();
  }

  // return filteredTodos;
});
