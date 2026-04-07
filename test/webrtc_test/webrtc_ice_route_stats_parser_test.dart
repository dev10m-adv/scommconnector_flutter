import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:scommconnector/features/webrtc/data/services/webrtc_ice_route_stats_parser.dart';
import 'package:scommconnector/features/webrtc/domain/entities/webrtc_ice_route.dart';
import 'package:test/test.dart';

void main() {
  group('WebRtcIceRouteStatsParser', () {
    const parser = WebRtcIceRouteStatsParser();

    test('classifies host route from selected candidate pair', () {
      final route = parser.parse([
        StatsReport('transport-1', 'transport', 0, {
          'selectedCandidatePairId': 'pair-1',
        }),
        StatsReport('pair-1', 'candidate-pair', 0, {
          'localCandidateId': 'local-1',
          'remoteCandidateId': 'remote-1',
        }),
        StatsReport('local-1', 'local-candidate', 0, {
          'candidateType': 'host',
          'protocol': 'udp',
        }),
        StatsReport('remote-1', 'remote-candidate', 0, {
          'candidateType': 'host',
          'protocol': 'udp',
        }),
      ]);

      expect(route.routeType, WebRtcIceRouteType.host);
      expect(route.localCandidateType, WebRtcIceCandidateType.host);
      expect(route.remoteCandidateType, WebRtcIceCandidateType.host);
      expect(route.localProtocol, 'udp');
      expect(route.remoteProtocol, 'udp');
    });

    test('classifies srflx route when either side uses srflx or prflx', () {
      final route = parser.parse([
        StatsReport('pair-2', 'candidate-pair', 0, {
          'selected': true,
          'localCandidateId': 'local-2',
          'remoteCandidateId': 'remote-2',
        }),
        StatsReport('local-2', 'local-candidate', 0, {
          'candidateType': 'prflx',
        }),
        StatsReport('remote-2', 'remote-candidate', 0, {
          'candidateType': 'host',
        }),
      ]);

      expect(route.routeType, WebRtcIceRouteType.srflx);
      expect(route.localCandidateType, WebRtcIceCandidateType.prflx);
      expect(route.remoteCandidateType, WebRtcIceCandidateType.host);
    });

    test('classifies relay route when selected pair uses relay candidate', () {
      final route = parser.parse([
        StatsReport('transport-3', 'transport', 0, {
          'selectedCandidatePairId': 'pair-3',
        }),
        StatsReport('pair-3', 'candidate-pair', 0, {
          'localCandidateId': 'local-3',
          'remoteCandidateId': 'remote-3',
        }),
        StatsReport('local-3', 'local-candidate', 0, {
          'candidateType': 'relay',
        }),
        StatsReport('remote-3', 'remote-candidate', 0, {
          'candidateType': 'srflx',
        }),
      ]);

      expect(route.routeType, WebRtcIceRouteType.relay);
      expect(route.localCandidateType, WebRtcIceCandidateType.relay);
      expect(route.remoteCandidateType, WebRtcIceCandidateType.srflx);
    });

    test('returns unknown when no selected candidate pair exists', () {
      final route = parser.parse([
        StatsReport('pair-4', 'candidate-pair', 0, {
          'localCandidateId': 'local-4',
          'remoteCandidateId': 'remote-4',
        }),
      ]);

      expect(route, const WebRtcIceRoute());
    });
  });
}
