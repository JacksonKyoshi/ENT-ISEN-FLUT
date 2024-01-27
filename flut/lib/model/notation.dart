// models/notation.dart
class Notation {
  final String date;
  final String code;
  final String note;
  final String comments;
  final List<String> teachers;

  Notation({
    required this.date,
    required this.code,
    required this.note,
    required this.comments,
    required this.teachers,
  });

  factory Notation.fromJson(Map<String, dynamic> json) {
    return Notation(
      date: json['date'],
      code: json['code'],
      note: json['note'],
      comments: json['comments'],
      teachers: List<String>.from(json['teachers']),
    );
  }
}
