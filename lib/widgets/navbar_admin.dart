import 'package:flutter/material.dart';

class NavbarAdmin extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuPressed;
  final Function(String)? onSearchChanged;
  final bool showSearch;

  const NavbarAdmin({
    super.key,
    required this.title,
    this.onMenuPressed,
    this.onSearchChanged,
    this.showSearch = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  State<NavbarAdmin> createState() => _NavbarAdminState();
}

class _NavbarAdminState extends State<NavbarAdmin> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      if (widget.onSearchChanged != null) {
        widget.onSearchChanged!('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 900;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      leading: widget.onMenuPressed != null
          ? IconButton(
              icon: const Icon(Icons.menu, color: Colors.black87),
              onPressed: widget.onMenuPressed,
              tooltip: 'Menu',
            )
          : null,
      title: _isSearching
          ? _buildFloatingSearchField(isMobile)
          : Text(
              widget.title,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 18 : 20,
              ),
            ),
      centerTitle: false,
      actions: [
        // Search button
        if (widget.showSearch && !_isSearching)
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: _startSearch,
            tooltip: 'Cari',
          ),
        if (_isSearching)
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black87),
            onPressed: _stopSearch,
            tooltip: 'Tutup',
          ),
        // Icon notifikasi (opsional)
        if (!isMobile && !_isSearching)
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
            onPressed: () {
              _showNotification(context);
            },
            tooltip: 'Notifikasi',
          ),
        // Icon profil (opsional)
        if (!_isSearching || !isMobile)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFF4A6CF7),
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
              onPressed: () {
                _showProfileMenu(context);
              },
              tooltip: 'Profil',
            ),
          ),
      ],
    );
  }

  Widget _buildFloatingSearchField(bool isMobile) {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        style: TextStyle(
          fontSize: isMobile ? 14 : 16,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: 'Cari...',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: isMobile ? 14 : 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[400],
            size: isMobile ? 22 : 24,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
        ),
        onChanged: (value) {
          if (widget.onSearchChanged != null) {
            widget.onSearchChanged!(value);
          }
        },
      ),
    );
  }

  void _showNotification(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Row(
          children: [
            Icon(Icons.notifications, color: Color(0xFF4A6CF7)),
            SizedBox(width: 8),
            Text('Notifikasi'),
          ],
        ),
        content: const Text('Tidak ada notifikasi baru.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFF4A6CF7),
              child: Icon(Icons.person, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              'Admin User',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'admin@email.com',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Profil Saya'),
              onTap: () {
                Navigator.pop(context);
                // Navigasi ke halaman profil
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
                // Navigasi ke halaman pengaturan
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _confirmLogout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}