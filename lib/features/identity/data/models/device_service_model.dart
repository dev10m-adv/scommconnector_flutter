import '../../domain/entities/device_service.dart';

class DeviceServiceModel {
  final String serviceId;
  final String deviceId;
  final String serviceName;

  const DeviceServiceModel({
    required this.serviceId,
    required this.deviceId,
    required this.serviceName,
  });

  DeviceService toEntity() {
    return DeviceService(
      serviceId: serviceId,
      deviceId: deviceId,
      serviceName: serviceName,
    );
  }
}
