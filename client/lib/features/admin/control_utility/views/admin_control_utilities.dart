import 'package:flutter/material.dart';
import 'package:smartclass_fyp_2024/features/admin/constants/control_utility_card.dart';

class AdminControlUtilities extends StatefulWidget {
  const AdminControlUtilities({super.key});

  @override
  State<AdminControlUtilities> createState() => _AdminControlUtilitiesState();
}

class _AdminControlUtilitiesState extends State<AdminControlUtilities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: const Padding(
        padding: EdgeInsets.only(
          right: 5.0,
          left: 10.0,
        ),
        child: Wrap(
          spacing: 2.0, // Horizontal space between cards
          runSpacing: 8.0, // Vertical space between cards
          children: [
            ControlUtilityCard(
              title: 'Lighting',
              subtitle: '4 lamps',
              imagePath: 'assets/icons/bulb.png',
              initialStatus: true,
            ),
            ControlUtilityCard(
              title: 'Fan',
              subtitle: '2 fans',
              imagePath: 'assets/icons/fan.png',
              initialStatus: false,
            ),
          ],
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
