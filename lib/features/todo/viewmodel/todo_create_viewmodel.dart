import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/models/todo_model.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/services/local_storage_service.dart';

class TodoCreateProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final descriptionFocusNode = FocusNode();
  bool loading=false;

  DateTime? startDate;
  DateTime? endDate;
  String? selectedPriority;

  void loadExistingTodo(Todo todo) {
    nameController.text = todo.name;
    descriptionController.text = todo.description;
    startDate = DateTime.tryParse(todo.startDate);
    endDate = DateTime.tryParse(todo.endDate);
    selectedPriority = todo.priority;

    notifyListeners();
  }

  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    startDate = null;
    endDate = null;
    selectedPriority = null;
    notifyListeners();
  }

  Future<void> pickStartDate(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      startDate = picked;
      notifyListeners();
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      endDate = picked;
      notifyListeners();
    }
  }

  Future<void> submit(BuildContext context, Todo? existingTodo) async {
    loading = true;
    notifyListeners();

    try {
      if (formKey.currentState?.validate() != true) return;

      if (startDate == null ||
          endDate == null ||
          selectedPriority == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all fields!")),
        );
        return;
      }

      if (endDate!.isBefore(startDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("End date cannot be before start date.")),
        );
        return;
      }

      final connectivityService = ConnectivityService();
      final hasInternet = await connectivityService.checkConnection();
      print("hasInternet: $hasInternet");

      final formattedStartDate = startDate!.toIso8601String();
      final formattedEndDate = endDate!.toIso8601String();

      final dbHelper = DatabaseHelper.instance;
      final firebaseService = FirebaseService();

      if (existingTodo != null) {
        // UPDATE
        existingTodo.name = nameController.text.trim();
        existingTodo.description = descriptionController.text.trim();
        existingTodo.startDate = formattedStartDate;
        existingTodo.endDate = formattedEndDate;
        existingTodo.priority = selectedPriority!;
        existingTodo.isSynced = hasInternet;

        await dbHelper.updateTodo(existingTodo);

        if (hasInternet) {
          try {
            if (existingTodo.firebaseId != null) {
              await firebaseService.updateTodo(
                  existingTodo.firebaseId!, existingTodo);
            } else {
              final newFirebaseId =
              await firebaseService.addTodo(existingTodo);
              existingTodo.firebaseId = newFirebaseId;
              await dbHelper.updateTodo(existingTodo);
            }
          } catch (e) {
            print("Firebase update failed: $e");
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Todo updated successfully!")),
        );
      } else {
        // INSERT
        final newTodo = Todo(
          name: nameController.text.trim(),
          description: descriptionController.text.trim(),
          startDate: formattedStartDate,
          endDate: formattedEndDate,
          priority: selectedPriority!,
          isSynced: hasInternet,
        );

        String? firebaseId;

        if (hasInternet) {
          try {
            firebaseId = await firebaseService.addTodo(newTodo);
          } catch (e) {
            print("Firebase add failed: $e");
          }
        }

        final todoToSave = newTodo.copyWith(firebaseId: firebaseId);
        await dbHelper.insertTodo(todoToSave);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Todo saved successfully!")),
        );
      }

      Navigator.pop(context);
    } finally {
      loading = false;
      notifyListeners();
    }
  }


}

extension TodoCopyWith on Todo {
  Todo copyWith({
    int? id,
    String? firebaseId,
    String? name,
    String? description,
    String? startDate,
    String? endDate,
    String? priority,
    bool? isSynced,
  }) {
    return Todo(
      id: id ?? this.id,
      firebaseId: firebaseId ?? this.firebaseId,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      priority: priority ?? this.priority,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
