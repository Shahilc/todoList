import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/shared/styles/app_colors.dart';
import '../../../core/models/todo_model.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../widgets/buildDaySelector.dart';
import '../viewmodel/todo_create_viewmodel.dart';
import '../viewmodel/todo_viewmodel.dart';

class CreateTodo extends StatefulWidget {
  final Todo? existingTodo;

  const CreateTodo({super.key, this.existingTodo});

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<TodoCreateProvider>(context, listen: false);

      if (widget.existingTodo != null) {
        vm.loadExistingTodo(widget.existingTodo!);
      } else {
        vm.clearForm();
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeProvider>(context);
    final vm1 = Provider.of<TodoCreateProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.customAppbarColor,
        title: Text(widget.existingTodo != null ? "Edit Todo" : "Create Todo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Builddayselector(vm: vm,),
              SizedBox(height: 10,),
              Expanded(
                child: Form(
                  key: vm1.formKey,
                  child: ListView(
                    children: [
                      CustomTextField(
                        controller: vm1.nameController,
                        label: "Name",
                        validator: (value) =>
                        value == null || value.isEmpty ? "Required" : null,
                      ),

                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: vm1.descriptionController,
                        focusNode: vm1.descriptionFocusNode,
                        label: "Description",
                        maxLines: 3,
                        validator: (value) =>
                        value == null || value.isEmpty ? "Required" : null,
                      ),

                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed:()=> vm1.pickStartDate(context),
                              child: Text(vm1.startDate == null
                                  ? "Select Start Date"
                                  : vm1.startDate!.toString().split(" ").first),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton(
                              onPressed:()=>vm1.pickEndDate(context),
                              child: Text(vm1.endDate == null
                                  ? "Select End Date"
                                  : vm1.endDate!.toString().split(" ").first),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: vm1.selectedPriority,
                        items: ["High", "Medium", "Low"]
                            .map(
                              (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            vm1.selectedPriority = val;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: "Priority",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        validator: (val) =>
                        val == null || val.isEmpty ? "Required" : null,
                      ),
                      const SizedBox(height: 24),
          
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: vm1.loading
                    ? null
                    : () => vm1.submit(context, widget.existingTodo),
                child: vm1.loading
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                )
                    : Text(
                  widget.existingTodo != null ? "Update Todo" : "Create Todo",
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
