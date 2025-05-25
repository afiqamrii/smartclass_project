import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/shared/WebSocket/socket_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final socketServiceProvider = StateNotifierProvider<SocketService, IO.Socket?>(
  (ref) => SocketService(),
);
