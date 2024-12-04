import 'package:flutter/material.dart';
import 'package:mvvmflutter/model/task.dart';
import 'package:mvvmflutter/task/repository.dart';
import 'package:mvvmflutter/viewmodel/viewmodel.dart';
import 'package:mvvmflutter/mvvm/observer.dart';
import 'package:mvvmflutter/mvvm/eventviewmodel.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({super.key});

  @override
  State<StatefulWidget> createState(){
    return _TaskWidgetState();
  }
}

class _TaskWidgetState extends State<TaskWidget> implements EventObserver {
  final TaskViewModel _viewModel = TaskViewModel(TaskRepository());
  bool _isLoading = false;
  List<Task> _tasks = [];

   @override
  void initState() {
    super.initState();
    _viewModel.subscribe(this);
  }

  @override
  void deactivate() {
    super.deactivate();
    _viewModel.unsubscribe(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MVVM TaskApp"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _viewModel.loadTasks();
        },
        child: const Icon(Icons.refresh),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_tasks[index].title),
                  subtitle: Text(_tasks[index].description),
                );
              },
            )
    );
  }

  @override
  void notify(ViewEvent event) {
    if (event is LoadingEvent) {
      setState(() {
        _isLoading = event.isLoading;
      });
    } else if (event is TasksLoadedEvent) {
      setState(() {
        _tasks = event.tasks;
      });
    }
  }
}