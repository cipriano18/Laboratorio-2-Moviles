import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lab2_moviles/models/todo.dart';
import 'package:lab2_moviles/theme/app_theme.dart';
import 'package:lab2_moviles/widgets/todo_card.dart';
import 'package:lab2_moviles/widgets/search_bar_widget.dart';
import 'package:lab2_moviles/setstate/screens/add_edit_screen.dart';
import 'package:lab2_moviles/provider/providers/todo_provider.dart';

class TodosScreenProvider extends StatefulWidget {
  const TodosScreenProvider({super.key});

  @override
  State<TodosScreenProvider> createState() => _TodosScreenProviderState();
}

class _TodosScreenProviderState extends State<TodosScreenProvider> {
  String _query = '';

  Future<void> _openFormScreen({Todo? existing}) async {
    final result = await Navigator.push<Todo>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditScreen(tareaExistente: existing),
      ),
    );
    if (result == null) return;

    final provider = context.read<TodoProvider>();
    if (existing == null) {
      provider.addTodo(result);
    } else {
      provider.editTodo(
        existing.id,
        title: result.title,
        description: result.description,
        dueDate: result.dueDate,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // consumer reconstruye solo este widget cuando cambia el provider
    return Consumer<TodoProvider>(
      builder: (context, provider, _) {
        final filtered = provider.search(_query);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Mis Tareas'),
            actions: [
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${provider.pendingCount} pendientes',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.filter_alt),
                onSelected: (value) {
                  switch (value) {
                    case 'titleAsc':  provider.sortByTitle();     break;
                    case 'titleDesc': provider.sortByTitleDesc(); break;
                    case 'done':      provider.sortByDone();      break;
                    case 'notDone':   provider.sortByNotDone();   break;
                    case 'dueDate':   provider.sortByDueDate();   break;
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'titleAsc',  child: Text('Título A-Z')),
                  PopupMenuItem(value: 'titleDesc', child: Text('Título Z-A')),
                  PopupMenuItem(value: 'done',      child: Text('Completadas primero')),
                  PopupMenuItem(value: 'notDone',   child: Text('Pendientes primero')),
                  PopupMenuItem(value: 'dueDate',   child: Text('Por fecha límite')),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              SearchBarWidget(onChanged: (v) => setState(() => _query = v)),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('No hay tareas que coincidan'))
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final todo = filtered[index];
                          return TodoCard(
                            todo: todo,
                            onToggleDone: () => provider.toggleDone(todo.id),
                            onDelete:     () => provider.deleteTodo(todo.id),
                            onEdit:       () => _openFormScreen(existing: todo),
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
      },
    );
  }
}
