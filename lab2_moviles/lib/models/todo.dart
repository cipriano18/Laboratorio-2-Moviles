class Todo {
  final String id;
  final String title;
  final String description;
  final DateTime? dueDate;
  final bool isDone;

  const Todo({
    required this.id,
    required this.title,
    required this.description,
    this.dueDate,
    this.isDone = false,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isDone,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isDone: isDone ?? this.isDone,
    );
  }
}
