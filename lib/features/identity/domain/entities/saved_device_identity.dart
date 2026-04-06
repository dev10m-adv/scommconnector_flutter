class SavedDeviceIdentity {
  final String userId;
  final String deviceId;

  const SavedDeviceIdentity({required this.userId, required this.deviceId});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'deviceId': deviceId,
    };
  }

  factory SavedDeviceIdentity.fromJson(Map<String, dynamic> json) {
    return SavedDeviceIdentity(
      userId: json['userId'],
      deviceId: json['deviceId'],
    );
  }
}
