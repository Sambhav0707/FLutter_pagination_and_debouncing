class PlayerModel {
  final int id;
  final String name;
  final String role;

  PlayerModel({required this.id, required this.name, required this.role});

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'] as int,
      name: json['name'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'role': role};
  }

  @override
  String toString() {
    return 'PlayerModel(id: $id, name: $name, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlayerModel &&
        other.id == id &&
        other.name == name &&
        other.role == role;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ role.hashCode;
  }
}

class ErrorModel {
  final String error;
  final String suggestion;

  ErrorModel({required this.error, required this.suggestion});

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      error: json['error'] as String,
      suggestion: json['suggestion'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'error': error, 'suggestion': suggestion};
  }

  @override
  String toString() {
    return 'ErrorModel(error: $error, suggestion: $suggestion)';
  }
}

class ErrorMessageModel {
  final String error;

  ErrorMessageModel({required this.error});

  factory ErrorMessageModel.fromJson(Map<String, dynamic> json) {
    return ErrorMessageModel(error: json['error'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'error': error};
  }

  @override
  String toString() {
    return 'ErrorMessageModel(message: $error)';
  }
}
