import 'package:lab2_moviles/models/todo.dart';

/// Clase base de todos los eventos del BLoC
abstract class TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final Todo todo;
  AddTodoEvent(this.todo);
}

class EditTodoEvent extends TodoEvent {
  final String id;
  final String title;
  final String description;
  final DateTime? dueDate;

  EditTodoEvent({
    required this.id,
    required this.title,
    required this.description,
    this.dueDate,
  });
}

class ToggleDoneEvent extends TodoEvent {
  final String id;
  ToggleDoneEvent(this.id);
}

class DeleteTodoEvent extends TodoEvent {
  final String id;
  DeleteTodoEvent(this.id);
}

class SortTodosEvent extends TodoEvent {
  final String criteria; // 'titleAsc' | 'titleDesc' | 'done' | 'notDone' | 'dueDate'
  SortTodosEvent(this.criteria);
}
