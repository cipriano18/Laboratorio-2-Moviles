import 'package:flutter/material.dart';
import '../models/place.dart';

/// Pantalla de formulario para agregar un lugar nuevo o editar uno existente.
/// Si [lugarExistente] es null → modo agregar.
/// Si [lugarExistente] tiene valor → modo editar.
class AddEditScreen extends StatefulWidget {
  final Place? lugarExistente;

  const AddEditScreen({super.key, this.lugarExistente});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  // ── Formulario ────────────────────────────────────────────────────────────
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();

  bool _modoEdicion = false;

  @override
  void initState() {
    super.initState();
    _modoEdicion = widget.lugarExistente != null;
    if (_modoEdicion) {
      _nameCtrl.text = widget.lugarExistente!.name;
      _addressCtrl.text = widget.lugarExistente!.address;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    final place = Place(
      id: _modoEdicion
          ? widget.lugarExistente!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      isVisited: _modoEdicion ? widget.lugarExistente!.isVisited : false,
    );

    Navigator.of(context).pop(place);
  }

  // ── UI ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_modoEdicion ? 'Editar lugar' : 'Nuevo lugar'),
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
              _buildCampoName(),
              const SizedBox(height: 20),
              _buildCampoAddress(),
              const SizedBox(height: 32),
              _buildBotonGuardar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCampoName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _LabelCampo(texto: 'Nombre del lugar *'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameCtrl,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            hintText: 'Ej: Volcán Poás, Playa Tamarindo...',
            prefixIcon: Icon(Icons.place_rounded),
            border: OutlineInputBorder(),
          ),
          validator: (valor) {
            if (valor == null || valor.trim().isEmpty) {
              return 'El nombre no puede estar vacío.';
            }
            if (valor.trim().length < 2) {
              return 'El nombre debe tener al menos 2 caracteres.';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCampoAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _LabelCampo(texto: 'Dirección (opcional)'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _addressCtrl,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            hintText: 'Ej: Alajuela, Costa Rica...',
            prefixIcon: Icon(Icons.map_rounded),
            border: OutlineInputBorder(),
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
        icon: Icon(
          _modoEdicion ? Icons.save_rounded : Icons.add_location_alt_rounded,
        ),
        label: Text(_modoEdicion ? 'Guardar cambios' : 'Agregar lugar'),
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
