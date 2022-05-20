class EventEntity {
  // title
  String todoName;
  // description
  String description;

  String startTime;
  String endTime;
  int eventStatus;
  String color;

  EventEntity(
      {required this.description,
      required this.endTime,
      required this.eventStatus,
      required this.startTime,
      required this.todoName,
      required this.color});
}
