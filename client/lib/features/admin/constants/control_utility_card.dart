import 'package:flutter/material.dart';

class ControlUtilityCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final bool initialStatus;

  const ControlUtilityCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
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
