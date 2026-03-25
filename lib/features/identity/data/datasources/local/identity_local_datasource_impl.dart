import 'package:shared_preferences/shared_preferences.dart';

import 'identity_local_datasource.dart';

class IdentityLocalDataSourceImpl implements IdentityLocalDataSource {
  static const _registeredUserIdKey = 'identity_registered_user_id';
  static const _registeredDeviceIdKey = 'identity_registered_device_id';

  @override
  Future<void> saveRegisteredDeviceIdentity({
    required String userId,
    required String deviceId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_registeredUserIdKey, userId);
    await prefs.setString(_registeredDeviceIdKey, deviceId);
  }

  @override
  Future<({String userId, String deviceId})?>
  loadRegisteredDeviceIdentity() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_registeredUserIdKey)?.trim();
    final deviceId = prefs.getString(_registeredDeviceIdKey)?.trim();

    if (userId == null ||
        userId.isEmpty ||
        deviceId == null ||
        deviceId.isEmpty) {
      return null;
    }

    return (userId: userId, deviceId: deviceId);
  }
}
