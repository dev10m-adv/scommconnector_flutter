class ConnectSessionState {
  String? _localUri;
  String? _remoteUri;
  String? _activeRequestId;

  String? get localUri => _localUri;
  String? get remoteUri => _remoteUri;
  String? get activeRequestId => _activeRequestId;

  void initializeLocalUri(String localUri) {
    _localUri = localUri;
  }

  void beginNegotiation({
    required String remoteUri,
    required String requestId,
  }) {
    _remoteUri = remoteUri;
    _activeRequestId = requestId;
  }

  void clearRemoteSession() {
    _remoteUri = null;
    _activeRequestId = null;
  }

  String requireLocalUri() {
    final localUri = _localUri;
    if (localUri == null || localUri.isEmpty) {
      throw StateError('Local URI is not initialized.');
    }
    return localUri;
  }
}
