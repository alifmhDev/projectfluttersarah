class Event {
  int id;
  String title;
  String category;
  String date;
  String location;
  String type;
  bool isOnline;
  bool registered;
  String imagePath;
  String organizer;
  String quota;

  Event({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.location,
    required this.type,
    required this.isOnline,
    required this.registered,
    required this.imagePath,
    required this.organizer,
    required this.quota,
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
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
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
    );
  }

  @override
  String toString() {
    // karena tipe data yg bisa disimpan di sharedpreference terbatas, jadi ku buat string panjang yang dipisah dengan titk koma (;)
    return "$id;$title;$category;$date;$location;$type;$isOnline;$registered;$imagePath;$organizer;$quota";
  }

  // method buat mengubah string diatas menjadi objek Event
  factory Event.fromString(String event) {
    List<String> ev = event.split(';');
    return Event(
      id: int.parse(ev[0]),
      title: ev[1],
      category: ev[2],
      date: ev[3],
      location: ev[4],
      type: ev[5],
      isOnline: ev[6] == 'true' ? true : false,
      registered: ev[7] == 'true' ? true : false,
      imagePath: ev[8],
      organizer: ev[9],
      quota: ev[10],
    );
  }


  @override
  bool operator ==(Object other) {
    return other is Event && other.title == this.title && other.category == this.category;
  }

  @override
  int get hashCode => title.hashCode ^ category.hashCode;
}
