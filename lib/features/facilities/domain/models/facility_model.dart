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

  // Convert API response → FacilityModel
  factory FacilityModel.fromJson(Map<String, dynamic> json) {
    return FacilityModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: json['name'] as String? ?? '',
      capacity: (json['capacity'] is int)
          ? json['capacity'] as int
          : int.tryParse(json['capacity'].toString()) ?? 0,
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? '',
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

  // Convert SQLite row → FacilityModel
  factory FacilityModel.fromMap(Map<String, dynamic> map) {
    return FacilityModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      capacity: map['capacity'] ?? 0,
      description: map['description'] ?? '',
      type: map['type'] ?? '',
    );
  }

  @override
  String toString() {
    return 'FacilityModel(id: $id, name: $name, capacity: $capacity, type: $type)';
  }
}