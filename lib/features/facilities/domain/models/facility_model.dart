class FacilityModel {
  final String id;
  final String name;
  final int capacity;
  final String description;
  final String type;

  FacilityModel({
    required this.id,
    required this.name,
    required this.capacity,
    required this.description,
    required this.type,
  });

  factory FacilityModel.fromJson(Map<String, dynamic> json) {
    return FacilityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      capacity: json['capacity'] as int,
      description: json['description'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'capacity': capacity,
      'description': description,
      'type': type,
    };
  }
}
