import 'package:flutter/material.dart';
import 'package:smartclass_fyp_2024/features/admin/control_utility/services/utility_service.dart';

class ControlUtilityCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final bool initialStatus;
  final int utilityId;
  final int classroomId;

  const ControlUtilityCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.utilityId,
    required this.classroomId,
    this.initialStatus = false,
  }) : super(key: key);

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

  void sendToBackend(String newStatus, int utilityId, int classroomId) {
    // Send the updated status to the backend
    UtilityService.updateUtilityStatus(
      utilityId,
      newStatus,
      classroomId,
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

  @override
  Widget build(BuildContext context) {
    Color activeBackground = Colors.black;
    Color inactiveBackground = Colors.grey.shade100;
    Color activeText = Colors.white;
    Color inactiveText = Colors.black;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                widget.imagePath,
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
                      sendToBackend("ON", widget.utilityId, widget.classroomId);
                    } else {
                      // Code to turn off the utility
                      sendToBackend(
                          "OFF", widget.utilityId, widget.classroomId);
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
