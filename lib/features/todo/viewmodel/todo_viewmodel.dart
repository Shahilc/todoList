import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/features/todo/viewmodel/todo_create_viewmodel.dart';

import '../../../core/models/todo_model.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../core/services/firebase_service.dart';

class HomeProvider extends ChangeNotifier {
  List<DateTime> daysOfMonth = [];
  int selectedDayIndex = 3;
  bool isActive = false;
  bool loading = false;
  List<Todo> todos = [];
  final ConnectivityService connectivityService = ConnectivityService();
  final FirebaseService firebaseService = FirebaseService();

  final dbHelper = DatabaseHelper.instance;

  final List<String> daysOfWeek = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];

  void setTodayAsSelected() {
    DateTime today = DateTime.now();
    for (int i = 0; i < daysOfMonth.length; i++) {
      if (DateFormat('yyyy-MM-dd').format(daysOfMonth[i]) ==
          DateFormat('yyyy-MM-dd').format(today)) {
        selectedDayIndex = i;
        break;
      }
    }

  }

  void generateDates() {
    DateTime today = DateTime.now();
    daysOfMonth = [];
    for (int i = -1; i <= 5; i++) {
      daysOfMonth.add(today.add(Duration(days: i)));
    }

  }

  Future<void> dateShowing() async {
    generateDates();
    setTodayAsSelected();
    await loadTodos();
  }

  Future<void> loadTodos() async {
    todos = await dbHelper.getTodos();
    notifyListeners();
  }

  Future<void> deleteTodo(Todo todo) async {
    await dbHelper.deleteTodo(todo.id!);
    if (todo.firebaseId != null) {
      final firebaseService = FirebaseService();
      await firebaseService.deleteTodo(todo.firebaseId!);
    }

    await loadTodos();
  }

  void startConnectivityListener(BuildContext context) {
    connectivityService.connectivityStream.listen((hasInternet) {
      if (hasInternet) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Syncing unsynced todos...")),
        );

        syncUnsyncedTodos(context);
      }
    });
  }

  Future<void> syncUnsyncedTodos(BuildContext context) async {
    final unsyncedTodos = todos.where((todo) => !todo.isSynced).toList();

    if (unsyncedTodos.isEmpty) return;

    for (final todo in unsyncedTodos) {
      try {
        String? firebaseId;

        if (todo.firebaseId != null) {
          await firebaseService.updateTodo(todo.firebaseId!, todo);
        } else {
          firebaseId = await firebaseService.addTodo(todo);
        }

        final syncedTodo = todo.copyWith(
          firebaseId: firebaseId,
          isSynced: true,
        );
        await dbHelper.updateTodo(syncedTodo);

      } catch (e) {
        print("❌ Sync error: $e");
      }
    }

    await loadTodos();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Sync completed!")),
    );
  }


}
