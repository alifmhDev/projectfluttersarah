import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../widgets/sidebar_admin.dart';
import '../../widgets/navbar_admin.dart';
import 'user_management_view.dart';
import 'event_management_view.dart';
import 'report_management_view.dart';

class DashboardAdminPage extends StatefulWidget {
  final User user;
  const DashboardAdminPage({super.key, required this.user});

  @override
  State<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  int selectedIndex = 0;
  String searchQuery = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> menuTitles = [
    "Dashboard",
    "Kelola User",
    "Kelola Event",
    "Laporan",
    "Pengaturan"
  ];

  // Dummy data
  final List<Map<String, dynamic>> users = List.generate(
    10,
    (index) => {
      "id": "USER00${index + 1}",
      "name": "User ${index + 1}",
      "email": "user${index + 1}@email.com",
      "role": index.isEven ? "Admin" : "Mahasiswa",
    },
  );

  final List<Map<String, dynamic>> events = List.generate(
    5,
    (index) => {
      "id": "EVENT00${index + 1}",
      "name": "Workshop Flutter ${index + 1}",
      "date": "2025-09-${25 + index}",
      "status": index.isEven ? "Aktif" : "Selesai",
    },
  );

  final List<Map<String, dynamic>> reports = List.generate(
    3,
    (index) => {
      "id": "LAPORAN00${index + 1}",
      "title": "Laporan Penggunaan ${index + 1}",
      "date": "2025-09-2${5 + index}",
      "type": index == 0 ? "Harian" : "Mingguan",
    },
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        bool isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 900;
        bool isDesktop = constraints.maxWidth >= 900;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xFFF4F6F9),
          appBar: !isDesktop
              ? NavbarAdmin(
                  title: menuTitles[selectedIndex],
                  onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  onSearchChanged: (query) {
                    setState(() {
                      searchQuery = query;
                    });
                  },
                  showSearch: selectedIndex != 0 && selectedIndex != 4,
                )
              : null,
          drawer: !isDesktop
              ? Drawer(
                  child: SidebarAdmin(
                    selectedMenu: menuTitles[selectedIndex],
                    onMenuSelected: _onMenuSelected,
                  ),
                )
              : null,
          body: Row(
            children: [
              if (isDesktop)
                SidebarAdmin(
                  selectedMenu: menuTitles[selectedIndex],
                  onMenuSelected: _onMenuSelected,
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 12.0 : isTablet ? 16.0 : 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isDesktop)
                        NavbarAdmin(
                          title: menuTitles[selectedIndex],
                          onSearchChanged: (query) {
                            setState(() {
                              searchQuery = query;
                            });
                          },
                          showSearch: selectedIndex != 0 && selectedIndex != 4,
                        ),
                      SizedBox(height: isMobile ? 12 : 20),
                      Expanded(
                        child: _buildContent(isMobile, isTablet, isDesktop),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onMenuSelected(String menu) {
    setState(() {
      searchQuery = "";
      selectedIndex = menuTitles.indexOf(menu);
    });
    // Tutup drawer setelah memilih menu
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  Widget _buildContent(bool isMobile, bool isTablet, bool isDesktop) {
    switch (selectedIndex) {
      case 0:
        return _buildDashboardCards(isMobile, isTablet, isDesktop);
      case 1:
        return UserManagementView(users: users, searchQuery: searchQuery);
      case 2:
        return EventManagementView(events: events, searchQuery: searchQuery);
      case 3:
        return ReportManagementView(reports: reports, searchQuery: searchQuery);
      case 4:
        return const Center(
          child: Text("Halaman Pengaturan - Masih dalam pengembangan."),
        );
      default:
        return const Center(child: Text("Halaman tidak ditemukan."));
    }
  }

  Widget _buildDashboardCards(bool isMobile, bool isTablet, bool isDesktop) {
    int crossAxisCount = isMobile ? 1 : isTablet ? 2 : 3;
    double childAspectRatio = isMobile ? 1.2 : isTablet ? 1.3 : 1.4;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: isMobile ? 12 : isTablet ? 16 : 24,
      mainAxisSpacing: isMobile ? 12 : isTablet ? 16 : 24,
      childAspectRatio: childAspectRatio,
      children: [
        _buildInfoCard(
          "Total User",
          "${users.length}",
          "Pengguna aktif",
          Icons.person_outline,
          const Color(0xFF5D7AFF),
          () => _onMenuSelected("Kelola User"),
          isMobile,
        ),
        _buildInfoCard(
          "Total Event",
          "${events.length}",
          "Acara aktif",
          Icons.event_outlined,
          const Color(0xFFEE6A88),
          () => _onMenuSelected("Kelola Event"),
          isMobile,
        ),
        _buildInfoCard(
          "Total Laporan",
          "${reports.length}",
          "Laporan terdata",
          Icons.analytics_outlined,
          const Color(0xFF996BFF),
          () => _onMenuSelected("Laporan"),
          isMobile,
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
    bool isMobile,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: isMobile ? 24 : 28,
                  backgroundColor: color.withOpacity(0.1),
                  child: Icon(icon, color: color, size: isMobile ? 26 : 30),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Text(
              title,
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: isMobile ? 12 : 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}