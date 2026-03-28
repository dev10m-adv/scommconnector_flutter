abstract class IdentityLocalDataSource {
  Future<void> saveRegisteredDeviceIdentity({
    required String userId,
    required String deviceId,
  });

  Future<({String userId, String deviceId})?> loadRegisteredDeviceIdentity(String userId);
}
