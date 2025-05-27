import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/features/admin/constants/control_utility_card.dart';
import 'package:smartclass_fyp_2024/features/admin/control_utility/providers/utlity_providers.dart';
import 'package:smartclass_fyp_2024/shared/WebSocket/provider/socket_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';

class AdminControlUtilities extends ConsumerStatefulWidget {
  const AdminControlUtilities({super.key, required this.classroomId});
  final int classroomId;

  @override
  ConsumerState<AdminControlUtilities> createState() =>
      _AdminControlUtilitiesState();
}

class _AdminControlUtilitiesState extends ConsumerState<AdminControlUtilities> {
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final user = ref.read(userProvider);
      final socketService = ref.read(socketServiceProvider.notifier);
      socketService.init(user.externalId); // already handled check inside

      socket = ref.read(socketServiceProvider)!;

      // Load initial utility data
      ref.read(utilityProvider.notifier).loadUtilities(widget.classroomId);

// Listen for utility updates
      socket.off('utility_status_update'); // avoid duplicates
      socket.on('utility_status_update', (data) {
        final int receivedClassroomId = data['classroomId'];

        if (receivedClassroomId == widget.classroomId) {
          ref.read(utilityProvider.notifier).updateUtilityStatusByClassroomId(
                classroomId: receivedClassroomId,
                newStatus: data['utilityStatus'],
              );
          ref.read(utilityProvider.notifier).loadUtilities(widget.classroomId);
        }
      });
    });
  }

  @override
  void dispose() {
    socket.off('utility_status_update');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Using Riverpod to watch the utilityRealtimeProvider
    final utilities = ref.watch(utilityProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.only(right: 5.0, left: 10.0),
        child: utilities.isEmpty
            ? const Center(
                child: Text(
                  'No devices registered for this class yet.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )
            : Wrap(
                spacing: 2.0,
                runSpacing: 8.0,
                children: utilities.map((utility) {
                  return ControlUtilityCard(
                    title: utility.utilityName,
                    subtitle: utility.deviceId,
                    imagePath: utility.utilityStatus == 'Lighting'
                        ? 'assets/icons/bulb.png'
                        : 'assets/icons/fan.png',
                    initialStatus: utility.utilityStatus == 'ON' ? true : false,
                  );
                }).toList(),
              ),
      ),
    );
  }
}

AppBar _appBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    title: const Text(
      "Control Utilities",
      style: TextStyle(
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    ),
    centerTitle: true,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back_ios,
        size: 20,
        color: Colors.black,
      ),
      onPressed: () => Navigator.pop(context),
    ),
  );
}
