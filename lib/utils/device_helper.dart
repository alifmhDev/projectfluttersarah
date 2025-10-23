import 'package:device_info_plus/device_info_plus.dart';

class DeviceHelper {
  static Future<String> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    return "${androidInfo.model} (${androidInfo.manufacturer})";
  }
}
