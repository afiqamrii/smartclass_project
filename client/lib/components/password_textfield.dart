import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class PasswordTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  bool obscureText;
  bool isPasswordForm;
  bool isSignUpForm;
  String password;
  final String? Function(String?)? validator;

  PasswordTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.isPasswordForm,
    required this.isSignUpForm,
    required this.password,
    this.validator,
  });

  @override
  State<PasswordTextfield> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextfield> {
  final bool _validate = false;
  bool _isPasswordEightChars = false;
  bool _isPasswordHasUppercase = false;
  bool _isPasswordHasNumber = false;
  bool _isPasswordHasSpecialChar = false;

  void onPasswordChanged(String password) {
    setState(
      () {
        widget.password = password;

        _isPasswordEightChars = false;
        _isPasswordHasUppercase = false;
        _isPasswordHasNumber = false;
        _isPasswordHasSpecialChar = false;

        // Check if password is at least 8 characters long
        if (password.length >= 8) {
          _isPasswordEightChars = true;
        }

        // Check if password contains at least one uppercase letter
        if (password.contains(RegExp(r'[A-Z]'))) {
          _isPasswordHasUppercase = true;
        }

        // Check if password contains at least one number
        if (password.contains(RegExp(r'[0-9]'))) {
          _isPasswordHasNumber = true;
        }

        // Check if password contains at least one special character
        if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
          _isPasswordHasSpecialChar = true;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            onChanged: (password) => onPasswordChanged(password),
            controller: widget.controller,
            obscureText: widget.obscureText, // Hide password
            decoration: InputDecoration(
              suffixIcon: widget.isPasswordForm
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          widget.obscureText = !widget.obscureText;
                        });
                      },
                      icon: widget.obscureText
                          ? const Icon(
                              Icons.visibility_off,
                              color: Colors.grey,
                              size: 20,
                            )
                          : const Icon(
                              Icons.visibility,
                              size: 20,
                            ),
                    )
                  : null,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              errorText: _validate ? 'Value Can\'t Be Empty' : null,
            ),
            validator: widget.validator,
          ),
        ),
        if (widget.isSignUpForm) ...[
          const SizedBox(height: 5),

          //At least 8 characters
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 35,
                  height: 35,
                  child: _isPasswordEightChars
                      ? Center(
                          child: LottieBuilder.asset(
                            "assets/animations/passwordCheck.json",
                            width: 150,
                            height: 150,
                            repeat: false,
                            fit: BoxFit.fill,
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.grey,
                            size: 15,
                          ),
                        ),
                ),
                const SizedBox(width: 5),
                if (_isPasswordEightChars) ...[
                  Text(
                    "8-16 characters in length",
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                ] else ...[
                  Text(
                    "8-16 characters in length",
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                ]
              ],
            ),
          ),

          //Uppercase Check
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
            child: Row(
              children: [
                AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: 35,
                    height: 35,
                    child: _isPasswordHasUppercase
                        ? Center(
                            child: LottieBuilder.asset(
                              "assets/animations/passwordCheck.json",
                              width: 150,
                              height: 150,
                              repeat: false,
                              fit: BoxFit.fill,
                            ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.check,
                              color: Colors.grey,
                              size: 15,
                            ),
                          )),
                const SizedBox(width: 5),
                if (_isPasswordHasUppercase) ...[
                  Text(
                    "Uppercase Character",
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                ] else ...[
                  Text(
                    "Uppercase Character",
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                ]
              ],
            ),
          ),

          //Numeric Check
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 35,
                  height: 35,
                  child: _isPasswordHasNumber
                      ? Center(
                          child: LottieBuilder.asset(
                            "assets/animations/passwordCheck.json",
                            width: 150,
                            height: 150,
                            repeat: false,
                            fit: BoxFit.fill,
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.grey,
                            size: 15,
                          ),
                        ),
                ),
                const SizedBox(width: 5),
                if (_isPasswordHasNumber) ...[
                  Text(
                    "Numeric Character",
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                ] else ...[
                  Text(
                    "Numeric Character",
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                ]
              ],
            ),
          ),

          //Special Character Check
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 35,
                  height: 35,
                  child: _isPasswordHasSpecialChar
                      ? Center(
                          child: LottieBuilder.asset(
                              "assets/animations/passwordCheck.json",
                              width: 150,
                              height: 150,
                              repeat: false,
                              fit: BoxFit.fill),
                        )
                      : const Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.grey,
                            size: 15,
                          ),
                        ),
                ),
                const SizedBox(width: 5),
                if (_isPasswordHasSpecialChar) ...[
                  Text(
                    "Special Character",
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                ] else ...[
                  Text(
                    "Special Character",
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
