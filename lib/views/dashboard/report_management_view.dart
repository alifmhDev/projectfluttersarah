import 'package:flutter/material.dart';

class ReportManagementView extends StatelessWidget {
  final List<Map<String, dynamic>> reports;
  final String searchQuery;
  const ReportManagementView({
    super.key,
    required this.reports,
    required this.searchQuery,
  });

  // Filter reports berdasarkan search query
  List<Map<String, dynamic>> get filteredReports {
    if (searchQuery.isEmpty) {
      return reports;
    }
    return reports.where((report) {
      final title = report['title'].toString().toLowerCase();
      final type = report['type'].toString().toLowerCase();
      final id = report['id'].toString().toLowerCase();
      final date = report['date'].toString().toLowerCase();
      final query = searchQuery.toLowerCase();
      
      return title.contains(query) || 
             type.contains(query) || 
             id.contains(query) ||
             date.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredReports;

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        bool isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 900;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Laporan",
                  style: TextStyle(
                    fontSize: isMobile ? 20 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (searchQuery.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "${filtered.length} hasil ditemukan",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: isMobile ? 12 : 20),
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmptyState()
                  : (isMobile
                      ? _buildMobileView(filtered)
                      : _buildTableView(filtered, isTablet)),
            ),
          ],
        );
      },
    );
  }

  // Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "Tidak ada laporan yang ditemukan",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          if (searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                "untuk pencarian: \"$searchQuery\"",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Tampilan Mobile (Card View)
  Widget _buildMobileView(List<Map<String, dynamic>> filtered) {
    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final report = filtered[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        report["title"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        report["type"],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "ID: ${report["id"]}",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  "Tanggal: ${report["date"]}",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text("Unduh"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.visibility, size: 16),
                      label: const Text("Lihat"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Tampilan Table (Tablet & Desktop)
  Widget _buildTableView(List<Map<String, dynamic>> filtered, bool isTablet) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateColor.resolveWith(
            (_) => const Color(0xFFF4F6FA),
          ),
          columnSpacing: isTablet ? 20 : 56,
          horizontalMargin: isTablet ? 12 : 24,
          columns: const [
            DataColumn(label: Text("ID Laporan")),
            DataColumn(label: Text("Judul")),
            DataColumn(label: Text("Tanggal")),
            DataColumn(label: Text("Tipe")),
            DataColumn(label: Text("Aksi")),
          ],
          rows: filtered.map((r) {
            return DataRow(cells: [
              DataCell(Text(r["id"])),
              DataCell(
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isTablet ? 150 : 200),
                  child: Text(
                    r["title"],
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataCell(Text(r["date"])),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    r["type"],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.download, color: Colors.green),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.visibility, color: Colors.blue),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}