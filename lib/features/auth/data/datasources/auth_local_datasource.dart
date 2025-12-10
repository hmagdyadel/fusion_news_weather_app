import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/helpers/crypto_helper.dart';
import '../../../../core/helpers/logging_service.dart';
import '../../../../core/services/database_service.dart';
import '../models/user_model.dart';

abstract class AuthLocalDatasource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  });
  Future<void> logout();
  Future<bool> checkAuth();
  Future<UserModel?> getCurrentUser();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final SharedPreferences sharedPreferences;

  AuthLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      LoggingServicePrinter.log('🔐 Attempting login for: $email');

      final db = await DatabaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (maps.isEmpty) {
        throw AuthException('Invalid email or password');
      }

      final user = UserModel.fromMap(maps.first);

      // Verify password
      if (!CryptoHelper.verifyPassword(password, user.hashedPassword)) {
        throw AuthException('Invalid email or password');
      }

      // Save session
      await sharedPreferences.setBool(AppConstants.keyIsLoggedIn, true);
      await sharedPreferences.setInt(AppConstants.keyUserId, user.id!);
      await sharedPreferences.setString(AppConstants.keyUserEmail, user.email);

      LoggingServicePrinter.log('✅ Login successful for: $email');
      return user;
    } catch (e) {
      LoggingServicePrinter.logError('❌ Login failed', error: e);
      if (e is AuthException) rethrow;
      throw AuthException('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      LoggingServicePrinter.log('📝 Attempting registration for: $email');

      final db = await DatabaseService.database;

      // Check if email already exists
      final existing = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (existing.isNotEmpty) {
        throw AuthException('Email already exists');
      }

      // Hash password
      final hashedPassword = CryptoHelper.hashPassword(password);

      // Create user
      final user = UserModel(
        email: email,
        hashedPassword: hashedPassword,
        name: name,
        createdAt: DateTime.now().toIso8601String(),
      );

      // Insert into database
      final id = await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );

      final createdUser = UserModel(
        id: id,
        email: user.email,
        hashedPassword: user.hashedPassword,
        name: user.name,
        createdAt: user.createdAt,
      );

      // Save session
      await sharedPreferences.setBool(AppConstants.keyIsLoggedIn, true);
      await sharedPreferences.setInt(AppConstants.keyUserId, id);
      await sharedPreferences.setString(AppConstants.keyUserEmail, email);

      LoggingServicePrinter.log('✅ Registration successful for: $email');
      return createdUser;
    } catch (e) {
      LoggingServicePrinter.logError('❌ Registration failed', error: e);
      if (e is AuthException) rethrow;
      throw AuthException('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      LoggingServicePrinter.log('🚪 Logging out...');

      await sharedPreferences.setBool(AppConstants.keyIsLoggedIn, false);
      await sharedPreferences.remove(AppConstants.keyUserId);
      await sharedPreferences.remove(AppConstants.keyUserEmail);

      LoggingServicePrinter.log('✅ Logout successful');
    } catch (e) {
      LoggingServicePrinter.logError('❌ Logout failed', error: e);
      throw AuthException('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<bool> checkAuth() async {
    try {
      final isLoggedIn =
          sharedPreferences.getBool(AppConstants.keyIsLoggedIn) ?? false;
      LoggingServicePrinter.log('🔍 Auth check: $isLoggedIn');
      return isLoggedIn;
    } catch (e) {
      LoggingServicePrinter.logError('❌ Auth check failed', error: e);
      return false;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final isLoggedIn = await checkAuth();
      if (!isLoggedIn) return null;

      final userId = sharedPreferences.getInt(AppConstants.keyUserId);
      if (userId == null) return null;

      final db = await DatabaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );

      if (maps.isEmpty) return null;

      return UserModel.fromMap(maps.first);
    } catch (e) {
      LoggingServicePrinter.logError('❌ Get current user failed', error: e);
      return null;
    }
  }
}
