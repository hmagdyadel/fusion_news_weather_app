import '../../domain/entities/user_entity.dart';

class UserModel {
  final int? id;
  final String email;
  final String hashedPassword;
  final String name;
  final String createdAt;

  UserModel({
    this.id,
    required this.email,
    required this.hashedPassword,
    required this.name,
    required this.createdAt,
  });

  // Convert from database map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      email: map['email'] as String,
      hashedPassword: map['hashed_password'] as String,
      name: map['name'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  // Convert to database map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'email': email,
      'hashed_password': hashedPassword,
      'name': name,
      'created_at': createdAt,
    };
  }

  // Convert to entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      createdAt: DateTime.parse(createdAt),
    );
  }

  // Create from entity
  factory UserModel.fromEntity(UserEntity entity, String hashedPassword) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      hashedPassword: hashedPassword,
      name: entity.name,
      createdAt: entity.createdAt.toIso8601String(),
    );
  }
}
