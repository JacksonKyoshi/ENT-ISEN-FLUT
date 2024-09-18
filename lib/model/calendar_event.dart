class CalendarEvent {
  final String id;
  final String title;
  final DateTime start;
  final DateTime end;
  final bool allDay;
  final bool editable;
  final String className;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    required this.allDay,
    required this.editable,
    required this.className,
  });

  factory CalendarEvent.fromJSON(Map<String, dynamic> json) {
    return CalendarEvent(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        start: DateTime.parse(json['start']).toLocal(),
        end: DateTime.parse(json['end']).toLocal(),
        allDay: json['allDay'] as bool? ?? false,
        editable: json['editable'] as bool? ?? false,
        className: json['className'] as String? ?? ''
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'title': title,
      'start': start.toString(),
      'end': end.toString(),
      'allDay': allDay,
      'editable': editable,
      'className': className
    };
  }
}