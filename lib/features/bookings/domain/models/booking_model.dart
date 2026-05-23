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

  // Convert API response (MongoDB) → BookingModel
  // MongoDB returns _id not id
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      facilityId: (json['facilityId'] ?? '').toString(),
      facilityName: json['facilityName'] ?? '',
      date: json['date'] ?? '',
      timeSlot: json['timeSlot'] ?? '',
      purpose: json['purpose'] ?? '',
      status: json['status'] ?? 'booked',
    );
  }

  // Convert BookingModel → Map to save in SQLite
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

  // Convert SQLite row → BookingModel
  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'] ?? '',
      facilityId: map['facilityId'] ?? '',
      facilityName: map['facilityName'] ?? '',
      date: map['date'] ?? '',
      timeSlot: map['timeSlot'] ?? '',
      purpose: map['purpose'] ?? '',
      status: map['status'] ?? 'booked',
    );
  }

  @override
  String toString() {
    return 'BookingModel(id: $id, facilityName: $facilityName, date: $date, timeSlot: $timeSlot)';
  }
}