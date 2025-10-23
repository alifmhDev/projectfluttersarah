import 'package:flutter/material.dart';
import '../../utils/format_helper.dart';

class EventManagementView extends StatefulWidget {
  final List<Map<String, dynamic>> events;
  final String searchQuery;
  const EventManagementView({
    super.key,
    required this.events,
    required this.searchQuery,
  });

  @override
  State<EventManagementView> createState() => _EventManagementViewState();
}

class _EventManagementViewState extends State<EventManagementView> {
  late List<Map<String, dynamic>> _eventList;

  @override
  void initState() {
    super.initState();
    _eventList = widget.events;
  }

  // Filter events berdasarkan search query
  List<Map<String, dynamic>> get filteredEvents {
    if (widget.searchQuery.isEmpty) {
      return _eventList;
    }
    return _eventList.where((event) {
      final name = event['name'].toString().toLowerCase();
      final status = event['status'].toString().toLowerCase();
      final id = event['id'].toString().toLowerCase();
      final date = event['date'].toString().toLowerCase();
      final query = widget.searchQuery.toLowerCase();
      
      return name.contains(query) || 
             status.contains(query) || 
             id.contains(query) ||
             date.contains(query);
    }).toList();
  }

  void _addEventDialog(BuildContext context) {
    final idController = TextEditingController();
    final nameController = TextEditingController();
    final dateController = TextEditingController();
    final statusController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Tambah Event Baru"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idController,
                decoration: const InputDecoration(labelText: "ID Event"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nama Event"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: "Tanggal (yyyy-MM-dd)"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(labelText: "Status"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _eventList.add({
                  "id": idController.text,
                  "name": nameController.text,
                  "date": dateController.text,
                  "status": statusController.text,
                });
              });
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredEvents;

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        bool isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 900;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kelola Event",
                      style: TextStyle(
                        fontSize: isMobile ? 20 : 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    if (widget.searchQuery.isNotEmpty)
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
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(isMobile ? "Tambah" : "Tambah Event"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 12 : 16,
                      vertical: isMobile ? 8 : 12,
                    ),
                  ),
                  onPressed: () => _addEventDialog(context),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 12 : 20),
            // Tabel Event
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
            "Tidak ada event yang ditemukan",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          if (widget.searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                "untuk pencarian: \"${widget.searchQuery}\"",
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
        final event = filtered[index];
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
                        event["name"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: event["status"] == "Aktif"
                            ? Colors.green.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        event["status"],
                        style: TextStyle(
                          fontSize: 12,
                          color: event["status"] == "Aktif"
                              ? Colors.green[700]
                              : Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "ID: ${event["id"]}",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  "Tanggal: ${FormatHelper.formatDate(event['date'])}",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                      onPressed: () {
                        setState(() => _eventList.remove(event));
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
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
            DataColumn(label: Text("ID Event")),
            DataColumn(label: Text("Nama Event")),
            DataColumn(label: Text("Tanggal")),
            DataColumn(label: Text("Status")),
            DataColumn(label: Text("Aksi")),
          ],
          rows: filtered.map((e) {
            return DataRow(cells: [
              DataCell(Text(e["id"].toString())),
              DataCell(
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isTablet ? 150 : 200),
                  child: Text(
                    e["name"],
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataCell(Text(FormatHelper.formatDate(e['date']))),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: e["status"] == "Aktif"
                        ? Colors.green.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    e["status"],
                    style: TextStyle(
                      fontSize: 12,
                      color: e["status"] == "Aktif"
                          ? Colors.green[700]
                          : Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() => _eventList.remove(e));
                      },
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