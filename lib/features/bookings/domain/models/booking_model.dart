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

  factory BookingModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BookingModel(
      id: json['id'],
      facilityId: json['facilityId'],
      facilityName: json['facilityName'],
      date: json['date'],
      timeSlot: json['timeSlot'],
      purpose: json['purpose'],
      status: json['status'],
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
}
