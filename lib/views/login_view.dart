import 'package:flutter/material.dart';
import 'dart:ui';
import '../controllers/auth_controller.dart';
import '../utils/prefs_helper.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = AuthController();
  
  // Tambahan untuk show/hide password
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // 🌈 Background gradient (mengikuti contoh gambar)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xFF2E005E), // Ungu tua bawah
                  Color(0xFF8E2DE2), // Ungu terang
                  Color(0xFFF16E5C), // Merah-oranye
                  Color(0xFFFFC371), // Oranye keemasan atas
                ],
                stops: [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),

          // Efek blur lembut
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
            child: Container(color: Colors.black.withOpacity(0.1)),
          ),

          // 🌟 Card Login
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth < 500 ? 320 : 380, // ukuran responsif
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 25,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo
                          Image.asset(
                            "assets/images/logo1.png",
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 20),

                          const Text(
                            "Sign in",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 25),

                          // Email
                          TextField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "E-Mail",
                              hintStyle: const TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Password dengan Show/Hide Toggle
                          TextField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible, // Toggle berdasarkan state
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle: const TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 14,
                              ),
                              // Tambahkan suffixIcon untuk toggle
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white70,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),

                          // Tombol Sign In
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () async {
                              await _authController.login(
                                context,
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                              );
                              await PrefsHelper.saveUser(
                                  _emailController.text.trim());
                            },
                            child: const Text(
                              "Sign in",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Register Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(color: Colors.white70),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Sign up",
                                  style: TextStyle(
                                    color: Color(0xFFFFC371),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_right_alt,
                                color: Color(0xFFFFC371),
                                size: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}