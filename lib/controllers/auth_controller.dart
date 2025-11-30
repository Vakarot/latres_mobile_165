import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../pages/home_screen.dart';
import '../pages/login_screen.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  var isLoading = false.obs;

  // Method untuk check login status (dipanggil manual dari LoginPage)
  bool checkLoginStatus() {
    return _authService.isLoggedIn();
  }

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Username dan password tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    bool success = await _authService.login(username, password);
    isLoading.value = false;

    if (success) {
      Get.offAll(() => HomePage());
    } else {
      Get.snackbar(
        'Error',
        'Username atau password salah',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> register(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Username dan password tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    bool success = await _authService.register(username, password);
    isLoading.value = false;

    if (success) {
      Get.snackbar(
        'Success',
        'Registrasi berhasil! Silakan login',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Error',
        'Username sudah terdaftar',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    Get.offAll(() => LoginPage());
  }

  String getCurrentUsername() {
    return _authService.getCurrentUsername() ?? 'User';
  }
}
