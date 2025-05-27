import 'package:flutter/material.dart';
import 'package:smartclass_fyp_2024/constants/color_constants.dart';
import 'package:smartclass_fyp_2024/features/admin/control_utility/services/utility_service.dart';

class AdminAddUtility extends StatefulWidget {
  final int classroomId;
  final String classroomName;
  final String classroomDevId;

  const AdminAddUtility({
    super.key,
    required this.classroomId,
    required this.classroomName,
    required this.classroomDevId,
  });

  @override
  State<AdminAddUtility> createState() => _AdminAddUtilityState();
}

class _AdminAddUtilityState extends State<AdminAddUtility> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _deviceNameController = TextEditingController();
  final TextEditingController _customTypeController = TextEditingController();

  String? _selectedType;

  // List of utility types
  final List<String> utilityTypes = [
    'Light',
    'Fan',
    'Aircond',
    'Projector',
    'Smartboard',
    'Others',
  ];

  // Function to add a new utility
  void addUtility(String deviceName, String selectedType, int classroomId,
      String classdevId) {
    if (_formKey.currentState!.validate()) {
      // Add the new utility to the database
      UtilityService.addUtility(
          deviceName, selectedType, classroomId, classdevId, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if 'Others' is selected
    final bool isOtherSelected = _selectedType == 'Others';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 10,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Utility Name
              _buildLabel('Utility Name'),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _deviceNameController,
                hint: 'e.g. Front Light, Main Fan',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter utility name'
                    : null,
              ),
              const SizedBox(height: 20),

              // Classroom
              _buildLabel('Classroom'),
              const SizedBox(height: 10),
              _buildReadOnlyBox(widget.classroomName), // Display classroom name
              const SizedBox(height: 20),

              // Utility Type Dropdown
              _buildLabel('Utility Type'),
              const SizedBox(height: 10),
              _buildDropdownField(
                value: _selectedType,
                items: utilityTypes,
                hint: 'Select utility type',
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a utility type' : null,
              ),
              const SizedBox(height: 20),

              // Custom Utility Type
              if (isOtherSelected) ...[
                _buildLabel('Custom Utility Type'),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: _customTypeController,
                  hint: 'e.g. Heater, Humidifier',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a custom utility type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
              ],

              // Submit Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.primaryColor,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final deviceName = _deviceNameController.text;
                    final selectedType = isOtherSelected
                        ? _customTypeController.text.trim()
                        : _selectedType!;

                    // Handle form submission here
                    addUtility(
                      deviceName,
                      selectedType,
                      widget.classroomId,
                      widget.classroomDevId,
                    );
                  }
                },
                child: const Text(
                  'Add Utility',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 13,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildReadOnlyBox(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required String hint,
    required void Function(String?) onChanged,
    required String? Function(String?) validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      hint: Center(
        child: Text(
          hint,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
      ),
      onChanged: onChanged,
      items: items.map((type) {
        return DropdownMenuItem<String>(
          value: type,
          enabled: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Text(
              type,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        );
      }).toList(),
      borderRadius: BorderRadius.circular(20),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        "Add Utility / Device",
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
}
