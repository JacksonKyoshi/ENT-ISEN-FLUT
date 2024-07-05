// models/notation.dart
class NotationClass {
  final String code;
  final String notePersonal;
  final String noteAverage;
  final String noteMin;
  final String noteMax;
  final String name;
  final String presence;



  NotationClass({
    required this.noteAverage,
    required this.code,
    required this.name,
    required this.noteMax,
    required this.noteMin,
    required this.notePersonal,
    required this.presence,
  });

  factory NotationClass.fromJson(Map<String, dynamic> json) {
    return NotationClass(
      code: json['code'],
      name: json['name'],
      noteMax: json['noteMax'],
      noteMin: json['noteMin'],
      notePersonal: json['notePersonal'],
      presence: json['presence'],
      noteAverage: json['noteAverage'],
    );
  }
}
