class BookingModel {
  final String id;
  final String userId; 
  final String facilityId;
  final String facilityName;
  final String date;
  final String timeSlot;
  final String purpose;
  final String status;

  BookingModel({
    required this.id,
    required this.userId,
    required this.facilityId,
    required this.facilityName,
    required this.date,
    required this.timeSlot,
    required this.purpose,
    required this.status,
  });

  // Convert API response (MongoDB) → BookingModel
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      userId: (json['userId'] ?? '').toString(), 
      facilityId: (json['facilityId'] ?? '').toString(),
      facilityName: json['facilityName'] ?? '',
      date: json['date'] ?? '',
      timeSlot: json['timeSlot'] ?? '',
      purpose: json['purpose'] ?? '',
      status: json['status'] ?? 'booked',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId, 
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
      userId: map['userId'] ?? '', 
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
    return 'BookingModel(id: $id, userId: $userId, facilityName: $facilityName, date: $date, timeSlot: $timeSlot)';
  }
}