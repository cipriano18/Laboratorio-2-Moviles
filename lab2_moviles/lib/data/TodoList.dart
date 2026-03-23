import '../models/todo.dart';

class TodoList {
  List<Todo> todos = [];

  // GET
  List<Todo> getTodos() {
    return todos;
  }

  // CREATE
  void addTodo(Todo todo) {
    todos.add(todo);
  }

  // EDIT
  void editTodo(
    String id, {
    String? title,
    String? description,
    DateTime? dueDate,
  }) {
    final index = todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      todos[index] = todos[index].copyWith(
        title: title,
        description: description,
        dueDate: dueDate,
      );
    }
  }

  // TOGGLE DONE
  void toggleDone(String id) {
    final index = todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      todos[index] = todos[index].copyWith(isDone: !todos[index].isDone);
    }
  }

  // DELETE
  void deleteTodo(Todo todo) {
    todos.remove(todo);
  }

  // SORT: por título A-Z
  void sortByTitle() {
    todos.sort((a, b) => a.title.compareTo(b.title));
  }

  // SORT: por título Z-A
  void sortByTitleDesc() {
    todos.sort((a, b) => b.title.compareTo(a.title));
  }

  // SORT: completadas primero
  void sortByDone() {
    todos.sort((a, b) {
      if (a.isDone == b.isDone) return 0;
      return a.isDone ? -1 : 1;
    });
  }

  // SORT: pendientes primero
  void sortByNotDone() {
    todos.sort((a, b) {
      if (a.isDone == b.isDone) return 0;
      return a.isDone ? 1 : -1;
    });
  }

  // SORT: por fecha límite (más próxima primero, sin fecha al final)
  void sortByDueDate() {
    todos.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });
  }

  // FILTER: solo completadas
  List<Todo> getDone() {
    return todos.where((t) => t.isDone).toList();
  }

  // FILTER: solo pendientes
  List<Todo> getNotDone() {
    return todos.where((t) => !t.isDone).toList();
  }
}
