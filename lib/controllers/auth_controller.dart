import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../utils/prefs_helper.dart';
import '../views/dashboard/dashboard_admin_page.dart';
import '../views/dashboard/user_page.dart';

class AuthController {
  // Dummy data login sederhana
  final List<User> _users = [
    User(email: "admin", password: "admin123", role: "admin"),
    User(email: "user", password: "user123", role: "user"),
  ];

  Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      // Cari user berdasarkan email dan password
      final user = _users.firstWhere(
        (u) => u.email == email && u.password == password,
      );

      // Simpan ke SharedPreferences, abaikan jika sudah ada di SharedPref
      // if (await PrefsHelper.getUser(user.email) != null)
      await PrefsHelper.saveUser(user.email);

      // Arahkan sesuai role
      if (user.role == "admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => DashboardAdminPage(user: user)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => DashboardUserPage(user: user)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email atau password salah")),
      );
    }
  }
}
