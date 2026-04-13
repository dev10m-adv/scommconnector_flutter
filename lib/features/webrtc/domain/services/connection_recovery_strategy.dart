import 'dart:async';

import '../../../../core/errors/errors.dart';
import '../../domain/entities/webrtc_session_description.dart';
import '../../domain/usecases/close_webrtc_usecase.dart';
import '../../domain/usecases/restart_ice_and_create_offer_usecase.dart';

/// Defines WebRTC connection recovery behavior.
abstract class IConnectionRecoveryStrategy {
  /// Attempt to recover the connection using ICE restart.
  ///
  /// Returns the new offer SDP if successful.
  /// Throws [ServerException] if recovery fails after retries.
  Future<WebRtcSessionDescription> recover({required String sessionId});

  /// Check if recovery is currently in progress.
  bool get isRecovering;
}

/// Default recovery strategy using ICE restart with retries.
class ConnectionRecoveryStrategy implements IConnectionRecoveryStrategy {
  static const _retrySchedule = <Duration>[
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 4),
  ];

  final RestartIceAndCreateOfferUseCase restartIceAndCreateOfferUseCase;
  final CloseWebRtcUseCase closeWebRtcUseCase;
  bool _isRecovering = false;

  /// Callback for logging/state updates during recovery attempts.
  final Future<void> Function(int attemptNumber, bool hasInternet)?
  onRecoveryAttempt;

  ConnectionRecoveryStrategy({
    required this.restartIceAndCreateOfferUseCase,
    required this.closeWebRtcUseCase,
    this.onRecoveryAttempt,
  });

  @override
  bool get isRecovering => _isRecovering;

  @override
  Future<WebRtcSessionDescription> recover({required String sessionId}) async {
    if (_isRecovering) {
      throw const ServerException(message: 'Recovery already in progress.');
    }

    _isRecovering = true;
    try {
      return await _attemptRecovery(sessionId: sessionId);
    } finally {
      _isRecovering = false;
    }
  }

  Future<WebRtcSessionDescription> _attemptRecovery({required String sessionId}) async {
    for (var attempt = 0; attempt < _retrySchedule.length; attempt++) {
      try {
        await onRecoveryAttempt?.call(attempt + 1, true);
        return await restartIceAndCreateOfferUseCase.call(sessionId: sessionId);
      } catch (_) {
        if (attempt == _retrySchedule.length - 1) {
          // Final attempt failed
          await closeWebRtcUseCase.call(sessionId: sessionId);
          throw const ServerException(
            message: 'WebRTC recovery failed after multiple attempts.',
          );
        }

        // Wait before retry
        await Future<void>.delayed(_retrySchedule[attempt]);
      }
    }

    // Should not reach
    throw const ServerException(message: 'Connection recovery exhausted.');
  }
}
