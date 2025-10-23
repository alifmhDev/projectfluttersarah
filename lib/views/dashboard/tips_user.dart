import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import '../../../models/event_model.dart';
import '../../../widgets/navbar_user.dart';

class TipsUserPage extends StatelessWidget {
  final User user;
  final List<Event> bookmark;

  const TipsUserPage({super.key, required this.bookmark, required this.user});

  @override
  Widget build(BuildContext context) {
    final tipsList = [
      'Datang tepat waktu ke acara kampus!',
      'Gunakan pakaian rapi dan sopan.',
      'Jangan lupa follow akun resmi event untuk update terbaru.',
      'Bawa ID Card atau KTM saat registrasi.',
    ];

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: SafeArea(
        child: Column(
          children: [
            NavbarUser(
              user: user,
              bookmark: bookmark,
              onLogout: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              currentPage: 'tips',
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tipsList.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.lightbulb,
                          color: Colors.orangeAccent),
                      title: Text(tipsList[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
