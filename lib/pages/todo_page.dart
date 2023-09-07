import 'package:flutter/material.dart';
import 'package:todos_app/models/todo.dart';
import 'package:todos_app/repositories/todo_repo.dart';

class TodoPage extends StatefulWidget {
  final TodoRepo todoRepo;
  Todo? todo;
  String action;
  TodoPage(
      {super.key, required this.todoRepo, this.todo, required this.action});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    if (widget.action != 'Add') {
      titleController.text = widget.todo!.title;
      descController.text = widget.todo!.desc;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.action == 'Add'
            ? 'Add Todo'
            : widget.action == 'Edit'
                ? 'Edit Todo'
                : 'Todo Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              myTextField(
                  controller: titleController,
                  hintText: 'Todo Title',
                  isEnabled: widget.action != 'View'),
              myTextField(
                  controller: descController,
                  hintText: 'Todo Description',
                  isEnabled: widget.action != 'View',
                  maxLines: 3,
                  maxLength: 200),
              const SizedBox(height: 20),
              widget.action == 'View'
                  ? const SizedBox()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(45),
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        //
                        String title = titleController.text;
                        String desc = descController.text;
                        if (title.isNotEmpty && desc.isNotEmpty) {
                          if (widget.action == 'Add') {
                            // Add todo to repo
                            widget.todoRepo.addTodo(Todo(
                                title: title, desc: desc, isCompleted: false));
                            // go back.POP to Home Page
                            Navigator.pop(context, title);
                          } else {
                            // Update todo to repo
                            Todo todoToBeUpdated = Todo(
                                title: title,
                                desc: desc,
                                isCompleted: widget.todo!.isCompleted);
                            todoToBeUpdated.id = widget.todo!.id;
                            widget.todoRepo.updateTodo(todoToBeUpdated);
                            // go back.POP to Home Page
                            Navigator.pop(context, title);
                          }
                        }
                        //
                      },
                      child: Text(
                        widget.action == 'Add' ? 'Add' : 'Update',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myTextField(
      {required TextEditingController controller,
      required String hintText,
      bool isEnabled = false,
      maxLines = 1,
      maxLength = 50}) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(5),
      child: TextField(
        enabled: isEnabled,
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          counterText: '',
        ),
        maxLines: maxLines,
        maxLength: maxLength,
      ),
    );
  }
}
