class TasksModel {
  String message;
  int isDone;
  TasksModel({required this.isDone, required this.message});

  factory TasksModel.fromJson(Map json) {
    return TasksModel(
      isDone: json["done"],
      message: json["task"],
    );
  }
}
