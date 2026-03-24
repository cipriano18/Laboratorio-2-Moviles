import 'package:lab2_moviles/models/todo.dart';

/// Estado inmutable que el BLoC emite cada vez que algo cambia
class TodoState {
  final List<Todo> todos;

  const TodoState({required this.todos});

  int get pendingCount => todos.where((t) => !t.isDone).length;

  List<Todo> search(String query) {
    if (query.isEmpty) return todos;
    final lower = query.toLowerCase();
    return todos
        .where((t) =>
            t.title.toLowerCase().contains(lower) ||
            t.description.toLowerCase().contains(lower))
        .toList();
  }

  // Copia del estado con nueva lista (para inmutabilidad)
  TodoState copyWith({List<Todo>? todos}) {
    return TodoState(todos: todos ?? this.todos);
  }
}
