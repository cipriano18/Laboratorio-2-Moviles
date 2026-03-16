import 'package:flutter/material.dart';
import 'package:lab2_moviles/models/place.dart';
import 'package:lab2_moviles/data/place_list.dart';
import 'package:lab2_moviles/widgets/place_card.dart';
import 'package:lab2_moviles/widgets/search_bar_widget.dart';
import 'package:lab2_moviles/screens/add_edit_screen.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final PlaceList _placeList = PlaceList();
  String _query = '';
  int _nextId = 1;

  @override
  void initState() {
    super.initState();
    _placeList.addPlace(
      const Place(
        id: '1',
        name: 'Monte Verde',
        address: 'Puntarenas, Costa Rica',
      ),
    );
    _placeList.addPlace(
      const Place(
        id: '2',
        name: 'Volcán Arenal',
        address: 'La Fortuna, Alajuela',
        isVisited: true,
      ),
    );
    _placeList.addPlace(
      const Place(
        id: '3',
        name: 'Playa Manuel Antonio',
        address: 'Quepos, Puntarenas',
      ),
    );
    _nextId = 4;
  }

  // ── Filtro ─────────────────────────────────────────────────────────────────
  List<Place> get _filteredPlaces {
    final all = _placeList.getPlaces();
    if (_query.isEmpty) return all;
    final lower = _query.toLowerCase();
    return all
        .where(
          (p) =>
              p.name.toLowerCase().contains(lower) ||
              p.address.toLowerCase().contains(lower),
        )
        .toList();
  }

  // ── Handlers ───────────────────────────────────────────────────────────────
  void _toggleVisited(String id) {
    setState(() => _placeList.toggleVisited(id));
  }

  void _deletePlace(String id) {
    final place = _placeList.places.firstWhere((p) => p.id == id);
    setState(() => _placeList.deletePlaces(place));
  }

  void _onSearchChanged(String value) {
    setState(() => _query = value);
  }

  // ── Navegar a AddEditScreen ────────────────────────────────────────────────
  Future<void> _openFormScreen({Place? existing}) async {
    final result = await Navigator.push<Place>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditScreen(lugarExistente: existing),
      ),
    );

    // Si el usuario canceló, result es null
    if (result == null) return;

    setState(() {
      if (existing == null) {
        // CREATE
        _placeList.addPlace(
          Place(
            id: (_nextId++).toString(),
            name: result.name,
            address: result.address,
          ),
        );
      } else {
        // EDIT
        _placeList.editPlace(
          existing.id,
          name: result.name,
          address: result.address,
        );
      }
    });
  }

  // ── UI ─────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final filtered = _filteredPlaces;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Lugares'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_alt),
            onSelected: (value) {
              setState(() {
                switch (value) {
                  case 'nameAsc':
                    _placeList.sortByName();
                    break;
                  case 'nameDesc':
                    _placeList.sortByNameDesc();
                    break;
                  case 'visited':
                    _placeList.sortByVisited();
                    break;
                  case 'notVisited':
                    _placeList.sortByNotVisited();
                    break;
                }
              });
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'nameAsc', child: Text('Nombre A-Z')),
              PopupMenuItem(value: 'nameDesc', child: Text('Nombre Z-A')),
              PopupMenuItem(value: 'visited', child: Text('Visitados primero')),
              PopupMenuItem(
                value: 'notVisited',
                child: Text('No visitados primero'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          SearchBarWidget(onChanged: _onSearchChanged),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No hay lugares que coincidan'))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final place = filtered[index];
                      return PlaceCard(
                        place: place,
                        onToggleVisited: () => _toggleVisited(place.id),
                        onDelete: () => _deletePlace(place.id),
                        onEdit: () => _openFormScreen(existing: place),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openFormScreen(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
