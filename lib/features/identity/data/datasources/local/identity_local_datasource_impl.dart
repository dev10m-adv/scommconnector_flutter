import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'identity_local_datasource.dart';

class IdentityLocalDataSourceImpl implements IdentityLocalDataSource {
  final FlutterSecureStorage _secureStorage;

  IdentityLocalDataSourceImpl({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;


  String _deviceStoreKey(String userId) => 'identity_device_store_$userId';
  @override
  Future<void> saveRegisteredDeviceIdentity({
    required String userId,
    required String deviceId,
  }) async {
    var key = _deviceStoreKey(userId);
    await _secureStorage.write(key: key, value: deviceId);
  }

  @override
  Future<({String userId, String deviceId})?>
  loadRegisteredDeviceIdentity(String userId) async {
    print('Loading registered device identity for userId: $userId');
    // await _secureStorage.delete(key: _deviceStoreKey(userId)); // For testing
    final deviceId = await _secureStorage.read(key: _deviceStoreKey(userId));

    if (deviceId == null || deviceId.isEmpty) return null;

    return (userId: userId, deviceId: deviceId);
  }
}
