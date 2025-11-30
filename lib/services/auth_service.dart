import 'package:hive/hive.dart';
import '../models/user_model.dart';

class AuthService {
  final Box<User> _userBox = Hive.box<User>('users');
  final Box _sessionBox = Hive.box('session');

  Future<bool> register(String username, String password) async {
    try {
      final existingUser = _userBox.values.firstWhere(
        (user) => user.username == username,
        orElse: () => User(username: '', password: ''),
      );

      if (existingUser.username.isNotEmpty) {
        return false;
      }

      final newUser = User(username: username, password: password);
      await _userBox.add(newUser);
      return true;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  // Login user
  Future<bool> login(String username, String password) async {
    try {
      final user = _userBox.values.firstWhere(
        (user) => user.username == username && user.password == password,
        orElse: () => User(username: '', password: ''),
      );

      if (user.username.isNotEmpty) {
        await _sessionBox.put('username', username);
        await _sessionBox.put('isLoggedIn', true);
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _sessionBox.clear();
  }

  bool isLoggedIn() {
    return _sessionBox.get('isLoggedIn', defaultValue: false);
  }

  String? getCurrentUsername() {
    return _sessionBox.get('username');
  }
}
