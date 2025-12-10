import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/user_entity.dart';

part 'login_states.freezed.dart';

@Freezed()
class LoginStates<T> with _$LoginStates<T> {
  const factory LoginStates.initial() = Initial;
  const factory LoginStates.loading() = Loading;
  const factory LoginStates.success(UserEntity user) = Success<T>;
  const factory LoginStates.error({required String message}) = Error;
}
