import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'login_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    // 🎵 Bounce dibuat lebih pelan dan lembut
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // sebelumnya 2 detik → lebih halus
    )..repeat(reverse: true);

    _bounceAnimation =
        Tween<double>(begin: 0.95, end: 1.05).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // diganti dari elasticInOut biar lebih lembut
    ));

    // Jalankan fungsi tambahan
    setSeenSplash();
    getDeviceInfo();

    // Pindah otomatis ke LoginView setelah 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginView()),
      );
    });
  }

  // Shared Preferences
  Future<void> setSeenSplash() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenSplash', true);
  }

  // Device Info
  Future<void> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    var info = await deviceInfo.deviceInfo;
    print("Device Info: ${info.data}");
  }

  // Format tanggal pakai intl
  String getFormattedDate() {
    return DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🌈 Background gradasi
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xFF2E005E),
                  Color(0xFF8E2DE2),
                  Color(0xFFF16E5C),
                  Color(0xFFFFC371),
                ],
                stops: [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),

          // Efek blur lembut
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(color: Colors.black.withOpacity(0.05)),
          ),

          // 🌟 Konten utama
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔹 Logo lebih kecil & bounce lembut
                ScaleTransition(
                  scale: _bounceAnimation,
                  child: Image.asset(
                    "assets/images/logo1.png",
                    height: 140, // sebelumnya 220
                    width: 140,
                  ),
                ),
                const SizedBox(height: 16),

                // 🔹 Tanggal
                Stack(
                  children: [
                    Text(
                      getFormattedDate(),
                      style: TextStyle(
                        fontSize: 14, // lebih kecil
                        fontWeight: FontWeight.w500,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 1.5
                          ..color = Colors.black54,
                      ),
                    ),
                    Text(
                      getFormattedDate(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 🔹 Nama
                Text(
                  "By Sarah Amaylia",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20, // dari 26 → lebih pas di HP
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        offset: const Offset(1.5, 1.5),
                        blurRadius: 5,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 🔹 Tombol Skip
                GFButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginView()),
                    );
                  },
                  text: "Skip",
                  shape: GFButtonShape.pills,
                  color: Colors.deepPurpleAccent,
                  size: GFSize.MEDIUM, // kecilin dari LARGE
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
