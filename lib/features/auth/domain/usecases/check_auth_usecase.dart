import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repo.dart';

class CheckAuthUsecase implements UseCase<bool, NoParams> {
  final AuthRepo repository;

  CheckAuthUsecase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.checkAuth();
  }
}
