import 'package:flutter/material.dart';
import 'package:lab2_moviles/models/place.dart';

class PlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleVisited;

  const PlaceCard({
    super.key,
    required this.place,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleVisited,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Left: text info ──────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    place.address,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            // ── Right: action buttons ─────────────────────────────
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Top row: delete + edit
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ActionButton(
                      icon: Icons.delete_outline_rounded,
                      onTap: onDelete,
                      tooltip: 'Eliminar lugar',
                    ),
                    const SizedBox(width: 8),
                    _ActionButton(
                      icon: Icons.edit_outlined,
                      onTap: onEdit,
                      tooltip: 'Editar lugar',
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Bottom: visited toggle
                _VisitedButton(
                  isVisited: place.isVisited,
                  onTap: onToggleVisited,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private helpers ────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.black87,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _VisitedButton extends StatelessWidget {
  final bool isVisited;
  final VoidCallback onTap;

  const _VisitedButton({required this.isVisited, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isVisited ? 'Marcar como no visitado' : 'Marcar como visitado',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isVisited ? Colors.green[600] : Colors.black87,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isVisited ? Icons.check_rounded : Icons.check_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}
