class ScommTransferSpeed {
  final int sentBytesPerSecond;
  final int receivedBytesPerSecond;

  const ScommTransferSpeed({
    this.sentBytesPerSecond = 0,
    this.receivedBytesPerSecond = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'sentBytesPerSecond': sentBytesPerSecond,
      'receivedBytesPerSecond': receivedBytesPerSecond,
    };
  }
}
