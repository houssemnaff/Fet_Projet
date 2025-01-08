import 'package:fetprojet/pages/prof/Subject.dart';
import 'package:fetprojet/pages/prof/TimeSlot.dart';

class Teacher {
  final String id;
  final String email;
  final String cin;
  final String teacherName;
  final bool valide;
  final List<Subject> subjectsCanTeach;
  final List<TimeSlot> timeSlots;

  Teacher({
    required this.id,
    required this.email,
    required this.cin,
    required this.teacherName,
    required this.valide,
    required this.subjectsCanTeach,
    required this.timeSlots,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    // Safely parse 'subjectsCanTeach' and 'timeSlots' to handle null or incorrect formats
    List<Subject> subjectsList = [];
    List<TimeSlot> timeSlotsList = [];

    if (json['subjectsCanTeach'] is List) {
      subjectsList = (json['subjectsCanTeach'] as List)
          .map((subject) => Subject.fromJson(subject as Map<String, dynamic>))
          .toList();
    }

    if (json['timeSlots'] is List) {
      timeSlotsList = (json['timeSlots'] as List)
          .map((timeSlot) => TimeSlot.fromJson(timeSlot as Map<String, dynamic>))
          .toList();
    }

    return Teacher(
      id: json['id'] as String? ?? '', // Provide a default value if null
      email: json['email'] as String? ?? '',
      cin: json['cin'] as String? ?? '',
      teacherName: json['teacherName'] as String? ?? '',
      valide: json['valide'] as bool? ?? false, // Default to false if null
      subjectsCanTeach: subjectsList,
      timeSlots: timeSlotsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'cin': cin,
      'teacherName': teacherName,
      'valide': valide,
      'subjectsCanTeach': subjectsCanTeach.map((subject) => subject.toJson()).toList(),
      'timeSlots': timeSlots.map((timeSlot) => timeSlot.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Teacher(id: $id, email: $email, cin: $cin, teacherName: $teacherName, valide: $valide, subjectsCanTeach: $subjectsCanTeach, timeSlots: $timeSlots)';
  }
}
