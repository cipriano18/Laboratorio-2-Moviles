import '../models/place.dart';

class PlaceList {
  List<Place> places = [];

  // GET
  List<Place> getPlaces() {
    return places;
  }

  // CREATE
  void addPlace(Place place) {
    places.add(place);
  }

  // EDIT
  void editPlace(String id, {String? name, String? address, bool? isVisited}) {
    final index = places.indexWhere((p) => p.id == id);
    if (index != -1) {
      places[index] = places[index].copyWith(
        name: name,
        address: address,
        isVisited: isVisited,
      );
    }
  }

  // CHECK VISIT
  void toggleVisited(String id) {
    final index = places.indexWhere((p) => p.id == id);
    if (index != -1) {
      places[index] = places[index].copyWith(
        isVisited: !places[index].isVisited,
      );
    }
  }

  // DELETE
  void deletePlaces(Place place) {
    places.remove(place);
  }

  // SORT: por nombre A-Z
  void sortByName() {
    places.sort((a, b) => a.name.compareTo(b.name));
  }

  // SORT: por nombre Z-A
  void sortByNameDesc() {
    places.sort((a, b) => b.name.compareTo(a.name));
  }

  // SORT: visitados primero
  void sortByVisited() {
    places.sort((a, b) {
      if (a.isVisited == b.isVisited) return 0;
      return a.isVisited ? -1 : 1;
    });
  }

  // SORT: no visitados primero
  void sortByNotVisited() {
    places.sort((a, b) {
      if (a.isVisited == b.isVisited) return 0;
      return a.isVisited ? 1 : -1;
    });
  }

  // FILTER: solo visitados
  List<Place> getVisited() {
    return places.where((p) => p.isVisited).toList();
  }

  // FILTER: solo no visitados
  List<Place> getNotVisited() {
    return places.where((p) => !p.isVisited).toList();
  }
}
