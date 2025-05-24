import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:smartclass_fyp_2024/constants/api_constants.dart';

class SocketService extends StateNotifier<IO.Socket?> {
  SocketService() : super(null);

  void init(String userId) {
    if (state != null) return; // Already initialized

    final socket = IO.io(
      ApiConstants.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print('✅ Socket connected');
      socket.emit('identify', userId);
    });

    socket.onDisconnect((_) => print('❌ Socket disconnected'));
    socket.onError((data) => print('⚠️ Socket error: $data'));

    state = socket;
  }

  void disposeSocket() {
    state?.disconnect();
    state?.dispose();
    state = null;
  }
}
