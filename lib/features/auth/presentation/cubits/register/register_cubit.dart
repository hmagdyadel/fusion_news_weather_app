import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/helpers/logging_service.dart';
import '../../../domain/usecases/register_usecase.dart';
import 'register_states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  final RegisterUsecase registerUsecase;

  RegisterCubit({required this.registerUsecase})
      : super(const RegisterStates.initial());

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(const RegisterStates.loading());

    LoggingServicePrinter.log('🔄 Cubit: Attempting registration for $email');

    final result = await registerUsecase(
      RegisterParams(email: email, password: password, name: name),
    );

    result.fold(
      (failure) {
        LoggingServicePrinter.log('❌ Cubit: Registration failed - ${failure.message}');
        emit(RegisterStates.error(message: failure.message));
      },
      (user) {
        LoggingServicePrinter.log('✅ Cubit: Registration successful - ${user.email}');
        emit(RegisterStates.success(user));
      },
    );
  }

  void resetState() {
    emit(const RegisterStates.initial());
  }
}
