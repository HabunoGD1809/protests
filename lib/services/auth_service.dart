import 'package:project_protestas/models/user.dart';
import 'package:project_protestas/services/database_service.dart';

class AuthService {
  final DatabaseService _databaseService = DatabaseService();

  Future<User?> login(String email, String password) async {
    final db = await _databaseService.database;
    final result = db.select(
      'SELECT * FROM users WHERE email = ? AND password = ?',
      [email, password],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<bool> register(User user) async {
    final db = await _databaseService.database;
    try {
      db.execute(
        'INSERT INTO users (name, lastName, photo, role, cedula, phone, address, email, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [user.name, user.lastName, user.photo, user.role, user.cedula, user.phone, user.address, user.email, user.password],
      );
      return true;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  Future<bool> updateUser(User user) async {
    final db = await _databaseService.database;
    try {
      db.execute(
        'UPDATE users SET name = ?, lastName = ?, photo = ?, role = ?, cedula = ?, phone = ?, address = ?, email = ?, password = ? WHERE id = ?',
        [user.name, user.lastName, user.photo, user.role, user.cedula, user.phone, user.address, user.email, user.password, user.id],
      );
      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  Future<bool> deleteUser(int userId) async {
    final db = await _databaseService.database;
    try {
      db.execute(
        'DELETE FROM users WHERE id = ?',
        [userId],
      );
      return true;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }

  Future<List<User>> getAllUsers() async {
    final db = await _databaseService.database;
    final result = db.select('SELECT * FROM users');
    return result.map((row) => User.fromMap(row)).toList();
  }
}
