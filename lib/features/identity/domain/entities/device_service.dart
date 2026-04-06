class DeviceService {
  final String serviceId;
  final String deviceId;
  final String serviceName;

  const DeviceService({
    required this.serviceId,
    required this.deviceId,
    required this.serviceName,
  });

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'deviceId': deviceId,
      'serviceName': serviceName,
    };
  }

  factory DeviceService.fromJson(Map<String, dynamic> json) {
    return DeviceService(
      serviceId: json['serviceId'] as String,
      deviceId: json['deviceId'] as String,
      serviceName: json['serviceName'] as String,
    );
  }
}
