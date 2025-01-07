class ProgramDto {
  final String programName;
  final List<ProgramSubjectDto> subjects;

  ProgramDto({required this.programName, required this.subjects});

  factory ProgramDto.fromJson(Map<String, dynamic> json) {
    return ProgramDto(
      programName: json['programName'],
      subjects: (json['subjects'] as List)
          .map((subjectJson) => ProgramSubjectDto.fromJson(subjectJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'programName': programName,
        'subjects': subjects.map((subject) => subject.toJson()).toList(),
      };
}

class ProgramSubjectDto {
  final SubjectDetailsDto subject;
  final int recurrence;

  ProgramSubjectDto({required this.subject, required this.recurrence});

  factory ProgramSubjectDto.fromJson(Map<String, dynamic> json) {
    return ProgramSubjectDto(
      subject: SubjectDetailsDto.fromJson(json['subject']),
      recurrence: json['recurrence'],
    );
  }

  Map<String, dynamic> toJson() => {
        'subject': subject.toJson(),
        'recurrence': recurrence,
      };
}

class SubjectDetailsDto {
  final String subjectName;
  final String duration;

  SubjectDetailsDto({required this.subjectName, required this.duration});

  factory SubjectDetailsDto.fromJson(Map<String, dynamic> json) {
    return SubjectDetailsDto(
      subjectName: json['subjectName'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() => {
        'subjectName': subjectName,
        'duration': duration,
      };
}