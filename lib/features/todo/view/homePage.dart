import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../shared/styles/app_colors.dart';
import '../../../shared/widgets/custome_text.dart';
import '../../widgets/buildDaySelector.dart';
import '../../widgets/buildGreetingSection.dart';
import '../../widgets/buildTaskSectionTitle.dart';
import '../../widgets/buildTodayLabel.dart';
import '../../widgets/buildUserimage.dart';
import '../../widgets/todo_task_card.dart';
import '../viewmodel/todo_viewmodel.dart';
import 'create_todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override

  void initState() {
    super.initState();
    final provider = Provider.of<HomeProvider>(context, listen: false);
    provider.dateShowing();
    provider.startConnectivityListener(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HomeProvider>(
        builder: (context, vm, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await Provider.of<HomeProvider>(context, listen: false).loadTodos();
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  surfaceTintColor: AppColors.customAppbarColor,
                  leading: const SizedBox(),
                  backgroundColor: AppColors.customAppbarColor,
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlexibleSpaceBar(
                      titlePadding: const EdgeInsets.only(left: 15),
                      background: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Builduserimage(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BuildGreetingSection(),
                      BuildTodayLabel(),
                      Builddayselector(vm:vm),
                      BuildTaskSectionTitle(),
                    ],
                  ),
                ),
                if (vm.todos.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        "No todos found.",
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final todo = vm.todos[index];
                        return TodoTaskCard(todo: todo,);
                      },
                      childCount: vm.todos.length,
                    ),
                  ),
                SliverToBoxAdapter(child: SafeArea(child: SizedBox())),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateTodo(),
            ),
          ).then((_) {
            Provider.of<HomeProvider>(context, listen: false).loadTodos();
          });
        },
      ),
    );
  }

}

