import 'package:flutter/material.dart';

class SidebarAdmin extends StatelessWidget {
  final Function(String) onMenuSelected;
  final String selectedMenu;

  const SidebarAdmin({
    super.key,
    required this.onMenuSelected,
    required this.selectedMenu,
  });

  @override
  Widget build(BuildContext context) {
    // Cek apakah sidebar ditampilkan sebagai Drawer atau permanent sidebar
    final isDrawer = Scaffold.of(context).hasDrawer;
    
    return Container(
      width: isDrawer ? double.infinity : 260,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A6CF7), Color(0xFF3A57E8)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: isDrawer
            ? null
            : const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Admin Panel",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Menu
              _buildMenuItem(
                icon: Icons.dashboard_outlined,
                label: "Dashboard",
                selected: selectedMenu == "Dashboard",
                onTap: () => onMenuSelected("Dashboard"),
              ),
              _buildMenuItem(
                icon: Icons.people_outline,
                label: "Kelola User",
                selected: selectedMenu == "Kelola User",
                onTap: () => onMenuSelected("Kelola User"),
              ),
              _buildMenuItem(
                icon: Icons.event_outlined,
                label: "Kelola Event",
                selected: selectedMenu == "Kelola Event",
                onTap: () => onMenuSelected("Kelola Event"),
              ),
              _buildMenuItem(
                icon: Icons.analytics_outlined,
                label: "Laporan",
                selected: selectedMenu == "Laporan",
                onTap: () => onMenuSelected("Laporan"),
              ),
              _buildMenuItem(
                icon: Icons.settings_outlined,
                label: "Pengaturan",
                selected: selectedMenu == "Pengaturan",
                onTap: () => onMenuSelected("Pengaturan"),
              ),

              const Spacer(),

              // Logout Button
              GestureDetector(
                onTap: () {
                  // Tutup drawer jika ada
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  // Navigasi ke login
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Color(0xFF3A57E8)),
                      SizedBox(width: 8),
                      Text(
                        "Logout",
                        style: TextStyle(
                          color: Color(0xFF3A57E8),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.white.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}