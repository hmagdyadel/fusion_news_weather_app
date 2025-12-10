import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/helpers/logging_service.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/login_usecase.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  final LoginUsecase loginUsecase;

  LoginCubit({required this.loginUsecase}) : super(const LoginStates.initial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const LoginStates.loading());

    LoggingServicePrinter.log('🔄 Cubit: Attempting login for $email');

    final result = await loginUsecase(
      LoginParams(email: email, password: password),
    );

    result.fold(
      (failure) {
        LoggingServicePrinter.log('❌ Cubit: Login failed - ${failure.message}');
        emit(LoginStates.error(message: failure.message));
      },
      (user) {
        LoggingServicePrinter.log('✅ Cubit: Login successful - ${user.email}');
        emit(LoginStates.success(user));
      },
    );
  }

  void resetState() {
    emit(const LoginStates.initial());
  }
}
