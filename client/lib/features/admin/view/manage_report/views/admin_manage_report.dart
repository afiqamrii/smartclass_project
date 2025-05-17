import 'package:flutter/material.dart';

class AdminManageReport extends StatelessWidget {
  const AdminManageReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Report"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          alignment: WrapAlignment.start,
          spacing: 8.0, // Horizontal space between cards
          runSpacing: 8.0, // Vertical space between cards
          children: List.generate(10, (index) {
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: 150, // Set the card width
                height: 100, // Set the card height
                alignment: Alignment.center,
                child: Text('Card $index'),
              ),
            );
          }),
        ),
      ),
      // bottomNavigationBar: const LectBottomNavBar(initialIndex: 1),
    );
  }
}
