import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todos_app/models/todo.dart';
import 'package:todos_app/pages/todo_page.dart';
import 'package:todos_app/repositories/todo_repo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //
  TextEditingController searchController = TextEditingController();
  TodoRepo todoRepo = TodoRepo();
  List<Todo> todos = List.empty(growable: true);
  //

  @override
  void initState() {
    todos = todoRepo.getTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              getSearchWidget(),
              const Text(
                'All Todos',
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: todos.isEmpty
                    ? const Center(
                        child: Text(
                          'No Todo yet\nClick + to Start Adding',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: todos.length,
                        itemBuilder: (context, index) => InkWell(
                          onDoubleTap: () {
                            //
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TodoPage(
                                    todoRepo: todoRepo,
                                    action: 'Edit',
                                    todo: todos[index],
                                  ),
                                )).then((value) {
                              // Come back from Update
                              todos = todoRepo.getTodos();
                              setState(() {});
                              if (value != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text("'$value' updated successfully"),
                                    backgroundColor: Colors.orange[900],
                                  ),
                                );
                              }
                            });
                            //
                          },
                          child: getMyTile(
                            todos[index],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TodoPage(
                todoRepo: todoRepo,
                action: 'Add',
              ),
            ),
          ).then((value) {
            // When come back from Add Screen
            todos = todoRepo.getTodos();
            setState(() {});
            // show the snackbar
            if (value != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("'$value' added successfully"),
                  backgroundColor: Colors.purple,
                ),
              );
            }
          });
          //
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget getSearchWidget() {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        //
        onChanged: (value) {
          todos = todoRepo.searchTodo(value);
          setState(() {});
        },
        controller: searchController,
        maxLength: 30,
        decoration: const InputDecoration(
          counterText: '',
          prefixIcon: Icon(Icons.search),
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  getMyTile(Todo todo) {
    return Card(
      surfaceTintColor: todo.isCompleted ? Colors.red : Colors.white,
      child: ListTile(
        leading: IconButton(
          onPressed: () {
            //
            todoRepo.markTodoCompleted(todo);
            todos = todoRepo.getTodos();
            setState(() {});
            //
          },
          icon: Icon(
            todo.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
            color: todo.isCompleted ? Colors.purple : Colors.grey,
          ),
        ),
        title: Text(
          todo.title.length > 14
              ? "${todo.title.substring(0, 12)}.."
              : todo.title,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontStyle: todo.isCompleted ? FontStyle.italic : FontStyle.normal,
              decoration: todo.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
        subtitle: Text(
          todo.desc.length > 20 ? "${todo.desc.substring(0, 20)}.." : todo.desc,
          style: TextStyle(
              fontSize: 16,
              fontStyle: todo.isCompleted ? FontStyle.italic : FontStyle.normal,
              decoration: todo.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
        trailing: Wrap(
          children: [
            IconButton(
              onPressed: () {
                //
                todoRepo.delete(todo);
                setState(() {
                  todos = todoRepo.getTodos();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("'${todo.title}' deleted successfully"),
                    backgroundColor: Colors.red[900],
                  ),
                );
                //
              },
              icon: const Icon(
                Icons.delete,
                color: Color.fromARGB(255, 243, 154, 147),
              ),
            ),
            IconButton(
              onPressed: () {
                //
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodoPage(
                        todoRepo: todoRepo,
                        todo: todo,
                        action: 'View',
                      ),
                    ));
                //
              },
              icon: const Icon(
                Icons.remove_red_eye,
                color: Color.fromARGB(255, 214, 112, 232),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
