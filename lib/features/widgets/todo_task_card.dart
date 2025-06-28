import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/custome_text.dart';
import '../../core/models/todo_model.dart';
import '../todo/view/create_todo.dart';
import '../todo/viewmodel/todo_viewmodel.dart';

class TodoTaskCard extends StatelessWidget {
  final Todo todo;
  const TodoTaskCard({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {

    final vm = Provider.of<HomeProvider>(context);
    final formattedStart = DateFormat('yyyy-MM-dd').format(
      DateTime.parse(todo.startDate),
    );
    final formattedEnd = DateFormat('yyyy-MM-dd').format(
      DateTime.parse(todo.endDate),
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Slidable(
        key: ValueKey(todo.id),
        endActionPane: ActionPane(
          extentRatio: 0.5,
          motion: const ScrollMotion(),
          children: [
            SizedBox(width: 5,),
            SlidableAction(
              onPressed: (_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateTodo(
                      existingTodo: todo,
                    ),
                  ),
                ).then((_) {
                  Provider.of<HomeProvider>(context, listen: false)
                      .loadTodos();
                });
              },
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: BorderRadius.circular(20),
            ),
            SizedBox(width: 5,),
            SlidableAction(
              onPressed: (_) async {
                await Provider.of<HomeProvider>(context, listen: false).deleteTodo(todo);
                // await vm.deleteTodo(todo.id!);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Todo deleted.")),
                );
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(20),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(todo),
                const SizedBox(height: 8),
                 CustomTextWidget(
                  name: todo.description,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                 CustomTextWidget(
                  name: 'Created By : ${todo.name}',
                  color: Colors.white,
                  fontSize: 10,
                ),
                const Divider(),
                _buildFooter(formattedStart,formattedEnd,todo.priority),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Todo todo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(20),
          ),
          child:  Padding(
            padding: EdgeInsets.all(8.0),
            child: CustomTextWidget(
              name: 'Sync: ${todo.isSynced}',
              color: Colors.white,
              fontSize: 8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_forward, size: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(String formattedStart, String formattedEnd, String priority) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildFooterItem('Start Date', formattedStart),
        _divider(),
        _buildFooterItem('End Date', formattedEnd),
        _divider(),
        _buildFooterItem('Priority', priority),
      ],
    );
  }

  Widget _buildFooterItem(String title, String value) {
    return Column(
      children: [
        CustomTextWidget(
          name: title,
          color: Colors.white,
          fontSize: 9,
        ),
        CustomTextWidget(
          name: value,
          color: Colors.white,
          fontSize: 8,
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 20,
      color: Colors.white,
    );
  }
}
