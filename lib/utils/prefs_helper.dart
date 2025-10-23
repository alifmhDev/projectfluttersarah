import 'package:flutter_application_2/models/event_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  static Future<void> saveUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
  }

  static Future<String?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
  }

  // kode buat simpan bookmark per email
  static Future<void> saveBookmark(Event event, String email) async {
    final prefs = await SharedPreferences.getInstance();

    // disini penanda buat tiap email ditaruh di awal, dan dipisahkan kembali pakai titik koma (;)
    // agar tidak tercampur dengan data bookmark
    String addedBookmark = "$email;${event.toString()}";
    //ambil dulu data bookmark dari sp (karena tidak bisa secara otomatis menambah baru ke List pada sp)
    List<String>? availableBookmark = prefs.getStringList('bookmark') ?? [];
    availableBookmark.add(addedBookmark);
    prefs.setStringList('bookmark', availableBookmark);
  }

  // kode buat hapus bookmark per email
  static Future<void> deleteBookmark(Event event, String email) async {
    final prefs = await SharedPreferences.getInstance();

    // disini penanda buat tiap email ditaruh di awal, dan dipisahkan kembali pakai titik koma (;)
    // agar tidak tercampur dengan data bookmark
    String addedBookmark = "$email;${event.toString()}";
    //ambil dulu data bookmark dari sp (karena tidak bisa secara otomatis menambah baru ke List pada sp)
    List<String>? availableBookmark = prefs.getStringList('bookmark') ?? [];
    availableBookmark.add(addedBookmark);
    prefs.setStringList('bookmark', availableBookmark);
  }

  // kode buat ambil bookmark per email, entah bakal dipakai implementasi banyak email atau tidak (kayak register)
  static Future<Map<String, dynamic>> getBookmark(String email) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? availableBookmark = prefs.getStringList('bookmark') ?? [];
    List<Event> selectedBookmark = [];
    for (int i = 0; i < availableBookmark.length; i++) {
      if (availableBookmark[i].startsWith(email)) {
        /**
         * disini substring gunanya memisahkan string sejumlah angka yang ditentukan, contoh
         * String em = 'indra@gmail.com'; // dengan panjang karakter 15
         * string output = em.substring(5); // hasil variable output menjadi '@gmail.com', 5 karakter dihapus pakai substring
         *
         * dan kode dibawah ada + 1, karena buat menghapus titk koma dari bookmark yg tersimpan ke sp
         */
        Event ev = Event.fromString(availableBookmark[i].substring(email.length +1));
        selectedBookmark.add(ev);
      }
    }
    Map<String, dynamic> result = {
      'email': email,
      'bookmark': selectedBookmark
    };
    return result;
  }
}
