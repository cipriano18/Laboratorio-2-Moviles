import 'package:flutter/material.dart';
import 'package:lab2_moviles/models/todo.dart';
import 'package:lab2_moviles/data/TodoList.dart';
import 'package:lab2_moviles/widgets/todo_card.dart';
import 'package:lab2_moviles/widgets/search_bar_widget.dart';
import 'package:lab2_moviles/screens/add_edit_screen.dart';
import 'package:lab2_moviles/theme/app_theme.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  final TodoList _todoList = TodoList();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _todoList.addTodo(
      Todo(
        id: '1',
        title: 'Comprar víveres',
        description: 'Leche, huevos, pan y frutas',
        dueDate: DateTime.now().add(const Duration(days: 1)),
      ),
    );
    _todoList.addTodo(
      Todo(
        id: '2',
        title: 'Estudiar Flutter',
        description: 'Repasar widgets y navegación',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        isDone: true,
      ),
    );
    _todoList.addTodo(
      Todo(
        id: '3',
        title: 'Llamar al médico',
        description: 'Agendar cita de revisión anual',
        dueDate: DateTime.now().subtract(const Duration(days: 1)), // vencida
      ),
    );
  }

  // ── Filtro ─────────────────────────────────────────────────────────────────
  List<Todo> get _filteredTodos {
    final all = _todoList.getTodos();
    if (_query.isEmpty) return all;
    final lower = _query.toLowerCase();
    return all
        .where(
          (t) =>
              t.title.toLowerCase().contains(lower) ||
              t.description.toLowerCase().contains(lower),
        )
        .toList();
  }

  // ── Handlers ───────────────────────────────────────────────────────────────
  void _toggleDone(String id) {
    setState(() => _todoList.toggleDone(id));
  }

  void _deleteTodo(String id) {
    final todo = _todoList.todos.firstWhere((t) => t.id == id);
    setState(() => _todoList.deleteTodo(todo));
  }

  void _onSearchChanged(String value) {
    setState(() => _query = value);
  }

  // ── Navegar a AddEditScreen ────────────────────────────────────────────────
  Future<void> _openFormScreen({Todo? existing}) async {
    final result = await Navigator.push<Todo>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditScreen(tareaExistente: existing),
      ),
    );

    if (result == null) return;

    setState(() {
      if (existing == null) {
        _todoList.addTodo(result);
      } else {
        _todoList.editTodo(
          existing.id,
          title: result.title,
          description: result.description,
          dueDate: result.dueDate,
        );
      }
    });
  }

  // ── UI ─────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTodos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        actions: [
          // ── Badge contador ──────────────────────────────
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_todoList.getNotDone().length} pendientes',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
          // ── Filtro ──────────────────────────────────────
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_alt),
            onSelected: (value) {
              setState(() {
                switch (value) {
                  case 'titleAsc':
                    _todoList.sortByTitle();
                    break;
                  case 'titleDesc':
                    _todoList.sortByTitleDesc();
                    break;
                  case 'done':
                    _todoList.sortByDone();
                    break;
                  case 'notDone':
                    _todoList.sortByNotDone();
                    break;
                  case 'dueDate':
                    _todoList.sortByDueDate();
                    break;
                }
              });
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'titleAsc', child: Text('Título A-Z')),
              PopupMenuItem(value: 'titleDesc', child: Text('Título Z-A')),
              PopupMenuItem(value: 'done', child: Text('Completadas primero')),
              PopupMenuItem(
                value: 'notDone',
                child: Text('Pendientes primero'),
              ),
              PopupMenuItem(value: 'dueDate', child: Text('Por fecha límite')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          SearchBarWidget(onChanged: _onSearchChanged),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No hay tareas que coincidan'))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final todo = filtered[index];
                      return TodoCard(
                        todo: todo,
                        onToggleDone: () => _toggleDone(todo.id),
                        onDelete: () => _deleteTodo(todo.id),
                        onEdit: () => _openFormScreen(existing: todo),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openFormScreen(),
        child: const Icon(Icons.add_task_rounded),
      ),
    );
  }
}
