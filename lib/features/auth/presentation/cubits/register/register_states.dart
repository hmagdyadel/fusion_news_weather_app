import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/user_entity.dart';

part 'register_states.freezed.dart';

@Freezed()
class RegisterStates<T> with _$RegisterStates<T> {
  const factory RegisterStates.initial() = Initial;
  const factory RegisterStates.loading() = Loading;
  const factory RegisterStates.success(UserEntity user) = Success<T>;
  const factory RegisterStates.error({required String message}) = Error;
}
