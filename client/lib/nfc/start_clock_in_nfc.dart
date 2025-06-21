import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nfc_host_card_emulation/nfc_host_card_emulation.dart';
// import 'package:smartclass_fyp_2024/nfc/nfc_host_card_emulation.dart';
// import 'package:smartclass_fyp_2024/nfc/nfc_host_card_emulation.dart';

class NfcClockInService {
  static late bool _initialized;
  static late NfcState _nfcState;
  static final int port = 0;
  static ValueNotifier<bool> isClockingIn = ValueNotifier(false);

  static Future<void> initNfc() async {
    _nfcState = await NfcHce.checkDeviceNfcState();

    if (_nfcState == NfcState.enabled) {
      await NfcHce.init(
        aid: Uint8List.fromList([0xA0, 0x00, 0xDA, 0xDA, 0xDA, 0xDA, 0xDA]),
        permanentApduResponses: true,
        listenOnlyConfiguredPorts: false,
      );
      _initialized = true;
      debugPrint('✅ NFC initialized');
    } else {
      _initialized = false;
      debugPrint('❌ NFC not enabled');
    }
  }

  static Future<void> startClockIn({
    required String studentId,
    required String courseCode,
    required String classId,
  }) async {
    if (!_initialized) {
      debugPrint('❌ NFC service not initialized. Please call initNfc first.');
      return;
    }

    if (_nfcState != NfcState.enabled) {
      debugPrint('❌ NFC is disabled.');
      return;
    }

    final data =
        Uint8List.fromList('$studentId|$courseCode|$classId'.codeUnits);

    try {
      await NfcHce.addApduResponse(port, data);
      debugPrint('✅ APDU response added');
    } catch (e) {
      debugPrint('❌ Error adding APDU: $e');
    }

    NfcHce.stream.listen((command) {
      debugPrint('📡 NFC Command Received: ${command.data}');
      isClockingIn.value = true;
      Future.delayed(const Duration(seconds: 10), () {
        isClockingIn.value = false;
      });
    });
  }

  static Future<void> stopClockIn() async {
    try {
      await NfcHce.removeApduResponse(port);
      debugPrint('🛑 NFC Clock-in cancelled');
    } catch (e) {
      debugPrint('❌ Error stopping NFC: $e');
    }
  }
}
