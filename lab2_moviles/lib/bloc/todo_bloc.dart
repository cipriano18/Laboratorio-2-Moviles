import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab2_moviles/models/todo.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc()
      : super(
          TodoState(
            todos: [
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
            ],
          ),
        ) {
    on<AddTodoEvent>(_onAdd);
    on<EditTodoEvent>(_onEdit);
    on<ToggleDoneEvent>(_onToggle);
    on<DeleteTodoEvent>(_onDelete);
    on<SortTodosEvent>(_onSort);
  }

  // ── Handlers ───────────────────────────────────────────────────────────────

  void _onAdd(AddTodoEvent event, Emitter<TodoState> emit) {
    emit(state.copyWith(todos: [...state.todos, event.todo]));
  }

  void _onEdit(EditTodoEvent event, Emitter<TodoState> emit) {
    final updated = state.todos.map((t) {
      if (t.id != event.id) return t;
      return t.copyWith(
        title: event.title,
        description: event.description,
        dueDate: event.dueDate,
      );
    }).toList();
    emit(state.copyWith(todos: updated));
  }

  void _onToggle(ToggleDoneEvent event, Emitter<TodoState> emit) {
    final updated = state.todos.map((t) {
      if (t.id != event.id) return t;
      return t.copyWith(isDone: !t.isDone);
    }).toList();
    emit(state.copyWith(todos: updated));
  }

  void _onDelete(DeleteTodoEvent event, Emitter<TodoState> emit) {
    emit(state.copyWith(
      todos: state.todos.where((t) => t.id != event.id).toList(),
    ));
  }

  void _onSort(SortTodosEvent event, Emitter<TodoState> emit) {
    final sorted = [...state.todos];
    switch (event.criteria) {
      case 'titleAsc':
        sorted.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'titleDesc':
        sorted.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'done':
        sorted.sort((a, b) => a.isDone == b.isDone ? 0 : a.isDone ? -1 : 1);
        break;
      case 'notDone':
        sorted.sort((a, b) => a.isDone == b.isDone ? 0 : a.isDone ? 1 : -1);
        break;
      case 'dueDate':
        sorted.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
    }
    emit(state.copyWith(todos: sorted));
  }
}
