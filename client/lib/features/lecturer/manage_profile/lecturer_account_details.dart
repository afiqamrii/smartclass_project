import 'package:flutter/material.dart';

class LecturerAccountDetails extends StatelessWidget {
  const LecturerAccountDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: _appBar(),
      body: _accountDetailsSection(),
    );
  }

  Padding _accountDetailsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const IntrinsicHeight(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 23.0, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Username section here
                    Text(
                      "Username",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "afiqamrii03",
                    ),
                  ],
                ),
                SizedBox(height: 5),
                //Make a horizontal line here
                Divider(
                  color: Colors.black,
                  thickness: 0.5,
                ),
                SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Username section here
                    Text(
                      "Full Name",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "afiqamrii03",
                    ),
                  ],
                ),
                SizedBox(height: 5),
                //Make a horizontal line here
                Divider(
                  color: Colors.black,
                  thickness: 0.5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        "Account Details",
        style: TextStyle(
          fontSize: 19,
        ),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xffF5F5F5),
    );
  }
}
