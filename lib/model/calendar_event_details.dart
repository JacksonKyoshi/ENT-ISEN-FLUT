class CalendarEventDetails {
  final String id;
  final String start;
  final String end;
  final String status;
  final String subject;
  final String type;
  final String description;
  final bool isPaper;
  final List<String> rooms;
  final List<String> teachers;
  final List<String> students;
  final List<String> groups;
  final String courseName;
  final String module;

  CalendarEventDetails({
    required this.id,
    required this.start,
    required this.end,
    required this.status,
    required this.subject,
    required this.type,
    required this.description,
    required this.isPaper,
    required this.rooms,
    required this.teachers,
    required this.students,
    required this.groups,
    required this.courseName,
    required this.module,
  });

  factory CalendarEventDetails.fromJSON(Map<String, dynamic> json) {
    return CalendarEventDetails(
        id: json['id'] as String? ?? '',
        start: json['start'] as String? ?? '',
        end: json['end'] as String? ?? '',
        status: json['status'] as String? ?? '',
        subject: json['subject'] as String? ?? '',
        type: json['type'] as String? ?? '',
        description: json['description'] as String? ?? '',
        isPaper: json['isPaper'],
        rooms: List<String>.from(json['rooms'] as List<dynamic>? ?? []),
        teachers: List<String>.from(json['teachers'] as List<dynamic>? ?? []),
        students: List<String>.from(json['students'] as List<dynamic>? ?? []),
        groups: List<String>.from(json['groups'] as List<dynamic>? ?? []),
        courseName: json['courseName'] as String? ?? '',
        module: json['module'] as String? ?? ''
    );
  }
}