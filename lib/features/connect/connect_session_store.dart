import 'connect_session.dart';

class ConnectSessionStore {
  final Map<String, ConnectSession> _sessions = {};

  ConnectSession save(ConnectSession session) {
    _sessions[session.sessionId] = session;
    return session;
  }

  ConnectSession? getBySessionId(String sessionId) {
    return _sessions[sessionId];
  }

  ConnectSession? getByRequestId(String requestId) {
    return _sessions[requestId];
  }

  ConnectSession? getByRemoteUri(String remoteUri) {
    for (final session in _sessions.values) {
      if (session.remoteUri == remoteUri) return session;
    }
    return null;
  }

  List<String> get sessionIds => _sessions.keys.toList(growable: false);

  ConnectSession? remove(String sessionId) {
    return _sessions.remove(sessionId);
  }

  Iterable<ConnectSession> get all => _sessions.values;

  Future<void> clear() async {
    final sessions = _sessions.values.toList(growable: false);
    _sessions.clear();
    for (final session in sessions) {
      await session.dispose();
    }
  }
}