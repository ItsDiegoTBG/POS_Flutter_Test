import '../database_helper.dart';
import '../../domain/entities/user.dart';
import 'package:sqflite/sqflite.dart';

class UserRepository{

  Future<int> insertUser(User user) async {
    Database db = await DatabaseHelper.instance.db;
    return await db.insert('users', user.toMap());
  }

  Future<void> initializeUsers() async {
    List<User> usersToAdd = [
      User(username: 'John', password: '123',userType: UserType.admin),
      User(username: 'Jane', password: 'abc',userType: UserType.normal),
      User(username: 'Alice', password: 'da',userType: UserType.normal),
      User(username: 'Bob', password: 'ca',userType: UserType.admin),
      User(username: 'd', password: 'a',userType: UserType.admin),
    ];

    for (User user in usersToAdd) {
      await insertUser(user);
    }
  }
  

  Future<User?> getUser(String name, String password) async {
    final db = await DatabaseHelper.instance.db;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [name, password],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }


  Future<User?> loginUser(String username, String password) async {
    final db = await DatabaseHelper.instance.db;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }

  Future<List<User>> getAllUsers() async {
  final db = await DatabaseHelper.instance.db;
  final List<Map<String, dynamic>> maps = await db.query('users');

  return List.generate(maps.length, (i) {
    return User.fromMap(maps[i]);
  });
}

    Future<int> deleteUser(int id) async {
    Database db = await DatabaseHelper.instance.db;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> delateUsers(int ammount) async {
    for (int f=0; f<ammount;f++) {
      await deleteUser(f);
    }
  }
}
