import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo_model.dart';

class FirebaseService {
  final _firestore = FirebaseFirestore.instance;
  final String collectionName = "todos";

  Future<String> addTodo(Todo todo) async {
    final docRef = await _firestore.collection(collectionName).add({
      "name": todo.name,
      "description": todo.description,
      "startDate": todo.startDate,
      "endDate": todo.endDate,
      "priority": todo.priority,
    });
    return docRef.id;
  }

  Future<void> updateTodo(String firebaseId, Todo todo) async {
    await _firestore
        .collection(collectionName)
        .doc(firebaseId)
        .update({
      "name": todo.name,
      "description": todo.description,
      "startDate": todo.startDate,
      "endDate": todo.endDate,
      "priority": todo.priority,
    });
  }

  Future<void> deleteTodo(String firebaseId) async {
    await FirebaseFirestore.instance
        .collection('todos')
        .doc(firebaseId)
        .delete();
  }

}
