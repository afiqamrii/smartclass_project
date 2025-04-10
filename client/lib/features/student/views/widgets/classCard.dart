import 'package:flutter/material.dart';

class ClassCard extends StatelessWidget {
  final String className;
  final String lecturerName;
  final String summaryAvailablity;

  const ClassCard({
    super.key,
    required this.className,
    required this.lecturerName,
    required this.summaryAvailablity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 10),
      color: const Color.fromARGB(255, 255, 249, 249),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage('assets/pictures/logo.png'),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Class name
                  Text(
                    className,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontFamily: 'Figtree',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  //Lecturer name
                  Text(
                    lecturerName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Figtree',
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 10),
                  //Summary availability
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      summaryAvailablity,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Figtree',
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
