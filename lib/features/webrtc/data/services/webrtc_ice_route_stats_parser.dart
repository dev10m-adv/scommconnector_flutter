import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../domain/entities/webrtc_ice_route.dart';

class WebRtcIceRouteStatsParser {
  const WebRtcIceRouteStatsParser();

  WebRtcIceRoute parse(List<StatsReport> reports) {
    if (reports.isEmpty) {
      return const WebRtcIceRoute();
    }

    final reportsById = <String, StatsReport>{
      for (final report in reports) report.id: report,
    };

    final selectedPairId = _findSelectedPairId(reports);
    final candidatePair = selectedPairId == null
        ? _findSelectedCandidatePair(reports)
        : reportsById[selectedPairId] ?? _findSelectedCandidatePair(reports);
    if (candidatePair == null) {
      return const WebRtcIceRoute();
    }

    final localCandidateId = _asString(
      candidatePair.values['localCandidateId'],
    );
    final remoteCandidateId = _asString(
      candidatePair.values['remoteCandidateId'],
    );
    final localCandidate = localCandidateId == null
        ? null
        : reportsById[localCandidateId];
    final remoteCandidate = remoteCandidateId == null
        ? null
        : reportsById[remoteCandidateId];

    final localType = _parseCandidateType(
      localCandidate?.values['candidateType'],
    );
    final remoteType = _parseCandidateType(
      remoteCandidate?.values['candidateType'],
    );

    return WebRtcIceRoute(
      routeType: _classifyRoute(localType, remoteType),
      localCandidateType: localType,
      remoteCandidateType: remoteType,
      localProtocol: _asString(localCandidate?.values['protocol']),
      remoteProtocol: _asString(remoteCandidate?.values['protocol']),
      candidatePairId: candidatePair.id,
    );
  }

  String? _findSelectedPairId(List<StatsReport> reports) {
    for (final report in reports) {
      if (report.type != 'transport') {
        continue;
      }
      final selectedPairId = _asString(
        report.values['selectedCandidatePairId'],
      );
      if (selectedPairId != null && selectedPairId.isNotEmpty) {
        return selectedPairId;
      }
    }
    return null;
  }

  StatsReport? _findSelectedCandidatePair(List<StatsReport> reports) {
    for (final report in reports) {
      if (report.type != 'candidate-pair') {
        continue;
      }
      if (_asBool(report.values['selected']) ||
          _asBool(report.values['nominated'])) {
        return report;
      }
    }
    return null;
  }

  WebRtcIceRouteType _classifyRoute(
    WebRtcIceCandidateType localType,
    WebRtcIceCandidateType remoteType,
  ) {
    if (localType == WebRtcIceCandidateType.relay ||
        remoteType == WebRtcIceCandidateType.relay) {
      return WebRtcIceRouteType.relay;
    }

    if (localType == WebRtcIceCandidateType.srflx ||
        remoteType == WebRtcIceCandidateType.srflx ||
        localType == WebRtcIceCandidateType.prflx ||
        remoteType == WebRtcIceCandidateType.prflx) {
      return WebRtcIceRouteType.srflx;
    }

    if (localType == WebRtcIceCandidateType.host &&
        remoteType == WebRtcIceCandidateType.host) {
      return WebRtcIceRouteType.host;
    }

    return WebRtcIceRouteType.unknown;
  }

  WebRtcIceCandidateType _parseCandidateType(Object? rawValue) {
    final normalized = _asString(rawValue)?.toLowerCase().trim();
    switch (normalized) {
      case 'host':
        return WebRtcIceCandidateType.host;
      case 'srflx':
        return WebRtcIceCandidateType.srflx;
      case 'prflx':
        return WebRtcIceCandidateType.prflx;
      case 'relay':
        return WebRtcIceCandidateType.relay;
      default:
        return WebRtcIceCandidateType.unknown;
    }
  }

  bool _asBool(Object? value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final normalized = value.toLowerCase().trim();
      return normalized == 'true' || normalized == '1';
    }
    return false;
  }

  String? _asString(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is String) {
      return value;
    }
    return value.toString();
  }
}
