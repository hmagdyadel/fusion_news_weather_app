import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int? id;
  final String email;
  final String name;
  final DateTime createdAt;

  const UserEntity({
    this.id,
    required this.email,
    required this.name,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, name, createdAt];
}
