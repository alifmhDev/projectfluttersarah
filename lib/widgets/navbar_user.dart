import 'package:flutter/material.dart';
import '../models/event_model.dart';

class NavbarUser extends StatelessWidget {
  final dynamic user;
  final List<Event> bookmark;
  final VoidCallback onLogout;
  final String currentPage; // Untuk menandai halaman aktif

  const NavbarUser({
    Key? key,
    required this.user,
    required this.bookmark,
    required this.onLogout,
    this.currentPage = 'home',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;
    final isTablet = screenWidth > 600 && screenWidth <= 1024;

    // kode untuk map bookmarknya
    Map<String, dynamic> userMap = {
      'user': user,
      'bookmark': bookmark,
      //bookmarkedEvents: null
    };

    if (isMobile) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLogo(context),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showProfileMenu(context),
                  borderRadius: BorderRadius.circular(25),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1565C0),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1565C0).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(context, 'Home', currentPage == 'home', () {
                  if (currentPage != 'home') {
                    Navigator.pushReplacementNamed(context, '/dashboard-user', arguments: user);
                  }
                }),
                _buildNavItem(context, 'Tips', currentPage == 'tips', () {
                  if (currentPage != 'tips') {
                    Navigator.pushNamed(context, '/tips-user', arguments: user);
                  }
                }),
                _buildNavItem(context, 'Bookmark', currentPage == 'bookmark', () {
                  if (currentPage != 'bookmark') {
                    // Navigator.pushNamed(context, '/bookmark-user', arguments: user);
                    Navigator.pushNamed(context, '/bookmark-user', arguments: userMap);
                  }
                }),
              ],
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLogo(context),
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNavItem(context, 'Home', currentPage == 'home', () {
                if (currentPage != 'home') {
                  Navigator.pushReplacementNamed(context, '/dashboard-user', arguments: user);
                }
              }),
              SizedBox(width: isTablet ? 24 : 32),
              _buildNavItem(context, 'Tips', currentPage == 'tips', () {
                if (currentPage != 'tips') {
                  Navigator.pushNamed(context, '/tips-user', arguments: user);
                }
              }),
              SizedBox(width: isTablet ? 24 : 32),
              _buildNavItem(context, 'Bookmark', currentPage == 'bookmark', () {
                if (currentPage != 'bookmark') {
                  // Navigator.pushNamed(context, '/bookmark-user', arguments: user);
                  Navigator.pushNamed(context, '/bookmark-user', arguments: userMap);
                }
              }),
              SizedBox(width: isTablet ? 24 : 32),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showProfileMenu(context),
                  borderRadius: BorderRadius.circular(25),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 16 : 20,
                      vertical: 10,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? 200 : 250,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1565C0),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1565C0).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            user.email,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 13 : 15,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogo(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;
    final logoSize = isMobile ? 40.0 : 48.0;
    final iconSize = isMobile ? 28.0 : 36.0;
    final fontSize = isMobile ? 17.0 : 21.0;

    return InkWell(
      onTap: () {
        if (currentPage != 'home') {
          Navigator.pushReplacementNamed(context, '/dashboard-user', arguments: user);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: logoSize,
            height: logoSize,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/logo1.png',
                fit: BoxFit.contain,
                width: iconSize,
                height: iconSize,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.event,
                    color: Colors.white,
                    size: iconSize * 0.7,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'EventHub',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, bool isActive, VoidCallback onTap) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;
    final fontSize = isMobile ? 14.0 : 16.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 12,
          vertical: isMobile ? 8 : 6,
        ),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : 400,
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5E35B1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 32,
                      color: Color(0xFF5E35B1),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Profil User',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E005E),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.email, size: 20, color: Colors.grey.shade600),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.email,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.badge, size: 20, color: Colors.grey.shade600),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Role',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.role,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Tutup',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onLogout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}