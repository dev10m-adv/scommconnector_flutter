import '../../domain/entities/device_service.dart';
import '../../domain/entities/identity_device.dart';
import '../../domain/entities/saved_device_identity.dart';

enum IdentityStatus { initial, loading, success, failure }

class IdentityState {
  final IdentityStatus status;
  final IdentityDevice? device;
  final List<IdentityDevice> devices;
  final DeviceService? service;
  final List<DeviceService> services;
  final String? message;
  final String? error;
  final SavedDeviceIdentity? savedDeviceIdentity;

  const IdentityState({
    this.status = IdentityStatus.initial,
    this.device,
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
      service: clearService ? null : (service ?? this.service),
      services: clearServices ? const [] : (services ?? this.services),
      message: clearMessage ? null : (message ?? this.message),
      error: clearError ? null : (error ?? this.error),
      savedDeviceIdentity: clearSavedDeviceIdentity
          ? null
          : (savedDeviceIdentity ?? this.savedDeviceIdentity),
    );
  }
}
