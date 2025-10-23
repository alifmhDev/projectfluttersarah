import 'package:flutter/material.dart';

class UserManagementView extends StatefulWidget {
  final List<Map<String, dynamic>> users;
  final String searchQuery;

  const UserManagementView({
    super.key,
    required this.users,
    required this.searchQuery,
  });

  @override
  State<UserManagementView> createState() => _UserManagementViewState();
}

class _UserManagementViewState extends State<UserManagementView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  // Filter users berdasarkan search query
  List<Map<String, dynamic>> get filteredUsers {
    if (widget.searchQuery.isEmpty) {
      return widget.users;
    }
    return widget.users.where((user) {
      final name = user['name'].toString().toLowerCase();
      final email = user['email'].toString().toLowerCase();
      final role = user['role'].toString().toLowerCase();
      final id = user['id'].toString().toLowerCase();
      final query = widget.searchQuery.toLowerCase();

      return name.contains(query) ||
          email.contains(query) ||
          role.contains(query) ||
          id.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool isMobile = constraints.maxWidth < 600;
      final bool isTablet =
          constraints.maxWidth >= 600 && constraints.maxWidth < 900;

      if (isMobile) {
        return _buildMobileLayout();
      } else {
        return _buildTabletDesktopLayout(isTablet);
      }
    });
  }

  // Layout untuk Mobile (Vertikal)
  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildAddUserForm(true),
          const SizedBox(height: 16),
          _buildUserList(true),
        ],
      ),
    );
  }

  // Layout untuk Tablet & Desktop (Horizontal)
  Widget _buildTabletDesktopLayout(bool isTablet) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📋 Tabel user
          Expanded(
            flex: isTablet ? 2 : 3,
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildUserTable(isTablet),
              ),
            ),
          ),
          SizedBox(width: isTablet ? 12 : 16),
          // ➕ Form tambah user
          Expanded(
            flex: isTablet ? 1 : 2,
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildAddUserForm(false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tabel User (Tablet & Desktop)
  Widget _buildUserTable(bool isTablet) {
    final users = filteredUsers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Daftar Pengguna",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (widget.searchQuery.isNotEmpty)
              Text(
                "${users.length} hasil",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        const Divider(),
        if (users.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "Tidak ada data yang ditemukan",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  border: TableBorder.all(color: Colors.grey.shade300),
                  columnSpacing: isTablet ? 20 : 56,
                  horizontalMargin: isTablet ? 12 : 24,
                  columns: const [
                    DataColumn(label: Text("ID")),
                    DataColumn(label: Text("Nama")),
                    DataColumn(label: Text("Email")),
                    DataColumn(label: Text("Role")),
                  ],
                  rows: users
                      .map((user) => DataRow(cells: [
                            DataCell(Text(user['id'])),
                            DataCell(
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: isTablet ? 100 : 150,
                                ),
                                child: Text(
                                  user['name'],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataCell(
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: isTablet ? 120 : 180,
                                ),
                                child: Text(
                                  user['email'],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataCell(Text(user['role'])),
                          ]))
                      .toList(),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // List User untuk Mobile (Card View)
  Widget _buildUserList(bool isMobile) {
    final users = filteredUsers;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Daftar Pengguna",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (widget.searchQuery.isNotEmpty)
                  Text(
                    "${users.length} hasil",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
            const Divider(),
            if (users.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 12),
                      Text(
                        "Tidak ada data yang ditemukan",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: users.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent.withOpacity(0.1),
                      child: Text(
                        user['name'][0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      user['name'],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['email'],
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: user['role'] == 'Admin'
                                ? Colors.purple.withOpacity(0.1)
                                : Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            user['role'],
                            style: TextStyle(
                              fontSize: 10,
                              color: user['role'] == 'Admin'
                                  ? Colors.purple[700]
                                  : Colors.blue[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      user['id'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  // Form Tambah User
  Widget _buildAddUserForm(bool isMobile) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Tambah Pengguna",
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Nama Lengkap",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _roleController,
              decoration: InputDecoration(
                labelText: "Role",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Logika tambah user
                _nameController.clear();
                _emailController.clear();
                _roleController.clear();
              },
              icon: const Icon(Icons.add),
              label: const Text("Tambah User"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
