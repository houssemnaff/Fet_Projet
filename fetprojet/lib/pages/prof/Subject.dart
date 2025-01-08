class Subject {
  final String? id;
  final String subjectName;
  final String duration;
  final String? type;

  Subject({
    this.id,
    required this.subjectName,
    required this.duration,
    this.type,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] as String?,
      subjectName: json['subjectName'] as String,
      duration: json['duration'] as String,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subjectName': subjectName,
      'duration': duration,
      'type': type,
    };
  }

  @override
  String toString() {
    return 'Subject(id: $id, subjectName: $subjectName, duration: $duration, type: $type)';
  }
}