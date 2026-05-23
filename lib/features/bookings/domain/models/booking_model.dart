class BookingModel {
  final String id;
  final String facilityId;
  final String facilityName;
  final String date;
  final String timeSlot;
  final String purpose;
  final String status;

  BookingModel({
    required this.id,
    required this.facilityId,
    required this.facilityName,
    required this.date,
    required this.timeSlot,
    required this.purpose,
    required this.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      facilityId: (json['facilityId'] ?? '').toString(),
      facilityName: (json['facilityName'] ?? '').toString(),
      date: (json['date'] ?? '').toString(),
      timeSlot: (json['timeSlot'] ?? '').toString(),
      purpose: (json['purpose'] ?? '').toString(),
      status: (json['status'] ?? 'booked').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'facilityId': facilityId,
      'facilityName': facilityName,
      'date': date,
      'timeSlot': timeSlot,
      'purpose': purpose,
      'status': status,
    };
  }

  BookingModel copyWith({
    String? id,
    String? facilityId,
    String? facilityName,
    String? date,
    String? timeSlot,
    String? purpose,
    String? status,
  }) {
    return BookingModel(
      id: id ?? this.id,
      facilityId: facilityId ?? this.facilityId,
      facilityName: facilityName ?? this.facilityName,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      purpose: purpose ?? this.purpose,
      status: status ?? this.status,
    );
  }
}
