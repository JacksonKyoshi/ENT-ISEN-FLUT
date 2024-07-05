// models/notation.dart
class Notation {
  final String date;
  final String code;
  late final String note;
  final String name;
  final List<String> teachers;


  Notation({
    required this.date,
    required this.code,
    required this.note,
    required this.name,
    required this.teachers,
  });

  factory Notation.fromJson(Map<String, dynamic> json) {
    return Notation(
      date: json['date'],
      code: json['code'],
      name: json['name'],
      note: json['note'],
      teachers: List<String>.from(json['teachers']),
    );
  }
}
