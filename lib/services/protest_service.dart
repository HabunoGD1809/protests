import 'package:project_protestas/models/protest.dart';
import 'package:project_protestas/services/database_service.dart';

class ProtestService {
  final DatabaseService _databaseService = DatabaseService();

  Future<bool> addProtest(Protest protest) async {
    final db = await _databaseService.database;
    try {
      db.execute(
        'INSERT INTO protests (uuid, userId, natureName, natureIcon, natureColor, province, summary, dateTime) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        [protest.uuid, protest.userId, protest.natureName, protest.natureIcon.codePoint, protest.natureColor.value, protest.province, protest.summary, protest.dateTime.toIso8601String()],
      );
      return true;
    } catch (e) {
      print('Error adding protest: $e');
      return false;
    }
  }

  Future<bool> updateProtest(Protest protest) async {
    final db = await _databaseService.database;
    try {
      db.execute(
        'UPDATE protests SET userId = ?, natureName = ?, natureIcon = ?, natureColor = ?, province = ?, summary = ?, dateTime = ? WHERE uuid = ?',
        [protest.userId, protest.natureName, protest.natureIcon.codePoint, protest.natureColor.value, protest.province, protest.summary, protest.dateTime.toIso8601String(), protest.uuid],
      );
      return true;
    } catch (e) {
      print('Error updating protest: $e');
      return false;
    }
  }

  Future<bool> deleteProtest(String uuid) async {
    final db = await _databaseService.database;
    try {
      db.execute(
        'DELETE FROM protests WHERE uuid = ?',
        [uuid],
      );
      return true;
    } catch (e) {
      print('Error deleting protest: $e');
      return false;
    }
  }

  Future<List<Protest>> getAllProtests() async {
    final db = await _databaseService.database;
    final results = db.select('SELECT * FROM protests');
    return results.map((row) => Protest.fromMap(row)).toList();
  }

  Future<List<Protest>> getProtestsByUser(int userId) async {
    final db = await _databaseService.database;
    final results = db.select('SELECT * FROM protests WHERE userId = ?', [userId]);
    return results.map((row) => Protest.fromMap(row)).toList();
  }
}
