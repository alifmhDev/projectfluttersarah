import 'package:flutter_application_2/models/event_model.dart';

class Lomba extends Event {
  bool bersifatIndividu;

  Lomba({
    required super.id,
    required super.title,
    required super.category,
    required super.date,
    required super.location,
    required super.type,
    required super.isOnline,
    required super.registered,
    required super.imagePath,
    required super.organizer,
    required super.quota,
    required this.bersifatIndividu,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'date': date,
      'location': location,
      'type': type,
      'isOnline': isOnline,
      'registered': registered,
      'imagePath': imagePath,
      'organizer': organizer,
      'quota': quota,
      'bersifatIndividu': bersifatIndividu,
    };
  }

  factory Lomba.fromMap(Map<String, dynamic> map) {
    return Lomba(
      id: map['id'],
      title: map['title'],
      category: map['category'],
      date: map['date'],
      location: map['location'],
      type: map['type'],
      isOnline: map['isOnline'],
      registered: map['registered'],
      imagePath: map['imagePath'],
      organizer: map['organizer'],
      quota: map['quota'],
      bersifatIndividu: map['bersifatIndividu'],
    );
  }
}
