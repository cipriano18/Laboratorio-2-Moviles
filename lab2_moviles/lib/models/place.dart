class Place {
  final String id;
  final String name;
  final String address;
  final bool isVisited;

  const Place({
    required this.id,
    required this.name,
    required this.address,
    this.isVisited = false,
  });

  // Método para cambiar solamente lo que se le pasa
  Place copyWith({String? id, String? name, String? address, bool? isVisited}) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      isVisited: isVisited ?? this.isVisited,
    );
  }
}
