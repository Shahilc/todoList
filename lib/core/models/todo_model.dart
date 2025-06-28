class Todo {
  int? id;
  String? firebaseId;
  String name;
  String description;
  String startDate;
  String endDate;
  String priority;
  bool isSynced;

  Todo({
    this.id,
    this.firebaseId,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.priority,
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firebaseId': firebaseId,
      'name': name,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'priority': priority,
      'is_synced': isSynced ? 1 : 0,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      firebaseId: map['firebaseId'],
      name: map['name'],
      description: map['description'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      priority: map['priority'],
      isSynced: map['is_synced'] == 1,
    );
  }
}
