import 'package:flutter/material.dart';
import 'package:smartclass_fyp_2024/features/admin/control_utility/services/utility_service.dart';

class ControlUtilityCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final bool initialStatus;
  final int utilityId;
  final int classroomId;
  final String deviceId;

  const ControlUtilityCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.utilityId,
    required this.classroomId,
    required this.deviceId,
    this.initialStatus = false,
  });

  @override
  State<ControlUtilityCard> createState() => _ControlUtilityCardState();
}

class _ControlUtilityCardState extends State<ControlUtilityCard> {
  bool isOn = false;

  @override
  void initState() {
    super.initState();
    isOn = widget.initialStatus;
  }

  void sendToBackend(
      String newStatus, int utilityId, int classroomId, String deviceId) {
    // Send the updated status to the backend
    UtilityService.updateUtilityStatus(
      utilityId,
      newStatus,
      classroomId,
      deviceId,
    ).then((_) {
      setState(() {
        //If the backend update is successful, update the local state
        // This will ensure the UI reflects the new status
        // Update the local state based on the new status
        //If the new status is "ON", set isOn to true, otherwise set it to false
        isOn = newStatus == "ON";
      });
    });
  }

  //Decide the image path based on the utility type
  String getImagePath() {
    switch (widget.imagePath.toLowerCase()) {
      case 'light':
        return 'assets/icons/bulb.png';
      case 'fan':
        return 'assets/icons/fan.png';
      case 'aircond':
        return 'assets/icons/ac.png';
      case 'others':
        return 'assets/icons/bulb.png';
      default:
        return 'assets/icons/bulb.png'; // Fallback to provided image path
    }
  }

  @override
  Widget build(BuildContext context) {
    Color activeBackground = Colors.black;
    Color inactiveBackground = Colors.grey.shade100;
    Color activeText = Colors.white;
    Color inactiveText = Colors.black;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: isOn ? activeBackground : inactiveBackground,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.43,
        height: 170,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.black45,
              child: Image.asset(
                getImagePath(),
                width: 22,
                height: 22,
                color: Colors.white,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                    color: isOn ? activeText : inactiveText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: isOn ? activeText.withOpacity(0.7) : Colors.black54,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isOn ? 'On' : 'Off',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isOn ? activeText : inactiveText,
                  ),
                ),
                Switch(
                  value: isOn,
                  onChanged: (value) {
                    setState(() {
                      isOn = value;
                    });
                    //here if user manually toggles the switch
                    //Toogle the utility status in the backend
                    //Toggle on , send 'ON' to the backend
                    if (isOn) {
                      // Code to turn on the utility
                      sendToBackend("ON", widget.utilityId, widget.classroomId,
                          widget.deviceId);
                    } else {
                      // Code to turn off the utility
                      sendToBackend("OFF", widget.utilityId, widget.classroomId,
                          widget.deviceId);
                    }
                  },
                  activeColor: Colors.white,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey.shade400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
