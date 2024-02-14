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
      date: json['Date'] as String? ?? '',
      reason: json['Reason'] as String? ?? '',
      duration: json['Duration'] as String? ?? '',
      hours: json['Hours'] as String? ?? '',
      course: json['Course'] as String? ?? '',
      teachers: List<String>.from(json['Teachers'] as List<dynamic>? ?? []),
      subject: json['Subject'] as String? ?? '',
    );
  }


}