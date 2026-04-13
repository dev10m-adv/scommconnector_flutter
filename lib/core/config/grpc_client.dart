import 'package:grpc/grpc.dart';

ClientChannel createGrpcClient(String host, int port, {bool useTls = false}) {
  return ClientChannel(
    host,
    port: port,
    options: ChannelOptions(
      credentials: useTls
          ? const ChannelCredentials.secure()
          : const ChannelCredentials.insecure(),
    ),
  );
}