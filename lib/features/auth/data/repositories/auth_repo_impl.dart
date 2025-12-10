import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/helpers/logging_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repo.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthLocalDatasource localDatasource;

  AuthRepoImpl({required this.localDatasource});

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await localDatasource.login(
        email: email,
        password: password,
      );
      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      LoggingServicePrinter.log('❌ Auth Repo: Login failed - ${e.message}');
      return Left(AuthFailure(e.message));
    } catch (e) {
      LoggingServicePrinter.log('❌ Auth Repo: Unexpected error - $e');
      return Left(AuthFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userModel = await localDatasource.register(
        email: email,
        password: password,
        name: name,
      );
      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      LoggingServicePrinter.log('❌ Auth Repo: Registration failed - ${e.message}');
      return Left(AuthFailure(e.message));
    } catch (e) {
      LoggingServicePrinter.log('❌ Auth Repo: Unexpected error - $e');
      return Left(AuthFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDatasource.logout();
      return const Right(null);
    } catch (e) {
      LoggingServicePrinter.log('❌ Auth Repo: Logout failed - $e');
      return Left(AuthFailure('Logout failed'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkAuth() async {
    try {
      final isAuthenticated = await localDatasource.checkAuth();
      return Right(isAuthenticated);
    } catch (e) {
      LoggingServicePrinter.log('❌ Auth Repo: Check auth failed - $e');
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final userModel = await localDatasource.getCurrentUser();
      return Right(userModel?.toEntity());
    } catch (e) {
      LoggingServicePrinter.log('❌ Auth Repo: Get current user failed - $e');
      return const Right(null);
    }
  }
}
