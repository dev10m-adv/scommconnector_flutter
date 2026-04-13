import 'dart:async';
import 'package:scommconnector/core/logging/log.dart';

//// [TODO:] If Needed to care about internet connectivity {COMPLETE THIS}
/// Callback when recovery is triggered (e.g., internet status changed).
typedef OnRecoveryNeeded = Future<void> Function();

/// Monitors internet status and triggers recovery on connection changes.
///
/// Single Responsibility: Handle internet-aware resilience and recovery triggers.
/// Dependency Inversion: Depends on ISInternetConnectionMonitor abstraction (not concrete InternetConnection).
abstract class IOnlineAwareResilience {
  /// Start monitoring internet status.
  ///
  /// - [onRecoveryNeeded]: Called when internet is restored after disconnection
  /// - [shouldAutoRecover]: Filter function to decide if recovery should trigger
  Future<void> startMonitoring({
    required OnRecoveryNeeded onRecoveryNeeded,
    bool Function()? shouldAutoRecover,
  });

  /// Stop monitoring internet status.
  Future<void> stopMonitoring();

  /// Check if device currently has internet access.
  Future<bool> hasInternetAccess();
}

/// Default implementation monitoring InternetConnection status.
class OnlineAwareResilience implements IOnlineAwareResilience {
  OnRecoveryNeeded? _onRecoveryNeeded;
  bool Function()? _shouldAutoRecover;
  OnlineAwareResilience();

  @override
  Future<void> startMonitoring({
    required OnRecoveryNeeded onRecoveryNeeded,
    bool Function()? shouldAutoRecover,
  }) async {
    _onRecoveryNeeded = onRecoveryNeeded;
    _shouldAutoRecover = shouldAutoRecover;
  }

  @override
  Future<void> stopMonitoring() async {
    _onRecoveryNeeded = null;
    _shouldAutoRecover = null;
    infoLog("_onRecoverNeeded : $_onRecoveryNeeded, _shouldAutoRecover: $_shouldAutoRecover");
    _handleStatusChange();
  }

  @override
  Future<bool> hasInternetAccess() => Future.value(true);

  Future<void> _handleStatusChange() async {
  }
}
