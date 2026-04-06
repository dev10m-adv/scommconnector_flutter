import '../../domain/entities/device_service.dart';
import '../../domain/entities/identity_device.dart';
import '../../domain/entities/saved_device_identity.dart';

enum IdentityStatus { initial, loading, success, failure }

class IdentityState {
  final IdentityStatus status;
  final IdentityDevice? device;
  final List<IdentityDevice> devices;
  final bool isRegistered;
  final DeviceService? service;
  final List<DeviceService> services;
  final String? message;
  final String? error;
  final SavedDeviceIdentity? savedDeviceIdentity;

  const IdentityState({
    this.status = IdentityStatus.initial,
    this.device,
    this.isRegistered = false,
    this.devices = const [],
    this.service,
    this.services = const [],
    this.message,
    this.error,
    this.savedDeviceIdentity,
  });

  IdentityState copyWith({
    IdentityStatus? status,
    IdentityDevice? device,
    List<IdentityDevice>? devices,
    DeviceService? service,
    List<DeviceService>? services,
    String? message,
    bool? isRegistered,
    String? error,
    SavedDeviceIdentity? savedDeviceIdentity,
    bool clearDevice = false,
    bool clearDevices = false,
    bool clearService = false,
    bool clearServices = false,
    bool clearMessage = false,
    bool clearError = false,
    bool clearSavedDeviceIdentity = false,
  }) {
    return IdentityState(
      status: status ?? this.status,
      device: clearDevice ? null : (device ?? this.device),
      devices: clearDevices ? const [] : (devices ?? this.devices),
      isRegistered: isRegistered ?? this.isRegistered,
      service: clearService ? null : (service ?? this.service),
      services: clearServices ? const [] : (services ?? this.services),
      message: clearMessage ? null : (message ?? this.message),
      error: clearError ? null : (error ?? this.error),
      savedDeviceIdentity: clearSavedDeviceIdentity
          ? null
          : (savedDeviceIdentity ?? this.savedDeviceIdentity),
    );
  }

  factory IdentityState.initial() {
    return const IdentityState();
  }


  Map<String, dynamic> toJson() {
    return {
      'status': status.toString(),
      'device': device?.toJson(),
      'devices': devices.map((d) => d.toJson()).toList(),
      'isRegistered': isRegistered,
      'service': service?.toJson(),
      'services': services.map((s) => s.toJson()).toList(),
      'message': message,
      'error': error,
      'savedDeviceIdentity': savedDeviceIdentity?.toJson(),
    };
  }

  factory IdentityState.fromJson(Map<String, dynamic> json) {
    return IdentityState(
      status: IdentityStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => IdentityStatus.initial,
      ),
      device: json['device'] != null
          ? IdentityDevice.fromJson(json['device'])
          : null,
      devices: (json['devices'] as List<dynamic>?)
              ?.map((d) => IdentityDevice.fromJson(d))
              .toList() ??
          [],
      isRegistered: json['isRegistered'] ?? false,
      service: json['service'] != null
          ? DeviceService.fromJson(json['service'])
          : null,
      services: (json['services'] as List<dynamic>?)
              ?.map((s) => DeviceService.fromJson(s))
              .toList() ??
          [],
      message: json['message'],
      error: json['error'],
      savedDeviceIdentity: json['savedDeviceIdentity'] != null
          ? SavedDeviceIdentity.fromJson(json['savedDeviceIdentity'])
          : null,
    );
  }
}
