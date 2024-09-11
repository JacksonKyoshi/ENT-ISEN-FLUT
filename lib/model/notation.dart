// models/notation.dart
class Notation {
  final String date;
  final String code;
  late final String note;
  final String name;
  final String absenceReason;
  final String comments;
  final List<String> teachers;


  Notation({
    required this.date,
    required this.code,
    required this.note,
    required this.name,
    required this.absenceReason,
    required this.comments,
    required this.teachers,
  });

  factory Notation.fromJson(Map<String, dynamic> json) {
    return Notation(
      date: json['date'] as String? ?? "",
      code: json['code'] as String? ?? "",
      name: json['name'] as String? ?? "",
      note: json['note'] as String? ?? "",
      absenceReason: json['absenceReason'] as String? ?? "",
      comments: json['comments'] as String? ?? "",
      teachers: List<String>.from(json['teachers'] as List<dynamic>? ?? []),
    );
  }
}
