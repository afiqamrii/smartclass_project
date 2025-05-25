import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:smartclass_fyp_2024/constants/api_constants.dart';

class SocketService extends StateNotifier<IO.Socket?> {
  SocketService() : super(null);

  void init(String userId) {
    // Allow re-initialization for robustness
    if (state != null) {
      print('⚠️ Socket already initialized');
      return;
    }

    final socket = IO.io(
      ApiConstants.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket']) // Required for Flutter
          .disableAutoConnect() // We'll manually connect
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
    if (state != null) {
      print('🔌 Disposing socket...');
      state!.disconnect();
      state = null;
    }
  }
}
