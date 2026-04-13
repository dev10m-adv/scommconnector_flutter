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

  factory ScommTransferSpeed.fromJson(Map<String, dynamic> json) {
    return ScommTransferSpeed(
      sentBytesPerSecond: json['sentBytesPerSecond'] ?? 0,
      receivedBytesPerSecond: json['receivedBytesPerSecond'] ?? 0,
    );
  }
}
