class Absence {
  final String Date;
  final String Reason;
  final String Duration;
  final String Hours;
  final List<String> Teachers;
  final String Subject;
  final String Course;

  Absence({
    required this.Date,
    required this.Reason,
    required this.Duration,
    required this.Hours,
    required this.Teachers,
    required this.Subject,
    required this.Course,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      Date: json['Date'],
      Reason: json['Reason'],
      Duration: json['Duration'],
      Hours: json['Hours'],
      Teachers: List<String>.from(json['teachers']),
      Subject: json['Subject'],
      Course: json['Course'],
    );
  }
}