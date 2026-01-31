// Classe che rappresenta una Task
class Task{
  Task({required this.description, this.isCompleted = false});
  String description;
  bool isCompleted;

  void complete(){
    isCompleted = true;
  }

  Map<String, dynamic> toMap() => {
    "description": description,
    "isComplete": isCompleted,
  };

  factory Task.fromMap(Map<dynamic, dynamic> map) => Task(
    description: map["description"],
    isCompleted: map["isComplete"]
  );
}