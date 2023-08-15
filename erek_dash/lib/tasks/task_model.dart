class TaskListBody {
  List<Task> taskList = [];
  TaskListBody({required this.taskList});

  TaskListBody.fromJson(List<dynamic> json) {
    taskList = <Task>[];
    for (var item in json) {
      taskList.add(Task.fromjson(item));
    }
  }
}

class Task {
  int? id;
  String? txt;
  int? active;
  int? doneit;
  double? timeValue;
  int? importancy;
  String? startingTime;
  String? pinnedTime;
  int? label;
  String? labelname;

  int? spendingTime;
  int? remaininghours;

  Task({this.id, this.txt, this.active, this.doneit});
  Task.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    txt = json['task'];
    active = json['active'];
    doneit = json['done_id'];
    importancy = json['importancy'];
    startingTime = json['starting_time'];
    pinnedTime = json['pinned_time'];
    spendingTime = json['spending_time'];
    label = json['label'];
    labelname = json['labelname'];
  }
}
