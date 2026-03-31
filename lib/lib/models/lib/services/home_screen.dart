import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../models/task.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String search = "";
  String filter = "All";

  Color getStatusColor(String status) {
    switch (status) {
      case "Done":
        return Colors.green;
      case "In Progress":
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = DBService.getTasks().where((t) {
      return t.title.toLowerCase().contains(search.toLowerCase()) &&
          (filter == "All" || t.status == filter);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("TaskFlow"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search tasks...",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => search = value);
              },
            ),

            SizedBox(height: 10),

            DropdownButton<String>(
              value: filter,
              isExpanded: true,
              items: ["All", "To-Do", "In Progress", "Done"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                setState(() => filter = val!);
              },
            ),

            SizedBox(height: 10),

            Expanded(
              child: tasks.isEmpty
                  ? Center(child: Text("No tasks found"))
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        Task task = tasks[index];
                        bool isBlocked = task.blockedBy != null;

                        return Card(
                          elevation: 3,
                          color: isBlocked ? Colors.grey[300] : Colors.white,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: getStatusColor(task.status),
                              child: Icon(Icons.task, color: Colors.white),
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(task.status),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  DBService.deleteTask(index);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTaskScreen()),
          );
          setState(() {});
        },
      ),
    );
  }
}
