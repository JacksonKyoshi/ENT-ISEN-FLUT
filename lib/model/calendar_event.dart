class CalendarEvent {
  final String id;
  final String title;
  final String start;
  final String end;
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
        start: json['start'] as String? ?? '',
        end: json['end'] as String? ?? '',
        allDay: json['allDay'],
        editable: json['editable'],
        className: json['className'] as String? ?? ''
    );
  }
}