import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class BluetoothService {
  // Scan and return list of devices with names starting with 'IntelliClass_ESP_'
  Future<List<BluetoothDevice>> scanForEspDevices({
    required Duration timeout,
  }) async {
    List<BluetoothDevice> foundDevices = [];

    // 1. Request required permissions (especially for Android 12+)
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.location.request();

    if (!(await Permission.location.serviceStatus.isEnabled)) {
      throw Exception(
          'Please enable Location Services (GPS) to scan for Bluetooth devices.');
    }

    // 2. Start scanning
    await FlutterBluePlus.startScan(timeout: timeout);

    // 3. Listen to scan results
    final subscription = FlutterBluePlus.scanResults.listen((results) {
      for (final result in results) {
        final name = result.device.name;
        if (name.startsWith('IntelliClass_ESP_') &&
            !foundDevices.contains(result.device)) {
          foundDevices.add(result.device);
        }
      }
    });

    // 4. Wait for the scan to complete
    await Future.delayed(timeout);

    // 5. Stop scanning and clean up
    await FlutterBluePlus.stopScan();
    await subscription.cancel();

    return foundDevices;
  }

  // Start scanning manually with optional timeout
  Future<void> startScan(
      {Duration timeout = const Duration(seconds: 5)}) async {
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.location.request();

    if (!(await Permission.location.serviceStatus.isEnabled)) {
      throw Exception(
          'Please enable Location Services (GPS) to scan for Bluetooth devices.');
    }

    await FlutterBluePlus.startScan(timeout: timeout);
  }

  // Stop scanning
  void stopScan() {
    FlutterBluePlus.stopScan();
  }

  // Get scan result stream (in case needed externally)
  Stream<List<ScanResult>> get scanStream => FlutterBluePlus.scanResults;
}
