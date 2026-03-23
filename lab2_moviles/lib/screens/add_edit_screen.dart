import 'package:flutter/material.dart';
import '../models/todo.dart';

/// Pantalla de formulario para agregar una tarea nueva o editar una existente.
/// Si [tareaExistente] es null → modo agregar.
/// Si [tareaExistente] tiene valor → modo editar.
class AddEditScreen extends StatefulWidget {
  final Todo? tareaExistente;

  const AddEditScreen({super.key, this.tareaExistente});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();

  DateTime? _dueDate;
  bool _modoEdicion = false;

  @override
  void initState() {
    super.initState();
    _modoEdicion = widget.tareaExistente != null;
    if (_modoEdicion) {
      _titleCtrl.text = widget.tareaExistente!.title;
      _descriptionCtrl.text = widget.tareaExistente!.description;
      _dueDate = widget.tareaExistente!.dueDate;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  // ── Guardar ───────────────────────────────────────────────────────────────
  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    final todo = Todo(
      id: _modoEdicion
          ? widget.tareaExistente!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      description: _descriptionCtrl.text.trim(),
      dueDate: _dueDate,
      isDone: _modoEdicion ? widget.tareaExistente!.isDone : false,
    );

    Navigator.of(context).pop(todo);
  }

  // ── Selector de fecha ─────────────────────────────────────────────────────
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';

  // ── UI ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_modoEdicion ? 'Editar tarea' : 'Nueva tarea'),
        actions: [
          TextButton.icon(
            onPressed: _guardar,
            icon: const Icon(Icons.check_rounded),
            label: const Text('Guardar'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCampoTitle(),
              const SizedBox(height: 20),
              _buildCampoDescription(),
              const SizedBox(height: 20),
              _buildCampoFecha(),
              const SizedBox(height: 32),
              _buildBotonGuardar(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Campos ────────────────────────────────────────────────────────────────

  Widget _buildCampoTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _LabelCampo(texto: 'Título *'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _titleCtrl,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            hintText: 'Ej: Comprar víveres, Estudiar Flutter...',
            prefixIcon: Icon(Icons.title_rounded),
            border: OutlineInputBorder(),
          ),
          validator: (valor) {
            if (valor == null || valor.trim().isEmpty) {
              return 'El título no puede estar vacío.';
            }
            if (valor.trim().length < 2) {
              return 'El título debe tener al menos 2 caracteres.';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCampoDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _LabelCampo(texto: 'Descripción (opcional)'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionCtrl,
          textCapitalization: TextCapitalization.sentences,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Agrega más detalles sobre la tarea...',
            prefixIcon: Icon(Icons.notes_rounded),
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }

  Widget _buildCampoFecha() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _LabelCampo(texto: 'Fecha límite (opcional)'),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickDate,
          borderRadius: BorderRadius.circular(8),
          child: InputDecorator(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.calendar_today_outlined),
              border: OutlineInputBorder(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _dueDate != null
                      ? _formatDate(_dueDate!)
                      : 'Seleccionar fecha',
                  style: TextStyle(
                    color: _dueDate != null ? Colors.black87 : Colors.grey[500],
                  ),
                ),
                if (_dueDate != null)
                  GestureDetector(
                    onTap: () => setState(() => _dueDate = null),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBotonGuardar() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: _guardar,
        icon: Icon(_modoEdicion ? Icons.save_rounded : Icons.add_task_rounded),
        label: Text(_modoEdicion ? 'Guardar cambios' : 'Agregar tarea'),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

// ── Widget interno: etiqueta de campo ─────────────────────────────────────────
class _LabelCampo extends StatelessWidget {
  final String texto;

  const _LabelCampo({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
