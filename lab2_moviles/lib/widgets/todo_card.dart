import 'package:flutter/material.dart';
import 'package:lab2_moviles/models/todo.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleDone;

  static const Color _primary = Color(0xFF4EAC7F);
  static const Color _secondary = Color(0xFF92C794);
  static const Color _accent = Color(0xFFB2DB70);

  const TodoCard({
    super.key,
    required this.todo,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleDone,
  });

  @override
  Widget build(BuildContext context) {
    final bool done = todo.isDone;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Dismissible(
        key: ValueKey(todo.id),
        direction: DismissDirection.endToStart, // deslizar a la izquierda
        onDismissed: (_) => onDelete(),
        background: _SwipeBackground(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: done ? const Color(0xFFEAF7EE) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border(
              left: BorderSide(color: done ? _accent : _secondary, width: 5),
            ),
            boxShadow: [
              BoxShadow(
                color: _primary.withOpacity(done ? 0.15 : 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 12, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Texto ──────────────────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A3C2E),
                          decoration: done
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: _primary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        todo.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 6),
                      // ── Fila inferior: fecha + badge ─────────────────────
                      Row(
                        children: [
                          if (todo.dueDate != null) ...[
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 11,
                              color: _dueDateColor(todo.dueDate!, done),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              _formatDate(todo.dueDate!),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: _dueDateColor(todo.dueDate!, done),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          if (done)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _accent.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                '✓ Completada',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D7A50),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // ── Botones ────────────────────────────────────────────────
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _IconBtn(
                      icon: Icons.edit_rounded,
                      color: _primary,
                      bgColor: _primary.withOpacity(0.1),
                      tooltip: 'Editar',
                      onTap: onEdit,
                    ),
                    const SizedBox(height: 6),
                    _DoneBtn(isDone: done, onTap: onToggleDone),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Color _dueDateColor(DateTime date, bool done) {
    if (done) return Colors.grey[400]!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(date.year, date.month, date.day);
    if (due.isBefore(today)) return Colors.redAccent;
    if (due == today) return Colors.orange;
    return Colors.grey[500]!;
  }
}

// ── Fondo del swipe ────────────────────────────────────────────────────────────
class _SwipeBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 24),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete_outline_rounded, color: Colors.white, size: 26),
          SizedBox(height: 4),
          Text(
            'Eliminar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Botón de acción genérico ───────────────────────────────────────────────────
class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String tooltip;
  final VoidCallback onTap;

  const _IconBtn({
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 17),
        ),
      ),
    );
  }
}

// ── Botón completado animado ───────────────────────────────────────────────────
class _DoneBtn extends StatelessWidget {
  final bool isDone;
  final VoidCallback onTap;

  static const Color _primary = Color(0xFF4EAC7F);
  static const Color _accent = Color(0xFFB2DB70);

  const _DoneBtn({required this.isDone, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isDone ? 'Marcar pendiente' : 'Marcar completada',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            gradient: isDone
                ? const LinearGradient(
                    colors: [_primary, _accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isDone ? null : Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              Icons.check_rounded,
              key: ValueKey(isDone),
              color: isDone ? Colors.white : Colors.grey[400],
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
