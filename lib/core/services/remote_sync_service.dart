import '../models/todo_model.dart';

class RemoteSyncService {
  Future<void> syncTodos(List<Todo> todos) async {
    await Future.delayed(const Duration(seconds: 2));
    print('Synced to Firebase: ${todos.length} items');
  }
}
