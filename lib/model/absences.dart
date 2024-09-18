class Absence {
  final String date;
  final String reason;
  final String duration;
  final String hours;
  final String course;
  final List<String> teachers;
  final String subject;

  Absence({
    required this.date,
    required this.reason,
    required this.duration,
    required this.hours,
    required this.course,
    required this.teachers,
    required this.subject,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      date: json['date'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      hours: json['hours'] as String? ?? '',
      course: json['course'] as String? ?? '',
      teachers: List<String>.from(json['teachers'] as List<dynamic>? ?? []),
      subject: json['subject'] as String? ?? '',
    );
  }


}