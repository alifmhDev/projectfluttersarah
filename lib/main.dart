import 'package:flutter/material.dart';
import 'models/user_model.dart';
import 'views/splash_view.dart';
import 'views/dashboard/user_page.dart';
import 'views/dashboard/tips_user.dart';
import 'views/dashboard/bookmark_user.dart';
import 'models/event_model.dart'; // pastikan file ini sesuai dengan kode Event kamu

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void removeBookmark(Event event) {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EventKampus',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const SplashView(),
      routes: {
        '/dashboard-user': (context) {
          final user = ModalRoute.of(context)!.settings.arguments as User;
          return DashboardUserPage(user: user);
        },
        '/tips-user': (context) {
          final user = ModalRoute.of(context)!.settings.arguments as User;
          return TipsUserPage(user: user, bookmark: []);
        },
        '/bookmark-user': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          // if (args == null) {
          //   throw Exception(
          //       'Route /bookmark-user dipanggil tanpa arguments (user & bookmark).');
          // }

          final user = args['user'] as User;
          final rawBookmark =
              args['bookmark'] ?? args['bookmarkedEvents'] ?? [];

          final List<Event> bookmarkedEvents = <Event>[];

          if (rawBookmark is List) {
            for (final item in rawBookmark) {
              if (item == null) continue;

              if (item is Event) {
                bookmarkedEvents.add(item);
              } else if (item is Map) {
                try {
                  bookmarkedEvents
                      .add(Event.fromMap(Map<String, dynamic>.from(item)));
                } catch (_) {
                  bookmarkedEvents.add(Event(
                    id: item['id'] ?? 0,
                    title: item['title']?.toString() ??
                        item['judul']?.toString() ??
                        'Tanpa Judul',
                    category: item['category']?.toString() ?? '',
                    date: item['date']?.toString() ??
                        item['tanggal']?.toString() ??
                        '',
                    location: item['location']?.toString() ??
                        item['lokasi']?.toString() ??
                        '',
                    type: item['type']?.toString() ?? '',
                    isOnline: item['isOnline'],
                    registered: item['registered'],
                    imagePath: item['imagePath']?.toString() ?? '',
                    organizer: item['organizer']?.toString() ?? '',
                    quota: item['quota']?.toString() ?? '',
                  ));
                }
              } else {
                // fallback kalau bukan Event atau Map
                bookmarkedEvents.add(Event(
                  id: 0,
                  title: item.toString(),
                  category: '',
                  date: '',
                  location: '',
                  type: '',
                  isOnline: false,
                  registered: false,
                  imagePath: '',
                  organizer: '',
                  quota: '',
                ));
              }
            }
          }

          return BookmarkUserPage(
            user: user,
            bookmarkedEvents: bookmarkedEvents,
            onRemove: (Event ev) {
              removeBookmark(ev);
            },
          );
        },
      },
    );
  }
}
