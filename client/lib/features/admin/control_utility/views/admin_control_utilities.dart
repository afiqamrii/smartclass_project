import 'package:skeletonizer/skeletonizer.dart';
import 'package:smartclass_fyp_2024/features/admin/control_utility/views/admin_add_utility.dart';
import 'package:smartclass_fyp_2024/shared/widgets/pageTransition.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/features/admin/constants/control_utility_card.dart';
import 'package:smartclass_fyp_2024/features/admin/control_utility/providers/utlity_providers.dart';
import 'package:smartclass_fyp_2024/shared/WebSocket/provider/socket_provider.dart';
import 'package:smartclass_fyp_2024/shared/data/dataprovider/user_provider.dart';

class AdminControlUtilities extends ConsumerStatefulWidget {
  const AdminControlUtilities({
    super.key,
    required this.classroomId,
    required this.classroomName,
    required this.classroomDevId,
    required this.esp32Id,
  });
  final String classroomName;
  final int classroomId;
  final String classroomDevId;
  final String esp32Id; // This is the esp32_id from the classroom

  @override
  ConsumerState<AdminControlUtilities> createState() =>
      _AdminControlUtilitiesState();
}

class _AdminControlUtilitiesState extends ConsumerState<AdminControlUtilities> {
  late IO.Socket socket;
  int totalUtilities = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(
      () {
        final user = ref.read(userProvider);
        final socketService = ref.read(socketServiceProvider.notifier);
        socketService.init(user.externalId); // already handled check inside

        socket = ref.read(socketServiceProvider)!;

        // Load initial utility data
        ref.read(utilityProvider.notifier).loadUtilities(widget.classroomId);

        // Listen for utility updates
        socket.off('utility_status_update');
        socket.on(
          'utility_status_update',
          (data) {
            final int receivedClassroomId = data['classroomId'];

            if (receivedClassroomId == widget.classroomId) {
              ref
                  .read(utilityProvider.notifier)
                  .updateUtilityStatusByClassroomId(
                    classroomId: receivedClassroomId,
                    newStatus: data['utilityStatus'],
                  );

              // ✅ Removed this line to prevent re-fetching and flickering
              // ref.read(utilityProvider.notifier).loadUtilities(widget.classroomId);
            }
          },
        );
      },
    );
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 5.0, left: 10.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              utilities.isEmpty
                  ? Center(
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 300,
                            child: Text(
                              'No devices registered for ${widget.classroomName} yet. Register now !',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // _addUtilitySection(context),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        left: 5.0,
                        bottom: 5,
                      ),
                      child: Text(
                        'Total Utilities: ${utilities.length}/4',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ),
              //NOtes that tell using only 4 utilities can be added
              if (utilities.length >= 4)
                const Padding(
                  padding: EdgeInsets.only(left: 5.0, bottom: 10.0),
                  child: Text(
                    'Notes : You can only add 4 utilities per classroom.',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ),
              Wrap(
                spacing: 2.0,
                runSpacing: 8.0,
                children: [
                  ...utilities.map(
                    (utility) {
                      return ControlUtilityCard(
                        title: utility.utilityName,
                        subtitle: utility.utilityType,
                        imagePath: utility.utilityType,
                        initialStatus:
                            utility.utilityStatus == 'ON' ? true : false,
                        utilityId: utility.utilityId,
                        classroomId: widget.classroomId,
                        deviceId: utility.deviceId,
                      );
                    },
                  ),
                  if (utilities.length < 4)
                    utilities.length < 4
                        ? _addUtilitySection(context)
                        : const SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _addUtilitySection(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Navigate to add utility screen and wait for result
        final result = await Navigator.push(
          context,
          toLeftTransition(
            AdminAddUtility(
              classroomId: widget.classroomId,
              classroomName: widget.classroomName,
              classroomDevId: widget.classroomDevId,
              esp32Id: widget.esp32Id,
            ),
          ),
        );
        // Force refresh utilities after returning
        if (result == true) {
          ref.read(utilityProvider.notifier).loadUtilities(widget.classroomId);
        }
      },
      child: const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              Icon(
                Icons.add_circle_outline,
                size: 28,
                color: Colors.grey,
              ),
              SizedBox(height: 6),
              Text(
                "Add more Utility / Device",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
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
