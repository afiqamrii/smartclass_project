import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothService {

  Future<List<BluetoothDevice>> scanForEspDevices({required Duration timeout}) async {
    List<BluetoothDevice> foundDevices = [];

    // Start scan
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));

    await for (List<ScanResult> results in FlutterBluePlus.scanResults) {
      for (final result in results) {
        // ignore: deprecated_member_use
        final name = result.device.name;
        if (name.startsWith('IntelliClass_ESP_')) {
          foundDevices.add(result.device);
        }
      }
    }

    FlutterBluePlus.stopScan();
    return foundDevices;
  }

  Stream<List<ScanResult>> get scanStream => FlutterBluePlus.scanResults;
  
  void startScan() {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
  }

  void stopScan() {
    FlutterBluePlus.stopScan();
  }
}
