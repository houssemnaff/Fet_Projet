class TimeSlot {
  final String day;
  final String startTime;
  final String endTime;

  TimeSlot({
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      day: json['day'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  @override
  String toString() {
    return 'TimeSlot(day: $day, startTime: $startTime, endTime: $endTime)';
  }
}