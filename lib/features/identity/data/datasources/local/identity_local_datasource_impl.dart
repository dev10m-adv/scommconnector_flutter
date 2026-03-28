import 'package:shared_preferences/shared_preferences.dart';

import 'identity_local_datasource.dart';

class IdentityLocalDataSourceImpl implements IdentityLocalDataSource {
  static const _registeredUserIdKey = 'identity_registered_user_id';
  static const _registeredDeviceIdKey = 'identity_registered_device_id';

  String _deviceStoreKey(String userId) => 'identity_device_store_$userId';

  @override
  Future<void> saveRegisteredDeviceIdentity({
    required String userId,
    required String deviceId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    var key = _deviceStoreKey(userId);
    await prefs.setString(key, deviceId);
  }

  @override
  Future<({String userId, String deviceId})?>
  loadRegisteredDeviceIdentity(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final deviceId = prefs.getString(_deviceStoreKey(userId))?.trim();

    if (deviceId == null || deviceId.isEmpty) return null;

    return (userId: userId, deviceId: deviceId);
  }
}
