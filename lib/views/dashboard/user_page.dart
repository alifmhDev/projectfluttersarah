// lib/views/dashboard/user_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/event_model.dart';
import 'package:flutter_application_2/utils/prefs_helper.dart';
import '../../models/user_model.dart';
import '../../widgets/navbar_user.dart';
import 'bookmark_user.dart';

class DashboardUserPage extends StatefulWidget {
  final User user;

  const DashboardUserPage({super.key, required this.user});

  @override
  State<DashboardUserPage> createState() => _DashboardUserPageState();
}

class _DashboardUserPageState extends State<DashboardUserPage> {
  String _selectedCategory = "Semua Kategori";
  String _selectedLocation = "Semua Lokasi";
  String _selectedType = "Semua";
  String _searchQuery = "";

  // LIST BOOKMARK (DITAMBAHKAN)
  final List<Event> bookmarkedEvents = [];

  final List<String> _categories = [
    "Semua Kategori",
    "Teknologi",
    "Seni & Budaya",
    "Olahraga",
    "Akademik",
    "Bisnis",
  ];

  final List<String> _locations = [
    "Semua Lokasi",
    "Surabaya",
    "Jakarta",
    "Bandung",
    "Yogyakarta",
    "Online",
  ];

  final List<Event> _events = [
    Event(
      id: 1,
      title: "Seminar AI & Machine Learning 2025",
      category: "Teknologi",
      date: "20 Sept 2025",
      location: "Surabaya",
      type: "Gratis",
      isOnline: false,
      registered: false,
      imagePath: "assets/images/event1.png",
      organizer: "UNESA Tech Community",
      quota: "50 peserta",
    ),
    Event(
      id: 2,
      title: "Workshop UI/UX Design Thinking",
      category: "Teknologi",
      date: "25 Sept 2025",
      location: "Online",
      type: "Berbayar",
      isOnline: true,
      registered: false,
      imagePath: "assets/images/event2.png",
      organizer: "Design Club UNESA",
      quota: "100 peserta",
    ),
    Event(
      id: 3,
      title: "Lomba Startup Digital Competition",
      category: "Bisnis",
      date: "30 Sept 2025",
      location: "Jakarta",
      type: "Berbayar",
      isOnline: false,
      registered: false,
      imagePath: "assets/images/event3.png",
      organizer: "Indonesia Startup Hub",
      quota: "30 tim",
    ),
    Event(
      id: 4,
      title: "Festival Seni Kampus 2025",
      category: "Seni & Budaya",
      date: "5 Okt 2025",
      location: "Surabaya",
      type: "Gratis",
      isOnline: false,
      registered: false,
      imagePath: "assets/images/event4.png",
      organizer: "Kesenian UNESA",
      quota: "Unlimited",
    ),
    Event(
      id: 5,
      title: "Turnamen Futsal Antar Fakultas",
      category: "Olahraga",
      date: "10 Okt 2025",
      location: "Surabaya",
      type: "Gratis",
      isOnline: false,
      registered: false,
      imagePath: "assets/images/event5.png",
      organizer: "BEM UNESA",
      quota: "16 tim",
    ),
  ];

  List<Event> get filteredEvents {
    return _events.where((event) {
      bool matchCategory = _selectedCategory == "Semua Kategori" ||
          event.category == _selectedCategory;
      bool matchLocation = _selectedLocation == "Semua Lokasi" ||
          event.location == _selectedLocation;
      bool matchType = _selectedType == "Semua" ||
          (_selectedType == "Gratis" && event.type == "Gratis") ||
          (_selectedType == "Berbayar" && event.type == "Berbayar") ||
          (_selectedType == "Online" && event.isOnline == true);
      bool matchSearch = _searchQuery.isEmpty ||
          event.title
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      return matchCategory && matchLocation && matchType && matchSearch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    loadBookmark();
  }

  void loadBookmark() async {
      Map<String, dynamic> fromSp =
          await PrefsHelper.getBookmark(widget.user.email);
      List<Event> bookmarkFromSp = fromSp['bookmark'];
      setState(() {
        for (int i = 0; i < bookmarkFromSp.length; i++) {
          bookmarkedEvents.add(bookmarkFromSp[i]);
          print("yang masuk bookmark: ${bookmarkFromSp[i].title}");
        }
      });
      if (bookmarkedEvents.contains(_events[0])) {
        print("ada ytta");
      }
  }

  // method simpan bookmark di shared pref
  void saveBookmarkToSharedPrefs(Event event) {
    PrefsHelper.saveBookmark(event, widget.user.email);
  }

  // method hapus bookmark di shared pref
  void deleteBookmarkFromSharedPrefs(Event event) {
    PrefsHelper.deleteBookmark(event, widget.user.email);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 600 && screenWidth <= 1024;
    final horizontalPadding = isDesktop ? 60.0 : (isTablet ? 40.0 : 20.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeroSection()),
          SliverToBoxAdapter(child: _buildFilterChips()),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 30,
            ),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent:
                    isDesktop ? 350 : (isTablet ? 300 : double.infinity),
                mainAxisSpacing: isDesktop ? 20 : 16,
                crossAxisSpacing: isDesktop ? 20 : 16,
                childAspectRatio: isDesktop ? 0.75 : (isTablet ? 0.75 : 1.1),
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildEventCard(filteredEvents[index]);
                },
                childCount: filteredEvents.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 600 && screenWidth <= 1024;
    final isMobile = screenWidth <= 600;

    final horizontalPadding = isDesktop ? 60.0 : (isTablet ? 40.0 : 20.0);
    final titleSize = isDesktop ? 56.0 : (isTablet ? 44.0 : 32.0);
    final subtitleSize = isDesktop ? 52.0 : (isTablet ? 40.0 : 28.0);

    return Container(
      constraints: BoxConstraints(
        minHeight: isMobile ? 420 : (isTablet ? 480 : 520),
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2E005E),
            Color(0xFF5E35B1),
            Color(0xFF7E57C2),
            Color(0xFF9575CD),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(screenWidth, isMobile ? 100 : 150),
              painter: WavePainter(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: isMobile ? 16 : 24),
                  _buildTopNavBar(),
                  SizedBox(height: isMobile ? 40 : 60),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    child: const Text(
                      'All in One',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 24 : 32,
                      vertical: isMobile ? 8 : 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      'Event Kampus Hub',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF5E35B1),
                        fontSize: subtitleSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                    ),
                    child: const Text(
                      'UNESA Edition',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: isMobile ? 32 : 48),
                  _buildSearchFilters(),
                  SizedBox(height: isMobile ? 24 : 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNavBar() {
    return NavbarUser(
      user: widget.user,
      bookmark: bookmarkedEvents,
      onLogout: _handleLogout,
    );
  }

  void _handleLogout() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  Widget _buildSearchFilters() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 600 && screenWidth <= 1024;
    final isMobile = screenWidth <= 600;

    if (isMobile) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                icon: Icon(Icons.search, color: Color(0xFF5E35B1)),
                hintText: 'Cari event di sini...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  icon: Icons.category,
                  value: _selectedCategory,
                  items: _categories,
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdown(
                  icon: Icons.location_on,
                  value: _selectedLocation,
                  items: _locations,
                  onChanged: (value) {
                    setState(() {
                      _selectedLocation = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          flex: isDesktop ? 3 : 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                icon: Icon(Icons.search, color: Color(0xFF5E35B1)),
                hintText: 'Cari event di sini...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        SizedBox(width: isTablet ? 12 : 15),
        Expanded(
          flex: 2,
          child: _buildDropdown(
            icon: Icons.category,
            value: _selectedCategory,
            items: _categories,
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
              });
            },
          ),
        ),
        SizedBox(width: isTablet ? 12 : 15),
        Expanded(
          flex: 2,
          child: _buildDropdown(
            icon: Icons.location_on,
            value: _selectedLocation,
            items: _locations,
            onChanged: (value) {
              setState(() {
                _selectedLocation = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required IconData icon,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;

    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: isMobile ? 12 : 15, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF5E35B1)),
          style: TextStyle(
            color: Colors.black87,
            fontSize: isMobile ? 13 : 14,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(icon,
                      size: isMobile ? 16 : 18, color: const Color(0xFF5E35B1)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 600 && screenWidth <= 1024;
    final isMobile = screenWidth <= 600;

    final horizontalPadding = isDesktop ? 60.0 : (isTablet ? 40.0 : 20.0);
    final filterChips = [
      {'label': 'Semua', 'value': 'Semua'},
      {'label': 'Gratis', 'value': 'Gratis'},
      {'label': 'Berbayar', 'value': 'Berbayar'},
      {'label': 'Online', 'value': 'Online'},
    ];

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 30),
      child: isMobile
          ? Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: filterChips.map((chip) {
                return _buildFilterChip(
                  chip['label']!,
                  _selectedType == chip['value']!,
                  () {
                    setState(() {
                      _selectedType = chip['value']!;
                    });
                  },
                );
              }).toList(),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: filterChips.map((chip) {
                final isLast = chip == filterChips.last;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildFilterChip(
                      chip['label']!,
                      _selectedType == chip['value']!,
                      () {
                        setState(() {
                          _selectedType = chip['value']!;
                        });
                      },
                    ),
                    if (!isLast) SizedBox(width: isTablet ? 12 : 15),
                  ],
                );
              }).toList(),
            ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 30,
            vertical: isMobile ? 10 : 12,
          ),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF5E35B1) : Colors.white,
            border: Border.all(
              color:
                  isSelected ? const Color(0xFF5E35B1) : Colors.grey.shade300,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF5E35B1).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;

    // Card height variable for mobile vs larger screens
    final cardContentPadding = EdgeInsets.all(isMobile ? 12 : 14);

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () => _showEventDetail(event),
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE AREA
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Container(
                height: isMobile ? 160 : 140,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF5E35B1),
                      Color(0xFF7E57C2),
                    ],
                  ),
                ),
                child: Image.asset(
                  event.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF5E35B1),
                      child: const Icon(
                        Icons.event,
                        size: 50,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),

            // CONTENT AREA (tidak Expanded untuk menghindari layout conflicts)
            Padding(
              padding: cardContentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8EAF6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      event.category,
                      style: const TextStyle(
                        color: Color(0xFF5E35B1),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isMobile ? 15 : 16,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 13, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          event.date,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 13, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          event.location,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // BOTTOM ROW: type + bookmark + detail
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: event.type == 'Gratis'
                              ? Colors.green.shade50
                              : Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          event.type,
                          style: TextStyle(
                            color: event.type == 'Gratis'
                                ? Colors.green.shade700
                                : Colors.orange.shade700,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // action buttons (bookmark + detail)
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              bookmarkedEvents.contains(event)
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: bookmarkedEvents.contains(event)
                                  ? const Color(0xFF5E35B1)
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                if (bookmarkedEvents.contains(event)) {
                                  bookmarkedEvents.remove(event);
                                  deleteBookmarkFromSharedPrefs(event);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Dihapus dari bookmark')),
                                  );
                                } else {
                                  bookmarkedEvents.add(event);
                                  saveBookmarkToSharedPrefs(event);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Disimpan ke bookmark')),
                                  );
                                }
                              });
                            },
                          ),
                          const SizedBox(width: 6),
                          ElevatedButton(
                            onPressed: () => _showEventDetail(event),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5E35B1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Detail',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEventDetail(Event event) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 8,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : 500,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    child: Container(
                      height: isMobile ? 200 : 220,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF5E35B1), Color(0xFF7E57C2)],
                        ),
                      ),
                      child: Image.asset(
                        event.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFF5E35B1),
                            child: const Icon(Icons.event,
                                size: 60, color: Colors.white),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: TextStyle(
                          fontSize: isMobile ? 20 : 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2E005E),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildDetailRow(
                          Icons.category, 'Kategori', event.category),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                          Icons.calendar_today, 'Tanggal', event.date),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                          Icons.location_on, 'Lokasi', event.location),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                          Icons.business, 'Penyelenggara', event.organizer),
                      const SizedBox(height: 12),
                      _buildDetailRow(Icons.people, 'Kuota', event.quota),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                          Icons.attach_money, 'Tipe', event.type),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                side: const BorderSide(
                                    color: Color(0xFF5E35B1), width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Tutup',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF5E35B1),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _handleRegister(event);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5E35B1),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                event.registered
                                    ? 'Terdaftar'
                                    : 'Daftar Sekarang',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF5E35B1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF5E35B1), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleRegister(Event event) {
    setState(() {
      event.registered = !event.registered;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              event.registered ? Icons.check_circle : Icons.cancel,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                event.registered
                    ? "Berhasil mendaftar ke ${event.title}!"
                    : "Batal mendaftar dari ${event.title}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: event.registered ? Colors.green : Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

/// Wave background painter
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.3,
      size.width * 0.5,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.7,
      size.width,
      size.height * 0.5,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => false;
}
