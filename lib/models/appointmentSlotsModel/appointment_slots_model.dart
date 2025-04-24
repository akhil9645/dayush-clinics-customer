class AppointmentSlot {
  final String date;
  final String day;
  final String timeSlot;

  AppointmentSlot(
      {required this.date, required this.timeSlot, required this.day});

  factory AppointmentSlot.fromJson(Map<String, dynamic> json) {
    return AppointmentSlot(
      date: json['date'],
      day: json['day'],
      timeSlot: json['time_slot'],
    );
  }

  // For comparison
  @override
  bool operator ==(Object other) {
    return other is AppointmentSlot &&
        other.date == date &&
        other.day == day &&
        other.timeSlot == timeSlot;
  }

  @override
  int get hashCode => date.hashCode ^ timeSlot.hashCode;
}
