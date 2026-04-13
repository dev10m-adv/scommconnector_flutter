import 'package:scommconnector/features/webrtc/webrtc.dart';

class WebRtcSessionManager {
  final WebRtcRepository Function() _createRepository;
  final Map<String, WebRtcRepository> _repositories = {};

  WebRtcSessionManager({
    required WebRtcRepository Function() createRepository,
  }) : _createRepository = createRepository;

  WebRtcRepository getOrCreate(String sessionId) {
    return _repositories.putIfAbsent(sessionId, _createRepository);
  }

  WebRtcRepository? getOrNull(String sessionId) {
    return _repositories[sessionId];
  }

  bool hasSession(String sessionId) {
    return _repositories.containsKey(sessionId);
  }

  List<String> get activeSessionIds => _repositories.keys.toList(growable: false);

  Future<void> closeSession(String sessionId) async {
    final repo = _repositories.remove(sessionId);
    if (repo == null) return;
    await repo.close();
    await repo.dispose();
  }

  Future<void> closeAll() async {
    final repos = _repositories.values.toList(growable: false);
    _repositories.clear();

    for (final repo in repos) {
      await repo.close();
      await repo.dispose();
    }
  }
}