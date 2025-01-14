import 'package:flutter/material.dart';

class LecturerEditProfile extends StatelessWidget {
  const LecturerEditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                SizedBox(width: 5),
                Text(
                  "Back",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 19,
          ),
        ),
        centerTitle: true,
      ),
      body: const SizedBox(
        height: 20,
        child: Column(
          children: [
            //Input field to edit profiles
          ],
        ),
      ),
    );
  }
}
