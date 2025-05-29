import 'package:flutter/material.dart';
import 'package:smartclass_fyp_2024/constants/color_constants.dart';
import 'package:smartclass_fyp_2024/features/admin/control_utility/services/utility_service.dart';
import 'package:smartclass_fyp_2024/bluetooth/bluetooth_services.dart'
    as my_bluetooth;

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
  final TextEditingController _esp32IdController = TextEditingController();
  final TextEditingController _deviceNameController = TextEditingController();
  final TextEditingController _customTypeController = TextEditingController();

  String? _selectedType;
  final my_bluetooth.BluetoothService _bluetoothService =
      my_bluetooth.BluetoothService();
  bool _isScanning = false;
  bool _showScanDialog = false;

  final List<String> utilityTypes = [
    'Light',
    'Fan',
    'Aircond',
    'Projector',
    'Smartboard',
    'Others',
  ];

  void addUtility(String esp32Id, String deviceName, String selectedType,
      int classroomId, String classdevId) {
    if (_formKey.currentState!.validate()) {
      UtilityService.addUtility(
          esp32Id, selectedType, classroomId, classdevId, context);
    }
  }

  Future<void> _scanBluetoothDevices() async {
    setState(() {
      _isScanning = true;
      _showScanDialog = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Scanning for ESP32 Devices...'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Please wait while we search for IntelliClass ESP32 devices.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _bluetoothService.stopScan();
              Navigator.of(context).pop();
              setState(() {
                _isScanning = false;
                _showScanDialog = false;
              });
            },
            child: const Text('Cancel'),
          )
        ],
      ),
    );

    try {
      final devices = await _bluetoothService.scanForEspDevices(
        timeout: const Duration(seconds: 15),
      );
      if (!_showScanDialog) return;

      Navigator.of(context).pop(); // close dialog

      if (devices.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'No IntelliClass ESP32 devices found within timeout.')),
          );
        }
      } else {
        final device = devices.first;
        String extractedId =
            device.platformName.replaceFirst('IntelliClass_ESP_', '');
        setState(() {
          _esp32IdController.text = extractedId;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Found and selected device: $extractedId')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during scan: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
          _showScanDialog = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isOtherSelected = _selectedType == 'Others';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildLabel('Utility Name'),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _deviceNameController,
                hint: 'e.g. Aircond 1 / Light Near Door',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a name for this utility'
                    : null,
              ),
              const SizedBox(height: 20),
              _buildLabel('ESP32 ID'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _esp32IdController,
                      hint: 'Scan to autofill ESP32 ID',
                      validator: (value) => value == null || value.isEmpty
                          ? 'ESP32 ID is required'
                          : null,
                      enabled: false,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: _isScanning ? null : _scanBluetoothDevices,
                    icon: const Icon(Icons.bluetooth_searching),
                    tooltip: 'Scan for ESP32 device',
                    color: ColorConstants.primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildLabel('Classroom'),
              const SizedBox(height: 10),
              _buildReadOnlyBox(widget.classroomName),
              const SizedBox(height: 20),
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.primaryColor,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final esp32Id = _esp32IdController.text;
                    final deviceName = _deviceNameController.text;
                    final selectedType = isOtherSelected
                        ? _customTypeController.text.trim()
                        : _selectedType!;
                    addUtility(esp32Id, deviceName, selectedType,
                        widget.classroomId, widget.classroomDevId);
                  }
                },
                child: const Text(
                  'Add Utility',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text,
        style: const TextStyle(
            fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      style: const TextStyle(color: Colors.black, fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none),
      ),
      validator: validator,
    );
  }

  Widget _buildReadOnlyBox(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
          color: Colors.grey.shade100, borderRadius: BorderRadius.circular(14)),
      child: Text(value, style: const TextStyle(fontSize: 13)),
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
            borderSide: BorderSide.none),
      ),
      hint:
          Text(hint, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      onChanged: onChanged,
      items: items.map((type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type, style: const TextStyle(fontSize: 14)),
        );
      }).toList(),
      validator: validator,
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        "Add Utility / Device",
        style: TextStyle(
            fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
