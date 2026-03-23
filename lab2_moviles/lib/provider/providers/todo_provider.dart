import 'package:flutter/material.dart';
import 'package:lab2_moviles/models/todo.dart';

class TodoProvider extends ChangeNotifier {
  final List<Todo> _todos = [
    Todo(
      id: '1',
      title: 'Comprar víveres',
      description: 'Leche, huevos, pan y frutas',
      dueDate: DateTime.now().add(const Duration(days: 1)),
    ),
    Todo(
      id: '2',
      title: 'Estudiar Flutter',
      description: 'Repasar widgets y navegación',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      isDone: true,
    ),
    Todo(
      id: '3',
      title: 'Llamar al médico',
      description: 'Agendar cita de revisión anual',
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // ── Getters ───────────────────────────────────────────────────────────────
  List<Todo> get todos => List.unmodifiable(_todos);

  int get pendingCount => _todos.where((t) => !t.isDone).length;

  // ── CREATE ────────────────────────────────────────────────────────────────
  void addTodo(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  // ── EDIT ──────────────────────────────────────────────────────────────────
  void editTodo(String id, {String? title, String? description, DateTime? dueDate}) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(
        title: title,
        description: description,
        dueDate: dueDate,
      );
      notifyListeners();
    }
  }

  // ── TOGGLE DONE ───────────────────────────────────────────────────────────
  void toggleDone(String id) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(isDone: !_todos[index].isDone);
      notifyListeners();
    }
  }

  // ── DELETE ────────────────────────────────────────────────────────────────
  void deleteTodo(String id) {
    _todos.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // ── SORT ──────────────────────────────────────────────────────────────────
  void sortByTitle()     { _todos.sort((a, b) => a.title.compareTo(b.title));  notifyListeners(); }
  void sortByTitleDesc() { _todos.sort((a, b) => b.title.compareTo(a.title));  notifyListeners(); }
  void sortByDone()      { _todos.sort((a, b) => a.isDone == b.isDone ? 0 : a.isDone ? -1 : 1); notifyListeners(); }
  void sortByNotDone()   { _todos.sort((a, b) => a.isDone == b.isDone ? 0 : a.isDone ? 1 : -1); notifyListeners(); }
  void sortByDueDate() {
    _todos.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });
    notifyListeners();
  }

  // ── FILTER ────────────────────────────────────────────────────────────────
  List<Todo> search(String query) {
    if (query.isEmpty) return todos;
    final lower = query.toLowerCase();
    return _todos
        .where((t) =>
            t.title.toLowerCase().contains(lower) ||
            t.description.toLowerCase().contains(lower))
        .toList();
  }
}
